
function [boutonLocations] = removeAllCloseBoutons(boutonLocations, meanImage, distThresh)
%Removes boutons that are closer than distThresh, until there are none left
%Inputs:
%boutonLocations- matrix of x,y coordinates of boutons
%meanImage- mean projected image from TIFF stack
%distThresh- distance threshold for bouton removal
%Output:
%boutonLocations- new bouton locations

while 1
    %Find distance between all boutons
    D = pdist(boutonLocations);
    relDist = squareform(D); %Convert to matrix form
    delBoutons = relDist < distThresh;
    delBoutons = delBoutons - diag(ones(length(delBoutons),1));
    [row, col] = find(delBoutons); %boutons to be deleted

    %Take the maximum number of two close boutons to be deleted- delete 1 of
    %each pair
    if not(isempty(row)) %if there are boutons for deletions
        del = 0;
        j=1;
        for i = 1:length(row)
            if  any(row(i) == del) || any(col(i) == del)
            else
                %choose centroid with lower pixel value for deletion
                minPixel = min(meanImage(round(boutonLocations(row(i)))), meanImage(round(boutonLocations(col(i)))));
                if minPixel == meanImage(round(boutonLocations(row(i))))
                    del(j) = row(i);
                else del(j) = col(i);
                end
                %del(j) = max(row(i), col(i)); %choose maximum neuron for deletion
                j=j+1;
            end
        end

        boutonLocations(del,:)=[];
    else
        break
    end
end

end