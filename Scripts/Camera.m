classdef Camera < handle
    %Найти камеру, задать основные настройки
    %   Делать снимки    
    properties
       video 
    end
    
    methods
%Инициализировать камеру        
function result = init(obj)
    result = true;
    %Delete all video objects 
    objs=imaqfind('Type','videoinput');
    for i=1:1:size(objs)
        delete(objs{i});   
    end

    try
        %Create new object video
        warning ('off','all');
       camera=imaqhwinfo('winvideo',1);
       
        %Sizes of window must be 4:3
        format=camera.SupportedFormats; %Maximal resolution for RGB
        ind = ismember(format, 'RGB24_1280x960');
        obj.video=videoinput('winvideo',1, format{ind});
        vidRes=obj.video.VideoResolution;
        nBands=obj.video.NumberOfBands;
        hImage=image(zeros(vidRes(2),vidRes(1),nBands));
        preview(obj.video,hImage);
        triggerconfig(obj.video,'manual');
        obj.video.FramesPerTrigger=10;
        %start(obj.video);
        warning ('on','all');
    catch exception
        result = false;
    end
end

%Получить снимок
function image = getImage(obj)  
    image=getsnapshot(obj.video);
end
    end
    
end

