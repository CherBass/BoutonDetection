%% Analyse boutons

clear all;close all;

%Initialization
Parameters.boutonMaskSize = 25;
Parameters.distThresh = 10;
Parameters.descriptor = 'Gabor';
Parameters.interestPointDetector = 'SURF';
sizeBouton = 25*25;
%Get images to be analysed
[~, meanImage, ~, ~, numFiles, ~] = readTIFfiles();

sizeImage = size(meanImage{1},1)*size(meanImage{1},2);

    
%% Get detected bouton centroids

tic 
for n = 1:numFiles
    tic
    [boutonLocations{n},boutonScore(n)] = svmBoutonDetection(meanImage{n}, Parameters);
    scoreMax(n,1)= boutonScore(n).scoreMax;
    scoreMax(n,2)=abs(boutonScore(n).scoreMin);
    disp (n);
    close all;
    toc
end

scoreMax = max(max(scoreMax));
toc
%% save
%save('boutonLocations-AllPoints10-1.mat', 'finalLocations', 'boutonLocations', 'detectorLocations', 'boutonScore')

%% find max scores
for n = 1:numFiles
    scoreMax(n,1)= boutonScore(n).scoreMax;
    scoreMax(n,2)=abs(boutonScore(n).scoreMin);
end
scoreMax = max(max(scoreMax));

%% Iterate over bouton score thresholds

%Initialize
boutonScoreThresh = linspace(-1.0001,1.0001,10000); %linspace(-0.2,0.1,100);
%best for 10000- 4801
%best for 100- location 66, [-0.00303030303030299], F1: 0.8414, accuracy:
%0.7871
%best for Gabor 10k-[-0.0257051405140514] f1=0.8398
accuracyPerImage = zeros(length(boutonScoreThresh),1);
TPRPerImage = zeros(length(boutonScoreThresh),1);
FPRPerImage = zeros(length(boutonScoreThresh),1);
accuracyPerBouton = zeros(length(boutonScoreThresh),1);
TPRPerBouton = zeros(length(boutonScoreThresh),1);
precisionAll = zeros(length(boutonScoreThresh),1);
F1all =  zeros(length(boutonScoreThresh),1);
ik = 1; %keep track of iterations

for k = boutonScoreThresh(4994)
        
    for n = 1: numFiles
        finalLabels = (boutonScore(n).score ./scoreMax) > k ;
        finalBoutons{n} = boutonLocations{n}(finalLabels,:);
    end


    %% get accuracy and plot

    %[labelledImages] = extractTestBoutons('test data2- 20 images'); %('TestData1- 46 images'); 
    [labelledImages] = extractTestBoutons('NewDataGroundTruthLabels1'); %labels of new data
    
    accuracy = zeros(numFiles,1);
    TPR = zeros(numFiles,1);
    FPR = zeros(numFiles,1);
    TP = zeros(numFiles,1);
    FP = zeros(numFiles,1);
    FN = zeros(numFiles,1);
    F1 = zeros(numFiles,1);
    precision = zeros(numFiles,1);
    numBoutons = zeros(numFiles,1);
    for i = 1:numFiles
        currBoutons = finalBoutons{1,i};
        labelledBoutons = labelledImages(i).boundingbox;
        
        %Get scores of detected boutons
        score(i) = scoreBoutons(currBoutons,labelledBoutons, sizeImage, sizeBouton);
        accuracy(i) = score(i).accuracy;
        TPR(i) = score(i).TPR;
        FPR(i) = score(i).FPR;
        TP(i) = score(i).TP;
        FP(i) = score(i).FP;
        FN(i) = score(i).FN;
        numBoutons(i) = score(i).numTrueBoutons;
        F1(i) = score(i).F1;
        precision(i) = score(i).precision;
        %Plot detected boutons and a rectangle around the True Positives
        w = labelledImages(i).width(:);
        h = labelledImages(i).height(:);
        x = labelledImages(i).boundingbox(:,1);
        y = labelledImages(i).boundingbox(:,3);

        if 1
            figure; imagesc(meanImage{i}); colormap(gray); axis off; %title('Bouton detection after SVM'); 
            hold on
            plot(currBoutons(:,1),currBoutons(:,2),'r+')
            for j = 1:length(x)
                rectangle('Position',[x(j),y(j),w(j),h(j)], 'LineWidth',2, 'EdgeColor', 'w');
            end
            hold off

        end
    end
    
    %Accuracy measures
    F1all(ik) = mean(F1);
    accuracyPerImage(ik) = mean(accuracy);
    TPRPerImage(ik) = mean(TPR);
    FPRPerImage(ik) = mean(FPR);
    accuracyPerBouton(ik) = sum(TP) / (sum(numBoutons) + sum(FP) + sum(FN));
    TPRPerBouton(ik) = sum(TP) / sum(numBoutons);
    precisionAll(ik)= mean(precision);
    disp(['iteration ', num2str(ik)])
    
    ik = ik +1;
end

%% Plot ROC curve
figure;
plot(TPRPerImage, precisionAll, '-b', 'LineWidth',2 );
title('Precision-Recall Curve for bouton detection');
xlabel('Recall'); ylabel('Precision');
hold on;
axis([0,1,0,1]);

figure;
plot(FPRPerImage, TPRPerImage, '-r', 'LineWidth',2 );
title('ROC Curve for bouton detection');
xlabel('FPR'); ylabel('TPR');
hold on;
axis([0,0.00005,0,1]);

%% Save

%save('NewDataAnalysis-10k.mat', 'FPRPerImage', 'TPRPerImage', 'precisionAll', 'boutonScoreThresh', 'accuracyPerImage', 'F1all')