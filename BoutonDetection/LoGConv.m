function [LoGImagePad, padSize] = LoGConv(image, Plot)
%This function convolves an image with the Laplacian of Gaussians mask
%Inputs:
%image- mean projected image
%Plot- 0 for don't plot, 1 for plot the generated bouton features
%Outputs:
%LoGImagePad- LoG image
%padSize- pad size used

%Initialize
hsize = [25,25]; % no upper bound here, min~[20,20]
sigma = 4; %relate the mask to the actual size of the bouton for sigma=4 only--> IG notch =0.31, which we want
L = fspecial('LoG',hsize,sigma);

boundaryPixels = mean(mean([image(:,1), image(:,end), image(1, :)', image(end, :)']));
padSize = round(hsize/2) + 10;
image = padarray(image,padSize,boundaryPixels,'both');

%set(gca,'FontSize',20)
%title('[30 30] LoG mask with std=4')
LoGImagePad = conv2(image,-L,'same');
%LoGImage = LoGImagePad((1+padSize):(end-padSize), (1+padSize):(end-padSize));

if Plot == 1
    figure; imagesc(LoGImagePad); colormap(gray);
    axis off;
    %set(gca,'FontSize',20)
    %title('LoG Image')
end
end
