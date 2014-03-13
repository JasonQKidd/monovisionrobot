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
%开始输入函数
%==========================================================================
function rs232debug_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

%==========================================================================
%结束输出函数
%==========================================================================
function varargout = rs232debug_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

%==========================================================================
%【打开串口】按钮的Callback函数
%==========================================================================
function start_serial_Callback(hObject, eventdata, handles)
global scom
if get(hObject,'value')                     %若按下【打开串口】按钮，打开串口
    com_n=sprintf('com%d',get(handles.com,'value'));   %获取串口的端口号
    rates=[300 600 1200 2400 4800 9600 19200 38400 43000 56000 57600 115200];
    baud_rate=rates(get(handles.rate,'value'));         %获取波特率
    switch get(handles.jiaoyan,'value')
        case 1
            jiaoyan='none';
        case 2
            jiaoyan='odd';
        case 3
            jiaoyan='even';
    end
    data_bits=9-get(handles.data_bits,'value');    %获取数据位的位数
    stop_bits=get(handles.stop_bits,'value');      %获取停止位的位数
    scom=serial(com_n);                            %创建串口对象
    set(scom,'BaudRate',baud_rate,'Parity',jiaoyan,...
        'DataBits',data_bits,'StopBits',stop_bits,...
        'BytesAvailableFcnCount',100,...
        'BytesAvailableFcnMode','byte',...
        'BytesAvailableFcn',{@bytes,handles},...
        'TimerPeriod',0.01,'TimerFcn',{@bytes,handles})   %设置串口属性
    try                                     %尝试打开串口，若打开失败，说明
                                            %串口补课获得
        fopen(scom);
    catch
        msgbox('串口不可获得!');
        set(hObject,'value',0)
        return
    end
    set(handles.xianshi,'string','')     %清空接收显示区
    set(handles.activex1,'value',1)      %串口指示灯亮
else                                %若松开【打开串口】按钮，关闭串口删除定时器
    t=timerfind;                         %查找定时器
    try
        stop(t);
        delete(t);
        clear t
    end
    scoms=instrfind;                     %查找串口对象
    stopasync(scom);
    fclose(scoms);
    delete(scoms);
    set(handles.period_send,'value',0)
    set(handles.activex1,'value',0)
end

%==========================================================================
%【手动发送】按钮的Callback函数、自动发送功能的定时器TimerFcn
%==========================================================================
function manual_send_Callback(hObject, eventdata, handles)          %手动发送
global scom
if ~get(handles.hex_send,'value')         %字符串形式发送
    str=get(handles.sends,'string');      %获取待发送的字符串
    val=double(str);                   %转换为数值ASCII
    set(handles.trans,'string',num2str(str2num(get(handles.trans,'string'))+length(val)))
                                          %更新写计数
else                                      %十六进制形式发送
    a=get(handles.sends,'string');             %将待发送的十六进制数转化为数值，等待串口发送
    n=find(a==' ');                       %查找空格的位置1~x
    n=[0 n length(a)+1];                  %建立空格变量数组
    for i=1:length(n)-1                   
        temp=a(n(i)+1:n(i+1)-1);
        %测试输出edit text阶段
        B0=isstrprop(temp,'xdigit');    %是否全为有效地十六进制数
        B1=reshape(B0,1,[]);
        if ~all(B1)
            msgbox('发送数据格式错误!');
            return
        end
        if ~rem(length(temp),2)
            b{i}=reshape(temp,2,[])';
        else
            b=temp;
            if hex2dec(b)'>255||hex2dec(b)'<0
                msgbox('发送数据格式错误!');
                return
            end       
            break;
        end
    end
    val=hex2dec(b)';
    set(handles.trans,'string',num2str(str2num(get(handles.trans,'string'))+length(val)))
                                                     %更新写计数  
end
if ~isempty(val)
    try
        str=get(scom,'TransferStatus');
    catch
        return
    end
    while 1                      %当串口没有写数据的时候，写入数据
       %if ~(strcmp(str,'write')||strcmp(str,'read&write'))
       if strcmp(str,'idle') 
            fwrite(scom,val,'uchar');
            %fprintf(scom,'%c',val);
            break
        end
    end
end

%==========================================================================
%【自动发送】复选框Callback函数
%==========================================================================
function period_send_Callback(hObject, eventdata, handles)
global scom
if get(hObject,'value')   
    t1=0.001*str2num(get(handles.period1,'string'));    %获取定时周期时间
    try
       if t1<=0.01||t1>=10000
          msgbox('周期不合适!');
          set(hObject,'value',0)
          return
       end
    catch
          msgbox('周期输入格式错误!');
          set(hObject,'value',0)
          return
    end
    t=timer('BusyMode','queue','ExecutionMode','fixedrate',...
        'Period',t1,'TimerFcn',{@manual_send_Callback,handles});  
                                     %创建用于发送数据的定时器
    start(t);                        %打开定时器
else
    t=timerfind;                              %查找定时器，并删除
    stop(t); 
    delete(t);
    clear t
end

%==========================================================================
%定时器的BytesAvailableFcn和TimerFcn回调函数
%==========================================================================
function bytes(obj,eventdata,handles)
n=get(obj,'BytesAvailable');
if n                                       %若串口输入缓冲区有数据
    a=fread(obj,n,'uchar');         %读串口 
    if ~get(handles.hex_disp,'value')      %字符串显示
        c=char(a');                        %将读到的数据转换为字符
        if ~get(handles.stop_disp,'value') %若没有按下【停止显示】按钮
            set(handles.xianshi,'string',[get(handles.xianshi,'string') c])
                              %更新接收显示区
        end
        set(handles.rec,'string',num2str(str2num(get(handles.rec,'string'))+length(c)))
                              %更新读计数
    else                                   %十六进制显示
        %c=str2num(dec2hex(a'))';            %将接收到的数据转换为十六进制                      
        if ~get(handles.stop_disp,'value') %若没有按下【停止显示】按钮
            %set(handles.xianshi,'string',[get(handles.xianshi,'string') num2str(c) ' '])
            set(handles.xianshi,'string',[get(handles.xianshi,'string') num2str(a','%x') ' '])
                               %更新接收显示区
        end
        set(handles.rec,'string',num2str(str2num(get(handles.rec,'string'))+length(a')))
                               %更新读计数
    end
    n0=get(obj,'BytesAvailable');     %测试变量
end

%==========================================================================
%【清空发送区】按钮的Callback函数
%==========================================================================
function clear_send_Callback(hObject, eventdata, handles)
set(handles.sends,'string','')

%==========================================================================
%【计数清零】按钮的Callback函数
%==========================================================================
function clear_count_Callback(hObject, eventdata, handles)
set([handles.rec,handles.trans],'string','0')

%==========================================================================
%【清空接收区】按钮的Callback函数
%==========================================================================
function qingkong_Callback(hObject, eventdata, handles)
set(handles.xianshi,'string','')

%==========================================================================
%【复制数据】复选框的Callback函数
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
%待理解
%==========================================================================
function period1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%==========================================================================
%待理解
%==========================================================================
function COM_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%==========================================================================
%待理解
%==========================================================================
function sends_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%==========================================================================
%待理解
%==========================================================================
function popupmenu3_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%==========================================================================
%待理解
%==========================================================================
function stop_bits_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%==========================================================================
%带理解
%==========================================================================
function xianshi_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%==========================================================================
%待理解
%==========================================================================
function data_bits_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%==========================================================================
%带理解
%==========================================================================
function com_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%==========================================================================
%待理解
%==========================================================================
function jiaoyan_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%==========================================================================
%待理解
%==========================================================================
function rate_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%待升级的函数
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
