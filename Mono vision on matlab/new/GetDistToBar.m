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

if get(handles.pushbutton1,'string')=='��  ��'
    
    if GetReadyToRun(handles)> 0
        set(handles.pushbutton1,'string','ͣ  ֹ');
        
        SystemRunning=100;
        setappdata(0,'SystemRunning',SystemRunning); 
        CountTheDistToBars();
        
    end
    
else
    set(handles.pushbutton1,'string','��  ��');
    SystemRunning=-100;
    setappdata(0,'SystemRunning',SystemRunning); 

    
end



% --- Executes during object deletion, before destroying properties.
function figure1_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    MyCameraHandle=getappdata(0,'MyCameraHandle');
    if ~isempty(MyCameraHandle)   %����Ѿ��򿪹�����ص�
        stop(MyCameraHandle);
        stoppreview(MyCameraHandle); 
        closepreview(MyCameraHandle);
        rmappdata(0,'MyCameraHandle');
        delete(MyCameraHandle);
    end

%%    �ǻص�������
function out=GetReadyToRun(handles)
out=-100;
%��������ļ�
    if isempty(ls('SystemParametersForCameraInCar.mat'))
        msgbox('��ǰĿ¼��û���ҵ������ļ������Ƚ���ϵͳ���ã�����','��ܰ��ʾ'); 
        return;
    end
%��鵱ǰ�Ƿ��п��ô���


    axes(handles.ShowImageAxes); %ָ��ԭʼͼ����ʾλ��
    cla;
%��������
    MyCameraHandle=videoinput('winvideo',1,'YUY2_640x480'); %
    vidRes1=get(MyCameraHandle,'VideoResolution');
    nBands1=get(MyCameraHandle,'NumberOfBands');
    set(MyCameraHandle,'ReturnedColorSpace','rgb');
    himage1=imshow(zeros(vidRes1(2),vidRes1(1),nBands1));
    


    CameraIsConnected=100;
    try preview(MyCameraHandle,himage1); %��ָ��λ��Ԥ��ԭʼͼ��
    catch ME
         CameraIsConnected=-100;
    end
    if CameraIsConnected < 0
        msgbox('��ǰ���Ի�û����������ͷ����ȷ��...','��ܰ��ʾ'); 
        return;    
    end
%�������
    start(MyCameraHandle);
    setappdata(0,'MyCameraHandle',MyCameraHandle);  %��Ϊȫ�ֱ���
    
    % ImageGray=getsnapshot (MyCameraHandle); % ����ͼ��

out=100;
%��þ������ݱ� 
    load('SystemParametersForCameraInCar.mat'); %װ�����ò���
    LengthC2C=CameraHeight/sin(AnglePitch); %���������ͶӰ���ľ���
    LengthO2C=CameraHeight*cot(AnglePitch); %��������ԭ����ͶӰ���ľ���
    ImageCenterC=ImageColumns/2;
    ImageCenterR=ImageRows/2;
    cosAngleRoll=cos(AngleRoll);
    sinAngleRoll=sin(AngleRoll);
    cosAnglePitch=cos(AnglePitch);
    sinAnglePitch=sin(AnglePitch);
    DistX=zeros(ImageRows,ImageColumns);
    DistY=DistX;
    for j=1:ImageRows
        IndexR=(ImageCenterR-j); %�任����ϵ��ͼ������-->�� ͼ������   

        for k=1:ImageColumns;

            IndexC=(k-ImageCenterC);
            %���������ת
            IndexRt=cosAngleRoll*IndexR - sinAngleRoll*IndexC;
            IndexC =sinAngleRoll*IndexR + cosAngleRoll*IndexC;
            %�������
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
    %ӳ�䵽 ��0 pi������ 
    k=AngleInImage<0;
    AngleInImage(k)=AngleInImage(k)+pi;
    
    figure; mesh(DistInImage); 
    setappdata(0,'DistInImage',DistInImage);  %��Ϊȫ�ֱ���
    setappdata(0,'AngleInImage',AngleInImage);   
    setappdata(0,'GUIShowHandles',handles);   
    
return;

function CountTheDistToBars()
% ������ʵ�ּ����Ŀ�������ұ߽����ԭ�����ߵĽǶȣ��Լ��м�Ƕȷ����ϱ߽���ԭ��ľ���
MyCameraHandle=getappdata(0,'MyCameraHandle');
GUIShowHandles=getappdata(0,'GUIShowHandles');
SystemRunning =getappdata(0,'SystemRunning'); 
DistInImage   =getappdata(0,'DistInImage');
AngleInImage  =getappdata(0,'AngleInImage');
  
    ImageGray=getsnapshot (MyCameraHandle); % ����ͼ��
    ImageGray=rgb2gray(ImageGray);       
    [ImageRows,ImageColumns]=size(ImageGray);
ImageDelEdge=ones(ImageRows,ImageColumns);
ImageDelEdge(1:3,:)=0; 
ImageDelEdge(:,1:3)=0; 
ImageDelEdge(ImageRows-3:end,:)=0;
ImageDelEdge(:,ImageColumns-3:end)=0;

