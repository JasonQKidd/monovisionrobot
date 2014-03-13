function varargout = camera(varargin)
% CAMERA M-file for camera.fig
%      CAMERA, by itself, creates a new CAMERA or raises the existing
%      singleton*.
%
%      H = CAMERA returns the handle to a new CAMERA or the handle to
%      the existing singleton*.
%
%      CAMERA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CAMERA.M with the given input arguments.
%
%      CAMERA('Property','Value',...) creates a new CAMERA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before camera_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to camera_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help camera

% Last Modified by GUIDE v2.5 04-Mar-2012 00:18:41

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @camera_OpeningFcn, ...
                   'gui_OutputFcn',  @camera_OutputFcn, ...
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


% --- Executes just before camera is made visible.
function camera_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to camera (see VARARGIN)

% Choose default command line output for camera
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes camera wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = camera_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;





% --- Executes on button press in pushbutton4.
%打开摄像机1
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

axes(handles.axes1);
cla;
vid1=videoinput('winvideo',1,'YUY2_320x240');
vidRes1=get(vid1,'VideoResolution');
nBands1=get(vid1,'NumberOfBands');
set(vid1,'ReturnedColorSpace','rgb');
himage1=imshow(zeros(vidRes1(2),vidRes1(1),nBands1));
preview(vid1,himage1);

%set(vid1,'TriggerRepeat',1);
set(vid1,'ReturnedColorSpace','rgb');

start(vid1)

%stop(vid1)

setappdata(0,'ZFDVideo',vid1);




% --- Executes on button press in pushbb700.
function pushbb700_Callback(hObject, eventdata, handles)
% hObject    handle to pushbb700 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

vid1=getappdata(0,'ZFDVideo');

%data1=getdata(vid1,1);    
data1=getsnapshot (vid1); % 捕获图像
axes(handles.axes2);
imshow(data1);





% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
vid1=getappdata(0,'ZFDVideo');
stop(vid1);
stoppreview(vid1); closepreview(vid1);
rmappdata(0,'ZFDVideo');
delete(vid1);
delete(hObject);
