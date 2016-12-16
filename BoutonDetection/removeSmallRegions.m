function [clearI] = removeSmallRegions(image, conn, threshold, disp)
%This function takes an image and removes regions smaller than the set
%threshold
%Inputs: 
%Image- mean projected image
%threshold- for region size, 
%conn- 4 or 8 connectivity, 
%plot-1 or 0 (yes/no) for plotting figures
%Output:
%clearI- image after removing small regions

if ~exist('threshold','var') 
    threshold = 10; 
end

if ~exist('conn','var') 
    conn = 8;
end

if ~exist('disp','var') 
    disp = 0;
end


connComps = bwconncomp(image,conn);
clearI = image;

for n=1:length(connComps.PixelIdxList) 
    if length(connComps.PixelIdxList{n}) < threshold
        clearI(connComps.PixelIdxList{n}) = 0;
    end
end

if disp == 1
    figure; imagesc(clearI); colormap(gray)
end
end