function boutonsResized = extractBoutonPatches(filename)
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
    boundingbox = boutonBoundBox{i};
    for b = 1:numBoutons
        width = boundingbox(b, 3); height = boundingbox(b, 4);
        x1 = boundingbox(b, 1); x2 = x1 + width;
        y1 = boundingbox(b, 2); y2 = y1 + height;
        
        %Check if out of boundary
        if x2 > size(I,1)
            x2 = size(I,1);
        end
        
        if x1 < 1
            x2 = 1;
        end
        
        if y2 > size(I,2)
            y2 = size(I,2);
        end
        
        if y1 < 1
            y2 = 1;
        end        
        boutons{t} = I(y1:y2, x1:x2);
        boutonsResized(:,:,t) = imresize(I(y1:y2, x1:x2), [25 25]);
        boutonSize(t) = width * height; 
        t = t+1;
    end
    close all;
end

averageBoutonSize = mean(boutonSize);
boutonsResized = double(boutonsResized);
    
end


