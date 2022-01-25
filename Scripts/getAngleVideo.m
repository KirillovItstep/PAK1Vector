function [AngleArrow] = getAngleVideo(video,box,flpause)

%Если flpause=0, проверяется начало движения стрелки
eps=1; %Error for the first angle, degrees
eps0=1; %Error of the angle, degrees
tdel=0; %Delay between measurements
minTime=4; %Minimal time of measurement
maxTime=6; %Maximal time of measurement

count=0;  %Количество измерений
tic;
%Проверить, начала ли двигаться стрелка
if (~flpause)      
    time=toc;
    rgbImage=getsnapshot(video);
    Angle=getAngle(rgbImage,box);    
    %imwrite(rgbImage,strcat('FramesOut/',int2str(count),'.jpg'));
    %Angle
    count=count+1;
    pause(tdel);
    Angle0=Angle;    
while (abs(Angle-Angle0)<eps)&&(time<maxTime)
    time=toc;
    rgbImage=getsnapshot(video);
    Angle=getAngle(rgbImage,box);    
    %imwrite(rgbImage,strcat('FramesOut/',int2str(count),'.jpg'));
    %Angle
    count=count+1;
    pause(tdel);    
end
end

%Пока стрелка не остановится или не закончится отведенное время
time=toc;
if time<minTime
    pause(minTime-time);
end

%Измерения
countCheck=5;
Angles=zeros(1,countCheck);
points=zeros(countCheck,2);
for i=1:1:countCheck
    time=toc;
    rgbImage=getsnapshot(video);
    Angle=getAngle(rgbImage,box);    
    Angles(i)=Angle; 
    count=count+1;
    pause(tdel);    
end  
while (max(Angles)-min(Angles)>eps0)&&(time<maxTime)
for i=1:1:countCheck
    time=toc;
    rgbImage=getsnapshot(video);
    Angle=getAngle(rgbImage,box);    
    Angles(i)=Angle; 
    count=count+1;
    pause(tdel);    
end    
end
time=toc;
AngleArrow=mean(Angles);
point=mean(points);

%Save to frames
rgbImage=getsnapshot(video);

%{
for i=-5:1:5
rgbImage(round(point(2)+i),round(point(1)),:)=[255 0 0];
end
for i=-5:1:5
rgbImage(round(point(2)),round(point(1)+i),:)=[255 0 0];
end
%}

%{
folder=fullfile(pwd,'\Frames');
%Search all files in the directory
list=dir(fullfile(folder,'\*.jpg'));
%Sort by date
slist = [list(:).datenum].'; % you may want to eliminate . and .. first.
[slist,slist] = sort(slist);
slist = {list(slist).name};
%Count of images
count=size(slist,2);
imf=strcat(int2str(count),'.jpg');
imwrite(rgbImage,fullfile(folder,imf));
%}

end