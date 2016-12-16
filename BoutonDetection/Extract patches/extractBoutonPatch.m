function [boutonPatch] = extractBoutonPatch(boutonLocations, boutonSize, sizeImage, meanImage, Plot)
%This function extracts a bouton patch from an image
%Inputs: 
%boutonLocations- matrix of x,y coordinates of boutons
%boutonSize- size of boutons
%sizeImage- size of image
%meanImage- mean projected image from TIFF stack
%Plot- 0 for don't plot, 1 for plot
%Ouput:
%boutonPatch- the bouton patch image
numBoutons3 = length(boutonLocations);
boutonPatch = zeros(boutonSize,boutonSize,numBoutons3);

for i = 1:numBoutons3
    x1 = round(boutonLocations(i,1) - round(boutonSize/2));
    x2 = round(boutonLocations(i,1) + round(boutonSize/2));
    y1 = round(boutonLocations(i,2) - round(boutonSize/2));
    y2 = round(boutonLocations(i,2) + round(boutonSize/2));

    %Ensure indeces are within the image margins
    if x1 <= 0
        x1 = 1;
    end
    if y1 <= 0
        y1 = 1;
    end
    if x2 > sizeImage
        x2 = round(sizeImage);
    end
    if y2 > sizeImage
        y2 = round(sizeImage);
    end

    
    boutonPatch(:,:,i) = imresize(meanImage(y1:y2,x1:x2),[boutonSize boutonSize]);
    if Plot == 1
        figure;
        imagesc(boutonPatch(:,:,i));
        colormap(gray);
        axis off;
        %title('bouton patches');
    end
end


end