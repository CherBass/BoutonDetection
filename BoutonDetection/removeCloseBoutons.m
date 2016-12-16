function [boutonLocations] = removeCloseBoutons(boutonLocations, meanImage, distThresh)
%Removes boutons that are closer than distThresh- 1 iteration only
%Inputs:
%boutonLocations- matrix of x,y coordinates of boutons
%meanImage- mean projected image from TIFF stack
%distThresh- distance threshold for bouton removal
%Output:
%boutonLocations- new bouton locations

%Find distance between all boutons
D = pdist(boutonLocations);
relDist = squareform(D); %Convert to matrix form
delBoutons = relDist < distThresh;
delBoutons = delBoutons - diag(ones(length(delBoutons),1));
delBoutons = triu(delBoutons);
[row, col] = find(delBoutons); %boutons to be deleted

%Remove the bouton with the lower pixel value for each pair
if ~isempty(row) %if there are boutons for deletions
    del = 0;
    for i = 1:length(row)
        %choose centroid with lower pixel value for deletion
        minPixel = min(meanImage(round(boutonLocations(row(i)))), meanImage(round(boutonLocations(col(i)))));
        if minPixel == meanImage(round(boutonLocations(row(i))))
            del(i) = row(i);
        else del(i) = col(i);
        end
    end

    boutonLocations(del,:)=[];
end
end
