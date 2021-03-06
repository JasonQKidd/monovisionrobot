function ex051()
vid=videoinput('winvideo',1,'YUY2_640x480');
set(vid,'TriggerRepeat',Inf);
set(vid,'FramesPerTrigger',1);
set(vid,'FrameGrabInterval',1);
set(vid,'ReturnedColorSpace','rgb');
vidRes=get(vid,'VideoResolution');
nBands=get(vid,'NumberOfBands');
hImage=image(zeros(vidRes(2),vidRes(1),nBands));
preview(vid,hImage);
for j=1:10000
  
im=getsnapshot (vid);
wait(ex05(im),0.2)
end

functiony=ex05(I)

I= rgb2gray(im);
BW=edge(I,'roberts');
figure,imshow(BW)
BW2=bwareaopen(BW,40);
[H,T,R]=hough(BW2);
P=houghpeaks(H,5);
x=T(P(:,2));y=R(P(:,1));
plot(x,y,'s','color','white');
lines=houghlines(BW2,T,R,P);
figure,imshow(I),hold on
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
wait
