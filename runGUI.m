function varargout = runGUI(varargin)
% RUNGUI MATLAB code for runGUI.fig
%      RUNGUI, by itself, creates a new RUNGUI or raises the existing
%      singleton*.
%
%      H = RUNGUI returns the handle to a new RUNGUI or the handle to
%      the existing singleton*.
%
%      RUNGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RUNGUI.M with the given input arguments.
%
%      RUNGUI('Property','Value',...) creates a new RUNGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before runGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to runGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help runGUI

% Last Modified by GUIDE v2.5 20-Dec-2016 10:16:12

% Begin initialization code - DO NOT EDIT

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @runGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @runGUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT



% --- Executes just before runGUI is made visible.
function runGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to runGUI (see VARARGIN)

% Choose default command line output for runGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes runGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = runGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in detect.
function detect_Callback(hObject, eventdata, handles)
% hObject    handle to detect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[finalBoutons, meanImage] = runBoutonDetection();
boutons = finalBoutons(1).Locations;
imagesc(meanImage{1});colormap(gray);
hold on;
plot(boutons(:,1),boutons(:,2),'g+')
display('done')
n=1;
save('currentImage.mat', 'n') 




% --- Executes on button press in addBoutons.
function addBoutons_Callback(hObject, eventdata, handles)
% hObject    handle to addBoutons (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load('Data.mat');
load('parameters.mat')
load('currentImage.mat');

%add new boutons
boutons = finalBoutons(n).Locations;
[xAdd,yAdd] = ginput;
locationsAdd = [xAdd,yAdd];
if ~isempty(locationsAdd)
    locationsAdd = addBoutons(locationsAdd, meanImage{n});
    if find3D == 1
        [locationsAdd] = find3DBoutonLocation(locationsAdd, image3D(n).image, 625); 
    end
    boutons = [boutons; locationsAdd];
end
imagesc(meanImage{n});colormap(gray);
plot(boutons(:,1),boutons(:,2),'g+')
finalBoutons(n).Locations = boutons;

%find corresponding bouton intensities
image = meanImage{n};
for i = 1:length(boutons)
    intensities(i) = image(boutons(i,2),boutons(i,1));
end
finalBoutons(n).Intensities = intensities;    

save('Data.mat', 'finalBoutons') 


% --- Executes on button press in removeBoutons.
function removeBoutons_Callback(hObject, eventdata, handles)
% hObject    handle to removeBoutons (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load('Data.mat');
load('parameters.mat')
load('currentImage.mat');

%remove boutons selected
boutons = finalBoutons(n).Locations;
[xRemove,yRemove] = ginput;
if ~isempty(xRemove)
    boutons = removeBoutons(boutons, xRemove, yRemove);
end
imagesc(meanImage{n});colormap(gray);
plot(boutons(:,1),boutons(:,2),'g+')
finalBoutons(n).Locations = boutons;

%find corresponding bouton intensities
image = meanImage{n};
for i = 1:length(boutons)
    intensities(i) = image(boutons(i,2),boutons(i,1));
end
finalBoutons(n).Intensities = intensities;    

save('Data.mat', 'finalBoutons') 


% --- Executes on button press in contrast.
function contrast_Callback(hObject, eventdata, handles)
% hObject    handle to contrast (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
imcontrast(gca);



function numImage_Callback(hObject, eventdata, handles)
% hObject    handle to numImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of numImage as text
%        str2double(get(hObject,'String')) returns contents of numImage as a double
n = str2double(get(hObject,'String'));
load('Data.mat');
load('parameters.mat')
boutons = finalBoutons(n).Locations;
imagesc(meanImage{n});colormap(gray);
plot(boutons(:,1),boutons(:,2),'g+')
save('currentImage.mat', 'n') 


% --- Executes during object creation, after setting all properties.
function numImage_CreateFcn(hObject, eventdata, handles)
% hObject    handle to numImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
