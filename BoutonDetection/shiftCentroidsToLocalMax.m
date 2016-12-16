function [boutonLocations] = shiftCentroidsToLocalMax(boutonLocations, meanImage, shiftCentroid)
%This function shifts bouton centres to their local maximum
%Inputs:
%boutonLocations- matrix of x,y coordinates of boutons
%meanImage- mean projected image from TIFF stack
%shiftCentroid- 0 for don't shift, 1 for shift
%Output:
%boutonLocations- new bouton locations
if shiftCentroid == 1
    
    meanPixel = mean(mean(meanImage));
    stdPixel = std(std(meanImage));
    
    boundPixels = 20;
    numBoutons2 = length(boutonLocations);
    highestPixelVal = 0;

    %Iterate through all location in the specified radius, and shift centroid
    %to maximum intensity
    for n = 1:numBoutons2
        
        %Select search boundary based on pixel intensity
        pixelVal = meanImage(round(boutonLocations(n,2)), round(boutonLocations(n,1)));
        if pixelVal > meanPixel + stdPixel
            boundPixels = 15;
        elseif pixelVal < meanPixel + stdPixel
            boundPixels = 25;
        else
            boundPixels = 20;
        end
        
        %Iterate through boundary to find max pixel 
        for x = -round(boundPixels/2):1:round(boundPixels/2);

            for y = -round(boundPixels/2):1:round(boundPixels/2);
                xLocationCurr = round(boutonLocations(n,1) + x);
                yLocationCurr = round(boutonLocations(n,2) + y);
                
                
                if xLocationCurr > size(meanImage,1)
                    xLocationCurr = size(meanImage,1);
                end

                if xLocationCurr < 1
                    xLocationCurr = 1;
                end

                if yLocationCurr > size(meanImage,2)
                    yLocationCurr = size(meanImage,2);
                end

                if yLocationCurr < 1
                    yLocationCurr = 1;
                end        
                
                currPixelVal = meanImage(yLocationCurr, xLocationCurr);
                if currPixelVal > highestPixelVal
                    highestPixelVal = currPixelVal;
                    xLocation = xLocationCurr;
                    yLocation = yLocationCurr;
                end
            end
        end
        boutonLocations(n,1) = xLocation; boutonLocations(n,2) = yLocation;
        highestPixelVal = 0;
    end
end

end
