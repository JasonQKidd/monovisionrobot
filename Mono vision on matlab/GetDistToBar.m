function varargout = GetDistToBar(varargin)
% GETDISTTOBAR M-file for GetDistToBar.fig
%      GETDISTTOBAR, by itself, creates a new GETDISTTOBAR or raises the existing
%      singleton*.
%
%      H = GETDISTTOBAR returns the handle to a new GETDISTTOBAR or the handle to
%      the existing singleton*.
%
%      GETDISTTOBAR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GETDISTTOBAR.M with the given input arguments.
%
%      GETDISTTOBAR('Property','Value',...) creates a new GETDISTTOBAR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GetDistToBar_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GetDistToBar_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GetDistToBar

% Last Modified by GUIDE v2.5 14-May-2012 19:01:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GetDistToBar_OpeningFcn, ...
                   'gui_OutputFcn',  @GetDistToBar_OutputFcn, ...
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


% --- Executes just before GetDistToBar is made visible.
function GetDistToBar_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GetDistToBar (see VARARGIN)

% Choose default command line output for GetDistToBar
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GetDistToBar wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GetDistToBar_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function ShowDistancEdit_Callback(hObject, eventdata, handles)
% hObject    handle to ShowDistancEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ShowDistancEdit as text
%        str2double(get(hObject,'String')) returns contents of ShowDistancEdit as a double


% --- Executes during object creation, after setting all properties.
function ShowDistancEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ShowDistancEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function SystemParameters_Callback(hObject, eventdata, handles)
% hObject    handle to SystemParameters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%figure('SystemParametersForCameraInCar.fig')
SystemParametersForCameraInCar();


% --------------------------------------------------------------------
function Help_Callback(hObject, eventdata, handles)
% hObject    handle to Help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
help
msgbox('Please return to MATLAB Command Window for Help!','Help','help')

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(handles.pushbutton1,'string')=='启  动'
    
    if GetReadyToRun(handles)> 0
        set(handles.pushbutton1,'string','停  止');
        
        SystemRunning=100;
        setappdata(0,'SystemRunning',SystemRunning); 
        CountTheDistToBars();
        
    end
    
else
    set(handles.pushbutton1,'string','启  动');
    SystemRunning=-100;
    setappdata(0,'SystemRunning',SystemRunning); 

    
end



% --- Executes during object deletion, before destroying properties.
function figure1_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    MyCameraHandle=getappdata(0,'MyCameraHandle');
    if ~isempty(MyCameraHandle)   %如果已经打开过，则关掉
        stop(MyCameraHandle);
        stoppreview(MyCameraHandle); 
        closepreview(MyCameraHandle);
        rmappdata(0,'MyCameraHandle');
        delete(MyCameraHandle);
    end

%%    非回调函数区
function out=GetReadyToRun(handles)
out=-100;
%检查配置文件
    if isempty(ls('SystemParametersForCameraInCar.mat'))
        msgbox('当前目录下没能找到配置文件，请先进行系统配置！！！','温馨提示'); 
        return;
    end
%检查当前是否有可用串口


    axes(handles.ShowImageAxes); %指定原始图像显示位置
    cla;
%检查摄像机
    MyCameraHandle=videoinput('winvideo',1,'YUY2_640x480'); %
    vidRes1=get(MyCameraHandle,'VideoResolution');
    nBands1=get(MyCameraHandle,'NumberOfBands');
    set(MyCameraHandle,'ReturnedColorSpace','rgb');
    himage1=imshow(zeros(vidRes1(2),vidRes1(1),nBands1));
    


    CameraIsConnected=100;
    try preview(MyCameraHandle,himage1); %在指定位置预览原始图像
    catch ME
         CameraIsConnected=-100;
    end
    if CameraIsConnected < 0
        msgbox('当前电脑还没有连接摄像头，请确认...','温馨提示'); 
        return;    
    end
%打开摄像机
    start(MyCameraHandle);
    setappdata(0,'MyCameraHandle',MyCameraHandle);  %做为全局变量
    
    % ImageGray=getsnapshot (MyCameraHandle); % 捕获图像

out=100;
%获得距离数据表 
    load('SystemParametersForCameraInCar.mat'); %装载配置参量
    LengthC2C=CameraHeight/sin(AnglePitch); %像机光心至投影中心距离
    LengthO2C=CameraHeight*cot(AnglePitch); %世界坐标原点至投影中心距离
    ImageCenterC=ImageColumns/2;
    ImageCenterR=ImageRows/2;
    cosAngleRoll=cos(AngleRoll);
    sinAngleRoll=sin(AngleRoll);
    cosAnglePitch=cos(AnglePitch);
    sinAnglePitch=sin(AnglePitch);
    DistX=zeros(ImageRows,ImageColumns);
    DistY=DistX;
    for j=1:ImageRows
        IndexR=(ImageCenterR-j); %变换坐标系：图像坐标-->类 图像坐标   

        for k=1:ImageColumns;

            IndexC=(k-ImageCenterC);
            %按侧倾角旋转
            IndexRt=cosAngleRoll*IndexR - sinAngleRoll*IndexC;
            IndexC =sinAngleRoll*IndexR + cosAngleRoll*IndexC;
            %计算距离
            Tr=CameraFr*IndexRt;
            Dy=LengthC2C*Tr/(sinAnglePitch-Tr*cosAnglePitch);
            Dx=(LengthC2C+Dy*cosAnglePitch)*CameraFc*IndexC;
            %Dy=LengthO2C+Dy;
            DistX(j,k)=Dx;
            DistY(j,k)=Dy;
            
            %DistInImage(j,k)=sqrt(Dx^2+Dy^2);
        end
    end
    DistY=LengthO2C+DistY;
    DistInImage=sqrt(DistX.^2+DistY.^2);
    AngleInImage=atan(DistY./DistX); 
    %映射到 【0 pi】区间 
    k=AngleInImage<0;
    AngleInImage(k)=AngleInImage(k)+pi;
    
    figure; mesh(DistInImage); 
    setappdata(0,'DistInImage',DistInImage);  %做为全局变量
    setappdata(0,'AngleInImage',AngleInImage);   
    setappdata(0,'GUIShowHandles',handles);   
    
