function [boutonLocations3D] = find3DBoutonLocation(boutonLocations, image3D, boutonSize)
%This function finds the 3D location of boutons by check the frames with
%highest sum of pixels
%Inputs:
%boutonLocations- matrix of x,y coordinates of boutons
%image3D- 3D image matrix
%boutonSize- size of boutons
%Output:
%boutonLocations3D- 3D bouton locations


numBoutons = size(boutonLocations,1);
boutonLocations3D = zeros(numBoutons,3);
sizeImage = size(image3D,1);
%Iterate throuogh all boutons to find their location
for i = 1:numBoutons
    sumPixels = zeros(size(image3D,3),1);
    %check sum of each frame
    for f = 1:size(image3D,3)
        x1 = boutonLocations(i,1) - round(boutonSize/2);
        x2 = boutonLocations(i,1) + round(boutonSize/2);
        y1 = boutonLocations(i,2) - round(boutonSize/2);
        y2 = boutonLocations(i,2) + round(boutonSize/2);
        
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
        
        sumPixels(f) = sum(sum(image3D(y1:y2,x1:x2,f)));
    end
    boutonLocations3D(i,1:2) = boutonLocations(i,:);
    [~, bestFrame] = max(sumPixels);
    boutonLocations3D(i,3) = bestFrame;

end


end
