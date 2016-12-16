function [labelledImages] = extractEPBscoreBoutons(filename)
% This function opens bounding box information, and extracts the section 
%from their corresponding images

%% extract bounding boxes from training image labeler

load(filename);

numImages = length(labelingSession.ImageSet.ImageStruct);
t = 1;
for i = 1:numImages
    boutonBoundBox{i} = labelingSession.ImageSet.ImageStruct(i).objectBoundingBoxes;
    fileNames{i} = labelingSession.ImageSet.ImageStruct(i).ImageLabel;
    
    Im{i} = imread([fileNames{i}, '.jpg']);
    numBoutons = size(boutonBoundBox{i},1);
    I = Im{i};
    labelledImages(i).imageName = fileNames{i};

    for b = 1:numBoutons
        boundingbox = boutonBoundBox{i};
        width = boundingbox(b, 3); height = boundingbox(b, 4);
        x1 = boundingbox(b, 1); 
        y1 = boundingbox(b, 2); 
        
        if x1 > size(I,1)
            x1 = size(I,1);
        end
        
        if x1 < 1
            x1 = 1;
        end
        
        if y1 > size(I,2)
            y1 = size(I,2);
        end
        
        if y1 < 1
            y1 = 1;
        end        
        
        
        labelledImages(i).coord(b,2) = y1;
        labelledImages(i).coord(b,1) = x1;

        %boutons{t} = I(y1:y2, x1:x2);
        %figure(1);imagesc(boutons{t});colormap(gray); pause(1);
        t = t+1;
    end
    close all;
end
    
end