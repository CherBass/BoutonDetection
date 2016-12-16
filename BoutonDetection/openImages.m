function [filename, filepath, numFiles] = openImages()
% This function opens TIFF images and outputs file names, path and number of files opened
%Outputs:
%filename- name of file loaded
%filepath- file path
%numFiles- number of files loaded
[filename, filepath] = uigetfile('*.tif*', 'MultiSelect', 'on'); %select file manually- can select several files
if iscell(filename)
    numFiles = length(filename);
elseif filename == 0
    numFiles = 0;
else
    numFiles = 1;
end

end