return;

function CountTheDistToBars()
% 本函数实现计算出目标左中右边界点与原点连线的角度，以及中间角度方向上边界至原点的距离
MyCameraHandle=getappdata(0,'MyCameraHandle');
GUIShowHandles=getappdata(0,'GUIShowHandles');
SystemRunning =getappdata(0,'SystemRunning'); 
DistInImage   =getappdata(0,'DistInImage');
AngleInImage  =getappdata(0,'AngleInImage');
  
    ImageGray=getsnapshot (MyCameraHandle); % 捕获图像
    ImageGray=rgb2gray(ImageGray);       
    [ImageRows,ImageColumns]=size(ImageGray);
ImageDelEdge=ones(ImageRows,ImageColumns);
ImageDelEdge(1:3,:)=0; 
ImageDelEdge(:,1:3)=0; 
ImageDelEdge(ImageRows-3:end,:)=0;
ImageDelEdge(:,ImageColumns-3:end)=0;

ImAeraNum=80;  %连通域像素个数 障碍面积
%低通滤波器
%LowPassFilter=fspecial('gaussian', [5 5], 0.6);
LowPassFilter=fspecial('average', [7 7]);
while(SystemRunning > 0)
    ImageGray=getsnapshot (MyCameraHandle); % 捕获图像
    ImageGray=rgb2gray(ImageGray);
    
   % ImageGray=medfilt2(ImageGray);  
    ImageGray = imfilter(ImageGray, LowPassFilter);
    ImageBW = edge(ImageGray,'prewitt');
    
    %去除连通域较小的部分，或者说障碍小得不影响小车前进
    ImageBW=bwareaopen(ImageBW,ImAeraNum);
    ImageBW =ImageBW & ImageDelEdge;
    %自下往上 自右往左 查找障碍连通域
   
    [AllRowsY,Temp]=find(ImageBW==1);
    SumCol=sum(ImageBW);
    Index=0;
    MaxRowsY=zeros(1,ImageColumns);
    for k=1:ImageColumns
        if SumCol(1,k)>0
            Index=Index+SumCol(1,k);
            MaxRowsY(1,k)=AllRowsY(Index); %找出最下方的边界行坐标           
        end
    end
	% 最大行坐标 边界滤波 
    MaxRowsY=medfilt1(MaxRowsY,5); %五点当中取中值
    % 查找区别障碍连通域  
    BarColBeginX=ones(1,ImageColumns);
    BarColEndX=BarColBeginX;
    BarNums=1;
    for k=2:ImageColumns
        Temp=MaxRowsY(1,k)-MaxRowsY(1,k-1);
        %终点情形一 高空
        if MaxRowsY(1,k)==0 && Temp < 0
            BarColEndX(1,BarNums)=k;
            continue;
        end
        
         %起点情形一 空高
        if MaxRowsY(1,k-1)==0 && Temp>0
            BarNums=BarNums+1;
            BarColBeginX(1,BarNums)=k;     
            continue;
        end    
        
        if MaxRowsY(1,k)>0 && abs(Temp)>5
            BarColEndX(1,BarNums)=k;
            BarNums=BarNums+1;
            BarColBeginX(1,BarNums)=k;           
            
        end

    end
    
    %提取边界 边界数组B 外边界数量N
    AngleBarN=zeros(BarNums,3);
    
    for k=1:BarNums 

        %计算每个障碍连通域 左 中 右边界与原点的夹角     
        AngleLeftX=BarColBeginX(1,k);   
        AngleLeftY=max(1,MaxRowsY(1,AngleLeftX));     %边界化处理，防止异常
        
        AngleRightX=BarColEndX(1,k);
        AngleRightY=max(1,MaxRowsY(1,AngleRightX)); 
        
        AngleMediX=round((AngleLeftX+AngleLeftY)/2);
        AngleMediY=max(1,MaxRowsY(1,AngleMediX)); 

        
        AngleBarN(k,1)=AngleLeftX;    
        AngleBarN(k,2)=AngleMediX;          
        AngleBarN(k,3)=AngleRightX;

       
        
    end    
	%在窗口区显示 
    set(GUIShowHandles.ShowDistancEdit,'string',num2str(AngleBarN));  





	 %数据下发或存档
    
    axes(GUIShowHandles.ShowObjectAxes); %不断地获取焦点，此语句不可外移至循环外面
    imshow(ImageBW);    
    axes(GUIShowHandles.ShowBarAxes);
    plot(MaxRowsY);
    SystemRunning =getappdata(0,'SystemRunning'); %获得终止条件
    
end
return;

%% dfdf


% --------------------------------------------------------------------
function com_Callback(hObject, eventdata, handles)

% hObject    handle to com (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
rs232debug();


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
linesgreen()
