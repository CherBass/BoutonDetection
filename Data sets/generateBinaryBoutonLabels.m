%generateBinaryBoutonLabels
%This code generates binary images from .mat labelled files

load('Training- All boutons labelled.mat'); %load matlab file

numImages = length(labelingSession.ImageSet.ImageStruct);
for i = 1:numImages
    boutonBoundBox{i} = labelingSession.ImageSet.ImageStruct(i).objectBoundingBoxes;
    fileNames{i} = labelingSession.ImageSet.ImageStruct(i).ImageLabel;
    
    %Im{i} = imread([fileNames{i}, '.jpg']);
    numBoutons = size(boutonBoundBox{i},1);
    sizeImage = 512;
    %I = Im{i};
    boundingbox = boutonBoundBox{i};
    
    labelledImages(i).name = fileNames{i};
    tempLabelledImage = zeros(512);
    for b = 1:numBoutons
        width = boundingbox(b, 3); height = boundingbox(b, 4);
        x1 = boundingbox(b, 1); x2 = x1 + width;
        y1 = boundingbox(b, 2); y2 = y1 + height;
        
        %Check if out of boundary
        if x2 > sizeImage
            x2 = sizeImage;
        end
        
        if x1 < 1
            x2 = 1;
        end
        
        if y2 > sizeImage
            y2 = sizeImage;
        end
        
        if y1 < 1
            y2 = 1;
        end
        
        tempLabelledImage(y1:y2, x1:x2) = 1; %label bouton locations as 1
    end
    
    labelledImages(i).labelledImage = tempLabelledImage;
    save('Test data- 20 binary images', 'labelledImages');
    %imagesc(tempLabelledImage); colormap(gray);
    tempFileName = ['Image',num2str(i+20), '-labels.png']; axis off;
    imwrite(tempLabelledImage, tempFileName);
end

