function varargout = rs232debug(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @rs232debug_OpeningFcn, ...
                   'gui_OutputFcn',  @rs232debug_OutputFcn, ...
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
%==========================================================================
%��ʼ���뺯��
%==========================================================================
function rs232debug_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

%==========================================================================
%�����������
%==========================================================================
function varargout = rs232debug_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

%==========================================================================
%���򿪴��ڡ���ť��Callback����
%==========================================================================
function start_serial_Callback(hObject, eventdata, handles)
global scom
if get(hObject,'value')                     %�����¡��򿪴��ڡ���ť���򿪴���
    com_n=sprintf('com%d',get(handles.com,'value'));   %��ȡ���ڵĶ˿ں�
    rates=[300 600 1200 2400 4800 9600 19200 38400 43000 56000 57600 115200];
    baud_rate=rates(get(handles.rate,'value'));         %��ȡ������
    switch get(handles.jiaoyan,'value')
        case 1
            jiaoyan='none';
        case 2
            jiaoyan='odd';
        case 3
            jiaoyan='even';
    end
    data_bits=9-get(handles.data_bits,'value');    %��ȡ����λ��λ��
    stop_bits=get(handles.stop_bits,'value');      %��ȡֹͣλ��λ��
    scom=serial(com_n);                            %�������ڶ���
    set(scom,'BaudRate',baud_rate,'Parity',jiaoyan,...
        'DataBits',data_bits,'StopBits',stop_bits,...
        'BytesAvailableFcnCount',100,...
        'BytesAvailableFcnMode','byte',...
        'BytesAvailableFcn',{@bytes,handles},...
        'TimerPeriod',0.01,'TimerFcn',{@bytes,handles})   %���ô�������
    try                                     %���Դ򿪴��ڣ�����ʧ�ܣ�˵��
                                            %���ڲ��λ��
        fopen(scom);
    catch
        msgbox('���ڲ��ɻ��!');
        set(hObject,'value',0)
        return
    end
    set(handles.xianshi,'string','')     %��ս�����ʾ��
    set(handles.activex1,'value',1)      %����ָʾ����
else                                %���ɿ����򿪴��ڡ���ť���رմ���ɾ����ʱ��
    t=timerfind;                         %���Ҷ�ʱ��
    try
        stop(t);
        delete(t);
        clear t
    end
    scoms=instrfind;                     %���Ҵ��ڶ���
    stopasync(scom);
    fclose(scoms);
    delete(scoms);
    set(handles.period_send,'value',0)
    set(handles.activex1,'value',0)
end

%==========================================================================
%���ֶ����͡���ť��Callback�������Զ����͹��ܵĶ�ʱ��TimerFcn
%==========================================================================
function manual_send_Callback(hObject, eventdata, handles)          %�ֶ�����
global scom
if ~get(handles.hex_send,'value')         %�ַ�����ʽ����
    str=get(handles.sends,'string');      %��ȡ�����͵��ַ���
    val=double(str);                   %ת��Ϊ��ֵASCII
    set(handles.trans,'string',num2str(str2num(get(handles.trans,'string'))+length(val)))
                                          %����д����
else                                      %ʮ��������ʽ����
    a=get(handles.sends,'string');             %�������͵�ʮ��������ת��Ϊ��ֵ���ȴ����ڷ���
    n=find(a==' ');                       %���ҿո��λ��1~x
    n=[0 n length(a)+1];                  %�����ո��������
    for i=1:length(n)-1                   
        temp=a(n(i)+1:n(i+1)-1);
        %�������edit text�׶�
        B0=isstrprop(temp,'xdigit');    %�Ƿ�ȫΪ��Ч��ʮ��������
        B1=reshape(B0,1,[]);
        if ~all(B1)
            msgbox('�������ݸ�ʽ����!');
            return
        end
        if ~rem(length(temp),2)
            b{i}=reshape(temp,2,[])';
        else
            b=temp;
            if hex2dec(b)'>255||hex2dec(b)'<0
                msgbox('�������ݸ�ʽ����!');
                return
            end       
            break;
        end
    end
    val=hex2dec(b)';
    set(handles.trans,'string',num2str(str2num(get(handles.trans,'string'))+length(val)))
                                                     %����д����  
end
if ~isempty(val)
    try
        str=get(scom,'TransferStatus');
    catch
        return
    end
    while 1                      %������û��д���ݵ�ʱ��д������
       %if ~(strcmp(str,'write')||strcmp(str,'read&write'))
       if strcmp(str,'idle') 
            fwrite(scom,val,'uchar');
            %fprintf(scom,'%c',val);
            break
        end
    end
end

%==========================================================================
%���Զ����͡���ѡ��Callback����
%==========================================================================
function period_send_Callback(hObject, eventdata, handles)
global scom
if get(hObject,'value')   
    t1=0.001*str2num(get(handles.period1,'string'));    %��ȡ��ʱ����ʱ��
    try
       if t1<=0.01||t1>=10000
          msgbox('���ڲ�����!');
          set(hObject,'value',0)
          return
       end
    catch
          msgbox('���������ʽ����!');
          set(hObject,'value',0)
          return
    end
    t=timer('BusyMode','queue','ExecutionMode','fixedrate',...
        'Period',t1,'TimerFcn',{@manual_send_Callback,handles});  
                                     %�������ڷ������ݵĶ�ʱ��
    start(t);                        %�򿪶�ʱ��
else
    t=timerfind;                              %���Ҷ�ʱ������ɾ��
    stop(t); 
    delete(t);
    clear t
end

%==========================================================================
%��ʱ����BytesAvailableFcn��TimerFcn�ص�����
%==========================================================================
function bytes(obj,eventdata,handles)
n=get(obj,'BytesAvailable');
if n                                       %���������뻺����������
    a=fread(obj,n,'uchar');         %������ 
    if ~get(handles.hex_disp,'value')      %�ַ�����ʾ
        c=char(a');                        %������������ת��Ϊ�ַ�
        if ~get(handles.stop_disp,'value') %��û�а��¡�ֹͣ��ʾ����ť
            set(handles.xianshi,'string',[get(handles.xianshi,'string') c])
                              %���½�����ʾ��
        end
        set(handles.rec,'string',num2str(str2num(get(handles.rec,'string'))+length(c)))
                              %���¶�����
    else                                   %ʮ��������ʾ
        %c=str2num(dec2hex(a'))';            %�����յ�������ת��Ϊʮ������                      
        if ~get(handles.stop_disp,'value') %��û�а��¡�ֹͣ��ʾ����ť
            %set(handles.xianshi,'string',[get(handles.xianshi,'string') num2str(c) ' '])
            set(handles.xianshi,'string',[get(handles.xianshi,'string') num2str(a','%x') ' '])
                               %���½�����ʾ��
        end
        set(handles.rec,'string',num2str(str2num(get(handles.rec,'string'))+length(a')))
                               %���¶�����
    end
    n0=get(obj,'BytesAvailable');     %���Ա���
end

%==========================================================================
%����շ���������ť��Callback����
%==========================================================================
function clear_send_Callback(hObject, eventdata, handles)
set(handles.sends,'string','')

%==========================================================================
%���������㡿��ť��Callback����
%==========================================================================
function clear_count_Callback(hObject, eventdata, handles)
set([handles.rec,handles.trans],'string','0')

%==========================================================================
%����ս���������ť��Callback����
%==========================================================================
function qingkong_Callback(hObject, eventdata, handles)
set(handles.xianshi,'string','')

%==========================================================================
%���������ݡ���ѡ���Callback����
%==========================================================================
function copy_data_Callback(hObject, eventdata, handles)
if get(hObject,'value')
    set(handles.xianshi,'enable','on')
    str=get(handles.xianshi,'string');
    set(handles.xianshi,'string',[get(handles.xianshi,'string') str]);
else
    set(handles.xianshi,'enable','inactive')
end
set(handles.xianshi,'enable','inactive')

%**************************************************************************
%**************************************************************************

%==========================================================================
%�����
%==========================================================================
function period1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%==========================================================================
%�����
%==========================================================================
function COM_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%==========================================================================
%�����
%==========================================================================
function sends_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%==========================================================================
%�����
%==========================================================================
function popupmenu3_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%==========================================================================
%�����
%==========================================================================
function stop_bits_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%==========================================================================
%�����
%==========================================================================
function xianshi_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%==========================================================================
%�����
%==========================================================================
function data_bits_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%==========================================================================
%�����
%==========================================================================
function com_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%==========================================================================
%�����
%==========================================================================
function jiaoyan_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%==========================================================================
%�����
%==========================================================================
function rate_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%�������ĺ���
function com_Callback(hObject, eventdata, handles)
function hex_send_Callback(hObject, eventdata, handles)
function stop_disp_Callback(hObject, eventdata, handles)
function sends_Callback(hObject, eventdata, handles)
function popupmenu3_Callback(hObject, eventdata, handles)
function stop_bits_Callback(hObject, eventdata, handles)
function data_bits_Callback(hObject, eventdata, handles)
function xianshi_Callback(hObject, eventdata, handles)

function rate_Callback(hObject, eventdata, handles)
function jiaoyan_Callback(hObject, eventdata, handles)
function period1_Callback(hObject, eventdata, handles)
function hex_disp_Callback(hObject, eventdata, handles)
