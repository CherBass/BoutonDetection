function [boutonLocations, score] = svmBoutonDetection(meanImage, Parameters)
%This function takes a 2D image (double) of a neuron process with
%boutons, and detects them using initially SURF feature detection, and then an SVM
%Inputs: 
%meanImage- mean projected image
%Paramaters- a set of pramaters as a 'struct'
%Output: 
%boutonLocations- Bouton locations (x,y)
%score- a 'struct' of the SVM scores for each candidate bouton
%% Initialize variables

sizeImage = size(meanImage,1);
shiftCentroid = 1;
crossval = 1;
Plot = 0; 
boutonSize = Parameters.boutonMaskSize;
distThresh = Parameters.distThresh;
descriptor = Parameters.descriptor;
detector = Parameters.interestPointDetector;

if Plot == 1
    figure; imagesc(meanImage); colormap(gray); axis off; %title('Mean Image');
end

%% Laplacian of Gaussians convolution
[LoGImage, padSize] = LoGConv(meanImage, Plot); %convolve image with LoG mask
LoGNorm = LoGImage / max((LoGImage(:)));

%% Get bouton centroids using an interest point detector

if strcmp(detector, 'SURF')
    %SURF keypoints
    SURFPoints = detectSURFFeatures(LoGNorm);
    SURFLocations = SURFPoints.Location;
    SURFLocations = SURFLocations - padSize(1);
    detectorLocations.SURF = SURFLocations;
    interestPoints = SURFLocations;
    
elseif strcmp(detector, 'harris')
    %Harris keypoints
    harrisPoints = detectHarrisFeatures(meanImage);
    harrisLocations = harrisPoints.Location;
    harrisLocations = harrisLocations - padSize(1);
    detectorLocations.harris = harrisLocations;
    interestPoints = harrisLocations;
    
elseif strcmp(detector, 'SIFT')
    %SIFT keypoints
    [SIFTPoints, SIFTFeatures] = vl_sift(single(meanImage));
    [~, indexFeatures] = sort(sum(SIFTFeatures,1), 'ascend');
    SIFTLocations = SIFTPoints(1:2,indexFeatures(1:100))';
    SIFTLocations = SIFTLocations - padSize(1);
    detectorLocations.SIFT = SIFTLocations;
    interestPoints = SIFTLocations;
end    

%check all points are positive
[row,~] = find(interestPoints < 1);
interestPoints(row,:) = [];
[row,~] = find(interestPoints > sizeImage);
interestPoints(row,:) = [];

%% Shift centroids to local maximum

%shift interest points to their local max
[boutonLocations] = shiftCentroidsToLocalMax(interestPoints, meanImage, shiftCentroid);

%% Discard close boutons
%remove boutons closer than distThresh. Bouton with the lower pixel
%intensity is removed

[boutonLocations] = removeAllCloseBoutons(boutonLocations, meanImage, distThresh);

%Plot new bouton locations
if Plot == 1
    figure; imagesc(meanImage); colormap(gray); hold on;
    plot(boutonLocations(:,1),boutonLocations(:,2),'r+')
end
%% Extract bouton patches
%Extract the bouton patches using the bouton locations extracted

[boutonPatch] = extractBoutonPatch(boutonLocations, boutonSize, sizeImage, meanImage, Plot);

%% Generate features and run SVM

%Generate a gabor feature vector for each bouton patch for classification
if strcmp(descriptor, 'Gabor')
    numBoutons3 = length(boutonLocations);
    for n = 1:numBoutons3
        gaborVector(n,:) = getGaborFeatures(boutonPatch(:,:,n), Plot);
    end
    
    SVMModels = load('GaborModel.mat');

    if crossval == 1
        SVMModel = SVMModels.CVSVM;
    else
        SVMModel = SVMModels.SVMModel;
    end
    [SVMlabel, scoreTemp]= predict(SVMModel, gaborVector);
    %finalLabels = scoreTemp(:,2) > scoreThresh;
    scoreTemp = scoreTemp(:,2);
    score.scoreMax = max(scoreTemp);
    score.scoreMin = min(scoreTemp);
    score.scoreAverage = mean(scoreTemp);
    score.score = scoreTemp;
    finalLabels = SVMlabel > 0;

    
    %Generate HOG features and run SVM
