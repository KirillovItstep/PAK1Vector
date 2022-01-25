clc; clear all; close all;
%Удалить все объекты камеры
objs=imaqfind('Type','videoinput');
    for i=1:1:size(objs)
        delete(objs{i});   
    end
    
try
%Create new object video
Camera=imaqhwinfo('winvideo',1);
%Sizes of window must be 4:3
format=Camera.SupportedFormats; %Maximal resolution for RGB
ind=find(ismember(format, 'RGB24_1280x960'));
video=videoinput('winvideo',1, format{ind});
vidRes=video.VideoResolution;
nBands=video.NumberOfBands;
hImage=image(zeros(vidRes(2),vidRes(1),nBands));
preview(video,hImage);
triggerconfig(video,'manual');
video.FramesPerTrigger=10;
start(video);
catch exception
disp('Камера не работает!');
end