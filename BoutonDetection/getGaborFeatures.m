function gaborVector = getGaborFeatures(patch, Plot)
%Generates a feature vector based on gabor jet
%Inputs:
%patch- bouton patch used for generating gabor features
%Plot- 0 for don't plot, 1 for plot the generated bouton features
%Output:
%gaborVector- the generated gabor feature vector

j=1;
for angle = -180:15:-15 
    Eim =  spatialgabor(patch, 1.05, angle, 5, 2.5, 0);
    gaborVector(j) = sum(sum(Eim));
    if Plot == 1
        figure;
        imagesc(Eim);
        axis off;
        title('bouton features');
    end
    j=j+1;
end

end