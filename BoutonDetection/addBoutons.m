function [boutons] = addBoutons(boutons, Image)
%This function shifts bouton centres to their local maximum
%Inputs:
%boutons- matrix of x,y coordinates of boutons
%Image- mean projected image from TIFF stack
%Output:
%bouton- new bouton locations after adding extra boutons
    
meanPixel = mean(mean(Image));
stdPixel = std(std(Image));

boundPixels = 5;
numBoutons2 = size(boutons,1);
highestPixelVal = 0;

%Iterate through all location in the specified radius, and shift centroid
%to maximum intensity
for n = 1:numBoutons2


    %Iterate through boundary to find max pixel 
    for x = -round(boundPixels/2):1:round(boundPixels/2);

        for y = -round(boundPixels/2):1:round(boundPixels/2);
            xLocationCurr = round(boutons(n,1) + x);
            yLocationCurr = round(boutons(n,2) + y);


            if xLocationCurr > size(Image,1)
                xLocationCurr = size(Image,1);
            end

            if xLocationCurr < 1
                xLocationCurr = 1;
            end

            if yLocationCurr > size(Image,2)
                yLocationCurr = size(Image,2);
            end

            if yLocationCurr < 1
                yLocationCurr = 1;
            end        

            currPixelVal = Image(yLocationCurr, xLocationCurr);
            if currPixelVal > highestPixelVal
                highestPixelVal = currPixelVal;
                xLocation = xLocationCurr;
                yLocation = yLocationCurr;
            end
        end
    end
    boutons(n,1) = xLocation; boutons(n,2) = yLocation;
    highestPixelVal = 0;
end


end