elseif strcmp (descriptor, 'HOG')
    mrmrFeatures = load('MrmrHOG.mat');
    mrmrHOGIndex = mrmrFeatures.mrmrFeatures;    
    numBoutons3 = length(boutonLocations);
    for n = 1:numBoutons3
         features = extractHOGFeatures(boutonPatch(:,:,n));
         HOGVector(n,:) = features(mrmrHOGIndex);
    end
    
    %% Normalize
    
    PossibleNorms = {'ColMax','Col2norm','Col1norm','Exp2normMax',...
    'ExpCellMax','ExpInfNorm'};

    featureStruct.NCells = size(HOGVector, 2);
    featureStruct.NExamples = size(HOGVector, 1);
    featureStruct.Activity = HOGVector';


    ActStruct = normaliseacts(featureStruct,PossibleNorms{2});

    finalFeatures = ActStruct.Activity;
    HOGVector= finalFeatures';

    
    %% SVM
    SVMModels = load('HOGModel.mat');
    SVMModel = SVMModels.CVSVM;
    [SVMlabel, scoreTemp]= predict(SVMModel, HOGVector);
    scoreTemp = scoreTemp(:,2);
    score.scoreMax = max(scoreTemp);
    score.scoreMin = min(scoreTemp);
    score.scoreAverage = mean(scoreTemp);
    score.score = scoreTemp;
    finalLabels = SVMlabel > 0;
    
%Generate SIFT features
elseif strcmp (descriptor, 'SIFT')
    mrmrFeatures = load('MrmrSIFT.mat');
    mrmrSIFTIndex = mrmrFeatures.mrmrFeatures;    
    numBoutons3 = length(boutonLocations);
    for n = 1:numBoutons3
        [~, SIFTFeatures] = vl_sift(single(boutonPatch(:,:,n)));
        features = sum(SIFTFeatures,2);
        SIFTVector(n,:) = features(mrmrSIFTIndex);
    end
    %% Normalize
    PossibleNorms = {'ColMax','Col2norm','Col1norm','Exp2normMax',...
    'ExpCellMax','ExpInfNorm'};

    featureStruct.NCells = size(SIFTVector, 2);
    featureStruct.NExamples = size(SIFTVector, 1);
    featureStruct.Activity = SIFTVector';


    ActStruct = normaliseacts(featureStruct,PossibleNorms{6});

    finalFeatures = ActStruct.Activity;
    SIFTVector= finalFeatures';
    
    %% SVM
    SVMModels = load('SIFTModel.mat');
    SVMModel = SVMModels.CVSVM;
    [SVMlabel, scoreTemp]= predict(SVMModel, SIFTVector);
    scoreTemp = scoreTemp(:,2);
    score.scoreMax = max(scoreTemp);
    score.scoreMin = min(scoreTemp);
    score.scoreAverage = mean(scoreTemp);
    score.score = scoreTemp;
    finalLabels = SVMlabel > 0;
end

%save boutons in finaBoutons (x,y)
finalBoutons = boutonLocations(finalLabels,:);

%% Plot all bouton patches found
if Plot ==1
    for i = 1:numBoutons3
        imagesc(boutonPatch(:,:,i))
        display(i);
        pause;
    end

    close all;
end

%% Plot final bouton locations
if Plot == 1
    figure; imagesc(meanImage); colormap(gray); title('Bouton detection after SVM'); 
    hold on;
    plot(finalBoutons(:,1),finalBoutons(:,2),'w+')
    axis off;
    movegui('west');

    hold off;
    figure; imagesc(meanImage); colormap(gray); title('Bouton detection before SVM'); 
    hold on;
    plot(boutonLocations(:,1),boutonLocations(:,2),'r+')
    axis off;
    movegui('east');
end
end


