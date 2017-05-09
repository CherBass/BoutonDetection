function [ score ] = scoreBoutons( currBoutons,labelledBoutons, sizeImage, sizeBouton)
%SCORE calculates the accuracy of the bouton detector
%   Input:
%   currBoutons- matrix of x,y coordinates of the boutons
%   labelledBoutons- matrix of coordinates of bounding box
%   Output:
%   score- struct of TP, FP, FN
numTrueBoutons = size(labelledBoutons,1);
numDetectedBoutons = size(currBoutons,1);
correctBoutons=[];
TP = 0;
for i = 1:numTrueBoutons
    x1 = labelledBoutons(i,1); x2 = labelledBoutons(i,2); 
    y1 = labelledBoutons(i,3); y2 = labelledBoutons(i,4);
    for j = 1:numDetectedBoutons
        boutonX = currBoutons(j,1); boutonY = currBoutons(j,2);
        
        %check if any boutons in range
        if boutonX >= x1 &&  boutonX <= x2 && boutonY >= y1 &&  boutonY <= y2 
            if isempty(find(correctBoutons == j,1))
                TP = TP + 1;
                correctBoutons(TP) = j;
                break
            end
        end        
    end
end

score.numDetectedBoutons = numDetectedBoutons;
score.numTrueBoutons = numTrueBoutons;
score.TP = length(correctBoutons);
score.FP = numDetectedBoutons - score.TP;
score.FN = numTrueBoutons - score.TP;
%score.TN = numInterestPoints - score.TP - score.FP;
score.TN = sizeImage - (numDetectedBoutons * sizeBouton)  - (score.FN * sizeBouton);
score.accuracy = (score.TP + score.TN) / (score.TP + score.FP + score.FN + score.TN);

if score.TP == 0
    score.TPR =0;
    score.precision = 0;
    score.F1 = 0;
else
    score.TPR = score.TP / (score.TP + score.FN);
    score.precision = score.TP / (score.TP + score.FP);
    score.F1 = 2 * (score.precision * score.TPR) / (score.precision + score.TPR);
end
if score.FP == 0
    score.FPR = 0;
else
    score.FPR = score.FP / (score.FP + score.TN);
end



end

