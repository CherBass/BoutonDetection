function [imageOut, meanImage, maxImage, sumImage, numFiles, imgInfo] = readTIFfiles()
% This function opens and reads TIF files and outputs information about the image 
%Outputs: 
%imageOut- 3D image as 'struct'
%meanImage- image mean as type 'cell', 
%maxImage- image max as type 'cell', 
%sumImage- image sum as type 'cell', 
%numFiles- number of files selected, 
%imgInfo- image info as type 'cell'

[filename, filepath, numFiles] = openImages();
if numFiles == 0
    display('Error: no files selected')
elseif numFiles == 1
    fullfilepath = strcat(filepath, filename);
    imgInfo = {imfinfo(char(fullfilepath))};
    
    %Extracts image information as 'double', and image mean as 'cell'
    for layer = 1:length(imgInfo{1})
        fullfilepath1 = char(fullfilepath);
        Image(:,:,layer)=imread(fullfilepath1,layer); 
    end
    meanImage={mean(Image ,3)}; %take the mean image
    maxImage={max(Image, [] ,3)}; %take the max image
    sumImage = {sum(Image ,3)}; %take the sum image
    imageOut(1).imageName = filename;
    imageOut(1).image = Image;
else
    for i = 1:numFiles
        Image = [];
        fullfilepath(i) = strcat(filepath, filename(i));
        imgInfo{i} = imfinfo(char(fullfilepath(i)));
        fieldName{i} = [filename{i}]; %fieldName{i} = ['image', int2str(i)];

        %Extracts image information as 'struct', and image mean as 'cell'
        for layer = 1:length(imgInfo{i})
            fullfilepath1 = char(fullfilepath(i));
            Image(:,:,layer)=imread(fullfilepath1,layer);
        end
        meanImage{i}=mean(Image,3);
        maxImage{i}=max(Image,[],3);
        sumImage{i}=sum(Image,3);
        imageOut(i).imageName = fieldName{i};
        imageOut(i).image = Image;
    end
end

end