ImAeraNum=80;  %��ͨ�����ظ��� �ϰ����
%��ͨ�˲���
%LowPassFilter=fspecial('gaussian', [5 5], 0.6);
LowPassFilter=fspecial('average', [7 7]);
while(SystemRunning > 0)
    ImageGray=getsnapshot (MyCameraHandle); % ����ͼ��
    ImageGray=rgb2gray(ImageGray);
    
   % ImageGray=medfilt2(ImageGray);  
    ImageGray = imfilter(ImageGray, LowPassFilter);
    ImageBW = edge(ImageGray,'prewitt');
    
    %ȥ����ͨ���С�Ĳ��֣�����˵�ϰ�С�ò�Ӱ��С��ǰ��
    ImageBW=bwareaopen(ImageBW,ImAeraNum);
    ImageBW =ImageBW & ImageDelEdge;
    %�������� �������� �����ϰ���ͨ��
   
    [AllRowsY,Temp]=find(ImageBW==1);
    SumCol=sum(ImageBW);
    Index=0;
    MaxRowsY=zeros(1,ImageColumns);
    for k=1:ImageColumns
        if SumCol(1,k)>0
            Index=Index+SumCol(1,k);
            MaxRowsY(1,k)=AllRowsY(Index); %�ҳ����·��ı߽�������           
        end
    end
	% ��������� �߽��˲� 
    MaxRowsY=medfilt1(MaxRowsY,5); %��㵱��ȡ��ֵ
    % ���������ϰ���ͨ��  
    BarColBeginX=ones(1,ImageColumns);
    BarColEndX=BarColBeginX;
    BarNums=1;
    for k=2:ImageColumns
        Temp=MaxRowsY(1,k)-MaxRowsY(1,k-1);
        %�յ�����һ �߿�
        if MaxRowsY(1,k)==0 && Temp < 0
            BarColEndX(1,BarNums)=k;
            continue;
        end
        
         %�������һ �ո�
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
    
    %��ȡ�߽� �߽�����B ��߽�����N
    AngleBarN=zeros(BarNums,6);
    BarN=ones(BarNums,3);
    BarNa=BarN * 254;
    for k=1:BarNums 

        %����ÿ���ϰ���ͨ�� �� �� �ұ߽���ԭ��ļн�     
        AngleLeftX=BarColBeginX(1,k);   
        AngleLeftY=max(1,MaxRowsY(1,AngleLeftX));     %�߽绯��������ֹ�쳣
        
        AngleRightX=BarColEndX(1,k);
        AngleRightY=max(1,MaxRowsY(1,AngleRightX)); 
        
        AngleMediX=round((AngleLeftX+AngleLeftY)/2);
        AngleMediY=max(1,MaxRowsY(1,AngleMediX)); 

        
        AngleBarN(k,1)=AngleInImage(AngleLeftY,AngleLeftX);    
        AngleBarN(k,2)=AngleInImage(AngleMediY,AngleMediX);          
        AngleBarN(k,3)=AngleInImage(AngleRightY,AngleRightX);

        AngleBarN(k,4)=DistInImage(AngleLeftY,AngleLeftX);    
        AngleBarN(k,5)=DistInImage(AngleMediY,AngleMediX);          
        AngleBarN(k,6)=DistInImage(AngleRightY,AngleRightX);
        
        if (AngleLeftX < 240)              %����A
            BarNa(k,1)=DistInImage(AngleMediY,AngleMediX);
        elseif (AngleLeftX > 400)          %����B,��������͵������Ҿ͵�С���м�ײ��A����B��С
            BarNa(k,3)=DistInImage(AngleMediY,AngleMediX);
        else
             BarNa(k,2)=DistInImage(AngleMediY,AngleMediX);
        end
           
        if (AngleRightX < 240)              %����A
            BarNa(k,1)=DistInImage(AngleMediY,AngleMediX);
        elseif (AngleRightX > 400)          %����B,��������͵������Ҿ͵�С���м�ײ��A����B��С
            BarNa(k,3)=DistInImage(AngleMediY,AngleMediX);
        else
             BarNa(k,2)=DistInImage(AngleMediY,AngleMediX);
        end
     
        
    end    
	%�ڴ�������ʾ 
    set(GUIShowHandles.ShowDistancEdit,'string',num2str(AngleBarN));  


 minLMR=round(BarNa);
 mdis=min(minLMR,[],1);
 mdi=[255,mdis];
try
port1=serial('com1');
port1.BaudRate=9600;
fopen(port1);
dataToSend=dec2hex(mdi);
fwrite(port1,hex2dec(dataToSend));
fclose(port1);
end


	 %�����·���浵
    
    axes(GUIShowHandles.ShowObjectAxes); %���ϵػ�ȡ���㣬����䲻��������ѭ������
    imshow(ImageBW);    
    axes(GUIShowHandles.ShowBarAxes);
    plot(MaxRowsY);
    SystemRunning =getappdata(0,'SystemRunning'); %�����ֹ����
    
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