I = imread('009.jpg');
BW=edge(I,'canny');
[H,T,R]=hough(BW);
imshow(H,[],'XData',T,'Ydata',R,'InitialMagnification','fit');
axis normal,hold on;
P=houghpeaks(H,5);
x=T(P(:,2));y=R(P(:,1));
plot(x,y,'s','color','white');
lines=houghlines(BW,T,R,P);
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