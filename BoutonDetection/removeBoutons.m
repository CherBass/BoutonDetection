function [boutons] = removeBoutons(boutons, xRemove, yRemove)
%This function takes bouton locations, and coordinates of boutons to
%remove, and removes the closest boutons
%Inputs:
%boutons- matrix of x,y coordinates of current boutons
%xRemove- vector of x coordinates of boutons to removes
%yRemove- vector of y coordinates of boutons to removes
%Output:
%bouton- new bouton locations after adding extra boutons

toRemove = [xRemove,yRemove];
numToRemove = size(toRemove,1);
numBoutons = size(boutons,1);
    for i = 1:numToRemove
        for j = 1:numBoutons
        dist(j) = pdist([toRemove(i,:); boutons(j,:)], 'euclidean');
        end
        [~,locations(i)]= min(dist);
    end
    boutons(locations,:)=[];
end