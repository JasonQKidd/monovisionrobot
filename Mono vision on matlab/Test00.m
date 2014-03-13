imaqmem(30000000);

hard=imaqhwinfo;

name=hard.InstalledAdaptors;

h=figure('NumberTitle','off','Name','ÊÓÆµ²¶×½ ','MenuBar','none','color','c','Position', [0, 0, 1, 1], 'Visible', 'on');

set(h,'doublebuffer','on','outerposition',get(0,'screensize'));

h1=axes('Position', [0.03, 0.1, 0.45, 0.8],'Parent',h);

axes(h1);axis off;%or set(h,'CurrentAxes',h1);hold on;

vid=videoinput('winvideo',1,'YUY2_640x480');
start(vid);
vidRes1=get(vid,'VideoResolution');
nBands1=get(vid,'NumberOfBands');
set(vid,'ReturnedColorSpace','rgb');
himage1=imshow(zeros(vidRes1(2),vidRes1(1),nBands1));
preview(vid,himage1);
text(.1, .1,'.','color','w');title('ÊÓÆµÔ´');

h2=axes('Position', [0.5, 0.1, 0.45, 0.8],'Parent',h);

axes(h2);axis off;%set(h,'CurrentAxes',h1);hold on;

text(.1, .1,'.','color',[1 1 1]);title('¼ì²âÍ¼');

while ishandle(h)

    aa=getsnapshot(vid);% grabbing camera image.    
    
    I= rgb2gray(aa);
    
    BW2=edge(I,'roberts');
    
   BW2=bwareaopen(BW2,40);
   
   [H,T,R]=hough(BW2);
   
   P=houghpeaks(H,5);
   
   x=T(P(:,2));y=R(P(:,1));
   
   lines=houghlines(BW2,T,R,P);
     axes(h2); cla;
   imshow(I);hold on;
   
   max_len=0;
   
    for k=1:length(lines)
        xy=[lines(k).point1;lines(k).point2];
        plot(xy(:,1),xy(:,2),'color','green');
        plot(xy(1,1),xy(1,2),'color','yellow');
        plot(xy(2,1),xy(2,2),'color','red');
        len=norm(lines(k).point1-lines(k).point2);
      if (len>max_len)
          max_len=len;
          xy_long=xy;
      end

    end

    plot(xy_long(:,1),xy_long(:,2),'color','cyan');
 try
port1=serial('com1');
port1.BaudRate=9600;
fopen(port1);
dataToSend=dec2hex(703710);
fwrite(port1,hex2dec(dataToSend),'int32');
fclose(port1);
catch ME
    fprintf('%s\n',ME.message);
end


  % hold off
    
  %set(b,'EraseMode','none');

 %drawnow;% this is important to view realtime.

end

delete(vid)

disp('¹Ø±Õ')