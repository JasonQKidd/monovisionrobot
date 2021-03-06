function varargout = main(varargin)
% UNTITLED M-file for untitled.fig
%      UNTITLED, by itself, creates a new UNTITLED or raises the existing
%      singleton*.
%
%      H = UNTITLED returns the handle to a new UNTITLED or the handle to
%      the existing singleton*.
%
%      UNTITLED('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in UNTITLED.M with the given input arguments.
%
%      UNTITLED('Property','Value',...) creates a new UNTITLED or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before untitled_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to untitled_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help untitled

% Last Modified by GUIDE v2.5 01-May-2012 18:40:07

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @main_OpeningFcn, ...
                   'gui_OutputFcn',  @main_OutputFcn, ...
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


% --- Executes just before main is made visible.
function main_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to main (see VARARGIN)

% Choose default command line output for main
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes main wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = main_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function main_Callback(hObject, eventdata, handles)
% hObject    handle to main (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function open_Callback(hObject, eventdata, handles)
% hObject    handle to open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global vid
global im  
im = imread('009.jpg');
subplot(121),imshow(im);

% --------------------------------------------------------------------
function save_Callback(hObject, eventdata, handles)
% hObject    handle to save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global BW
[filename,pathname,filterindex]=uiputfile({'*.bmp';'*.tif';'*.png'},'save picture');%��
if filterindex==0
msgbox('You cancel saving picture!','Attention','warn'); 
figure
I=imread('err.jpg');
imshow(I);
else
str=[pathname filename];  %str root
imwrite(BW,str);  %write BW to str 
end
% --------------------------------------------------------------------
function exit_Callback(hObject, eventdata, handles)
% hObject    handle to exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(gcf)  %close Figure

% --------------------------------------------------------------------
function hui_Callback(hObject, eventdata, handles)
% hObject    handle to hui (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im1
global im
axes(handles.axes2);
[d1,d2,d3] = size(im); 
if(d3 > 1) 
im1= rgb2gray(im);
else
    msgbox('The original is gray piture!','Attention','warn');
end
imshow(im1);

% --------------------------------------------------------------------
function heibai_Callback(hObject, eventdata, handles)
% hObject    handle to heibai (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global BW
global im
imaqmem(30000000);
axes(handles.axes1);
vid=videoinput('winvideo',1,'YUY2_640x480');
set(vid,'TriggerRepeat',Inf);
set(vid,'FramesPerTrigger',1);
set(vid,'FrameGrabInterval',1);
set(vid,'ReturnedColorSpace','rgb');
vidRes=get(vid,'VideoResolution');
nBands=get(vid,'NumberOfBands');
hImage=image(zeros(vidRes(2),vidRes(1),nBands));
preview(vid,hImage);
im=getsnapshot (vid);
axes(handles.axes2);
imshow(im);
drawnow;


% --------------------------------------------------------------------
function jihe_Callback(hObject, eventdata, handles)
% hObject    handle to jihe (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function huidu_Callback(hObject, eventdata, handles)
% hObject    handle to huidu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --------------------------------------------------------------------
function lvbo_Callback(hObject, eventdata, handles)
% hObject    handle to lvbo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function help_Callback(hObject, eventdata, handles)
% hObject    handle to help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%open('help.txt');



% --------------------------------------------------------------------
function bianyuan_Callback(hObject, eventdata, handles)
% hObject    handle to bianyuan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --------------------------------------------------------------------
function Sobel_Callback(hObject, eventdata, handles)
% hObject    handle to Sobel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global BW
global im2
BW=edge(im2,'sobel');
subplot(1,2,2),imshow(BW),title('sobel');

% --------------------------------------------------------------------
function Prewitt_Callback(hObject, eventdata, handles)
% hObject    handle to Prewitt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global BW
global im2
BW=edge(im2,'prewitt');
BW2=bwareaopen(BW,90);
subplot(1,2,2),imshow(BW2),title('prewitt');

% --------------------------------------------------------------------
function Roberts_Callback(hObject, eventdata, handles)
% hObject    handle to Roberts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global BW
global im2
BW=edge(im2,'roberts');
BW2=bwareaopen(BW,40);
subplot(1,2,2),imshow(BW2),title('roberts');

% --------------------------------------------------------------------
function Log_Callback(hObject, eventdata, handles)
% hObject    handle to Log (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global BW
global im2
BW=edge(im2,'log');
subplot(1,2,2),imshow(BW),title('log');

% --------------------------------------------------------------------
function Zerocross_Callback(hObject, eventdata, handles)
% hObject    handle to Zerocross (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global BW
global im2
BW=edge(im2,'zerocross');
subplot(1,2,2),imshow(BW),title('zerocross');

% --------------------------------------------------------------------
function Canny_Callback(hObject, eventdata, handles)
% hObject    handle to Canny (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global BW
global im2
BW=edge(im2,'canny');
subplot(1,2,2),imshow(BW),title('canny');



% --------------------------------------------------------------------
function junzhi_Callback(hObject, eventdata, handles)
% hObject    handle to junzhi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im1
global im2
im2=filter2(fspecial('average',3),im1)/255;
subplot(1,2,2),imshow(im2);

% --------------------------------------------------------------------
function zhongzhi_Callback(hObject, eventdata, handles)
% hObject    handle to zhongzhi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im2
global im1
im2=medfilt2(im1);
subplot(1,2,2),imshow(im2);



% --------------------------------------------------------------------
function jiangxiang_Callback(hObject, eventdata, handles)
% hObject    handle to jiangxiang (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function zhuanzhi_Callback(hObject, eventdata, handles)
% hObject    handle to zhuanzhi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global BW
global im
BW=imrotate(im,90);
subplot(1,2,2),imshow(BW);

% --------------------------------------------------------------------
function xuanzhuan_Callback(hObject, eventdata, handles)
% hObject    handle to xuanzhuan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global BW
global im
BW=imrotate(im,30);
subplot(1,2,2),imshow(BW);
% --------------------------------------------------------------------
function suofang_Callback(hObject, eventdata, handles)
% hObject    handle to suofang (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --------------------------------------------------------------------
function pingyi_Callback(hObject, eventdata, handles)
% hObject    handle to pingyi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --------------------------------------------------------------------
function left_Callback(hObject, eventdata, handles)
% hObject    handle to left (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global BW
global im
se = translate(strel(1), [0 -20]); 
BW = imdilate(im,se); 
subplot(1,2,2),imshow(BW); 

% --------------------------------------------------------------------
function right_Callback(hObject, eventdata, handles)
% hObject    handle to right (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global BW
global im
se = translate(strel(1), [0 20]); 
BW = imdilate(im,se); 
subplot(1,2,2),imshow(BW); 



% --------------------------------------------------------------------
function up_Callback(hObject, eventdata, handles)
% hObject    handle to up (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global BW
global im
se = translate(strel(1), [-20 0]); 
BW = imdilate(im,se); 
subplot(1,2,2),imshow(BW); 

% --------------------------------------------------------------------
function down_Callback(hObject, eventdata, handles)
% hObject    handle to down (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global BW
global im
se = translate(strel(1), [20 0]); 
BW = imdilate(im,se); 
subplot(1,2,2),imshow(BW);



% --------------------------------------------------------------------
function X_Callback(hObject, eventdata, handles)
% hObject    handle to X (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global BW
global im
axes(handles.axes1);
BW = fliplr(im);
imshow(BW);

% --------------------------------------------------------------------
function Y_Callback(hObject, eventdata, handles)
% hObject    handle to Y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global BW
global im
BW = flipud(im);
subplot(1,2,2),imshow(BW);

% --------------------------------------------------------------------
function fangda_Callback(hObject, eventdata, handles)
% hObject    handle to fangda (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global BW
global im
BW=imresize(im,2);
subplot(1,2,2),imshow(BW);

% --------------------------------------------------------------------
function suoxiao_Callback(hObject, eventdata, handles)
% hObject    handle to suoxiao (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global BW
global im
BW=imresize(im,0.5);
subplot(1,2,2),imshow(BW);



% --------------------------------------------------------------------
function xitong_Callback(hObject, eventdata, handles)
% hObject    handle to xitong (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
help
msgbox('Please return to MATLAB Command Window for Help!','Help','help')

% --------------------------------------------------------------------
function wenjian_Callback(hObject, eventdata, handles)
% hObject    handle to wenjian (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
open('help.txt');




% --------------------------------------------------------------------
function set_Callback(hObject, eventdata, handles)
% hObject    handle to set (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global BW
global BW2
global im
[H,T,R]=hough(BW2);
imshow(H,[],'XData',T,'YData',R,'InitialMagnification','fit');
xlabel('\theta'),ylabel('\rho');
axis on,axis normal,hold on
P=houghpeaks(H,5,'threshold',ceil(0.3*max(H(:))));
x=T(P(:,2));y=R(P(:,1));
plot(x,y,'s','color','white');
lines=houghlines(BW2,T,R,P,'FillGap',30,'MinLength',20);
figure,imshow(rotI),hold on  
max_len=0;
for k=1:length(lines)
    xy=[lines(k).point1;lines(k).point2];
    plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
    plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
    plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
    len=norm(lines(k).point1-lines(k).point2);
    if (len>max_len)
        max_len=len;
        xy_long=xy;
    end
end

% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 scom=serial('com1');
 scom.Timeout=0.5;
  fopen(scom);
  A=fscanf(scom,'%d',[10,100]);
  Fprintf(scom,'%s','RS121','async');
  clear scom;
% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function qudian_Callback(hObject, eventdata, handles)
% hObject    handle to qudian (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global BW
global im2
global im3
se=strel('square',2);
bb=imclose(im2,se);
im3=imopen(bb,se);
B=strel('square',4);

function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end





% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
