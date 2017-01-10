%% runBoutonDetection
%Run this file to analyse images for boutons. Can load and analyse multiple
%TIFF files.

function [finalBoutons, meanImage] = runBoutonDetection()
%% Parameters to change
%change parameters according to the comments
Parameters.descriptor = 'Gabor';            %Options = 'Gabor', 'SIFT', 'HOG'
Parameters.interestPointDetector = 'SURF';  %Options = 'SURF', 'SIFT', 'harris'
find3D = 1;                                 %0= don't find 3D points, 1= find 3D points
Plot = 0;                                   %0= don't plot figures, 1=plot figures
Plot3D = 0;                                 %0= don't plot, 1=plot 3D image stacks 


%% Initialization of other parameters
Parameters.boutonMaskSize = 25;
Parameters.distThresh = 10;
sizeBouton = 25 * 25;
scoreThresh = -0.0399;

%% load any number of images
if  find3D == 1
    %Get images to be analysed
    [image3D, meanImage, ~, ~, numFiles, ~] = readTIFfiles();
else
    %Get images to be analysed
    [image3D, meanImage, ~, ~, numFiles, ~] = readTIFfiles();
end
for i = 1:size(image3D,2)
    finalBoutons(i).Image = image3D(i).imageName;
end
sizeImage = size(meanImage{1},1)*size(meanImage{1},2);

%% run bouton detection algorithm for all images loaded
for n = 1:numFiles
    tic
    [boutonLocations{n}, boutonScore(n)] = svmBoutonDetection(meanImage{n}, Parameters);
    scoreMax(n,1)= boutonScore(n).scoreMax;
    scoreMax(n,2)=abs(boutonScore(n).scoreMin);
    disp (['Image: ',num2str(n)]);
    toc
end

scoreMax = max(max(scoreMax));

%% save bouton information to finalBoutons

for n = 1: numFiles
    finalLabels = (boutonScore(n).score ./scoreMax) > scoreThresh ;
    image = meanImage{n};
    boutons = boutonLocations{n}(finalLabels,:);

    %save final boutons
    finalBoutons(n).Locations = boutons;
    
    %find corresponding bouton intensities
    for i = 1:length(boutons)
        intensities(i) = image(boutons(i,2),boutons(i,1));
    end
    finalBoutons(n).Intensities = intensities;    
    finalBoutons(n).removedBoutons=[];
end

%% Plot final figures
if Plot==1
    for n = 1:numFiles
        boutons = finalBoutons(n).Locations;
        imagesc(meanImage{n}); colormap(gray); title(['Image: ', num2str(n),'. Bouton detection following editing.']); 
        hold on;
        plot(boutons(:,1),boutons(:,2),'w+')
        axis off;
        pause(1);
    end
end
%% find 3D locations
%find the 3D boutons in the correct frames
if find3D == 1
    for n  = 1:numFiles
        boutonLocations = finalBoutons(n).Locations;
        currImage3D = image3D(n).image;
        [boutonLocations3D] = find3DBoutonLocation(boutonLocations, currImage3D, sizeBouton); 

        %Plot all boutons and frames
        if Plot3D == 1
            for f = 1:size(currImage3D,3)
                figure; imagesc(currImage3D(:,:,f)); colormap(gray); title(['Frame:', num2str(f)]); 
                hold on;
                boutonFrame = boutonLocations3D(:,3) == f; %find all boutons to plot in this frame
                plot(boutonLocations3D(boutonFrame,1),boutonLocations3D(boutonFrame,2),'g+')
                axis off; hold off;
                movegui('east');
            end
        end
    finalBoutons(n).Locations=boutonLocations3D;
    end
end


%% Save data
if find3D == 1
    save('parameters.mat', 'meanImage', 'find3D', 'image3D' ) 
else
    save('parameters.mat', 'meanImage', 'find3D' ) 
end

%saves data
save('Data.mat', 'finalBoutons' )

end