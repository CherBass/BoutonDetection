function [backAdjustedImage] = adjustedBackground(image, meanImage, Plot)
%This function takes an images, and return a background adjusted image
%Inputs: 
%image- 3D image stack
%meanImage- mean projected image from TIFF stack
%Plot- 0 for don't plot, 1 for plot figures
%Output:
%backAdjustedImage- background adjusted image


nonZeroIndex = image > 0;

% Minimum dendrite pixel adjusted background
minNonzero = min(min((image(nonZeroIndex))));

% Alternatively: mean pixel value adjusted background
backAdjustedImage = zeros(size(meanImage));
backAdjustedImage(image == 0) = minNonzero;
backAdjustedImage(image > 0) = image(image > 0);

if Plot == 1
    figure(5); imagesc(backAdjustedImage); colormap(gray);
    set(gca,'FontSize',15)
    title('Background adjusted image')
end
end
