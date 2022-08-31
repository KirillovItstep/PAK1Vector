function pak1
%Main function
clc; clear all; close all;
global video fmain panel BRun ismax isinit;
SCRsize=(get(0,'MonitorPositions')); 
%Width/height of screen
ratio=SCRsize(4)/SCRsize(3);

%Main window    
fmain = figure...    
    ('Color'            , [0.9 0.9 0.9],...
    'NumberTitle'       ,'off', ...
    'Name'              ,'Шкала прибора Э8030-М1 (ПАК-1)',...
    'Tag'               ,'fmain',...    
    'Units'             ,'normalized',...
    'Outerposition'     ,[0 0 1 1],...
    'Resize'            , 'off',...
    'MenuBar'           ,'none');

% Create the parent menu
menu = uimenu(fmain,'Label','Шкала'); 
% Create the submenus
smenu1 = uimenu(menu,'Label','Выбор шкалы',...
               'Callback',{@choiceScale});
smenu12 = uimenu(menu,'Label','Задать номер',...
               'Callback',{@setNumber});
menu2 = uimenu(fmain,'Label','Сохранить'); 
% Create the submenus
smenu2 = uimenu(menu2,'Label','Сохранить в CorelDraw',...
               'Callback',{@bsaveCorel});
           
%choiceScale;
%Container for a camera
CameraAxes=axes('Parent',fmain,'Position',[0.01 1-0.5-0.01 0.67*ratio 0.5]);
statusbar(fmain, 'Проверка готовности...');  
%Message about the choice of device
%szfmain=get(fmain,'Position');
sdev=getScale();
%{
ChoiceDev = uicontrol('Parent',fmain,'Style', 'text', 'FontSize',14,'String',['Выбрана шкала: ',sdev],...
     'Units','normalized','Position', [0.7 szfmain(4)-0.01 0.25 0.03],'BackgroundColor',[0.9 1 0.9],'HorizontalAlignment','left');   
%}
%Panel with messages
panel=Panel(fmain);
BRun = uicontrol('Parent',fmain,'Style', 'pushbutton', 'FontSize',16,'String','Пуск',...
     'Units','normalized','Position', [0.4 0.1 0.2 0.1],'Callback',{@brun});     
%Delete all video objects

obj=imaqfind('Type','videoinput');
for i=1:1:size(obj)
    delete(obj{i});   
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
panel.addMessage('Камера не работает!',[0.9 0.4 0.7]);
end
panel.addMessage(['Выбрана шкала ' sdev],[0.6 0.9 0.6]);
panel.addMessage('Режим калибратора должен быть "Стоп"',[0.1 0.7 0.9]);
panel.addMessage('Установите прибор и нажмите кнопку "Пуск"',[0.6 0.9 0.6]);
isinit=false; %If an initialization of calibrator already runned
ismax=false;
end

function choiceScale(hObject, eventdata)
global ENumber fchoice ismax BMaxMin LLevels;
%Read the scale's number from ini-file
sdev = getScale();
%Choice a scale by their number
sz = [500 800]; % figure size
screensize = get(0,'ScreenSize');
xpos = ceil((screensize(3)-sz(2))/2); % center the figure on the screen horizontally
ypos = ceil((screensize(4)-sz(1))/2); % center the figure on the screen vertically
fchoice = figure(...
    'position',[xpos, ypos, sz(2), sz(1)],...
    'NumberTitle','off', ...
    'units','pixels',...    
    'MenuBar','none',...
    'color', [0.9 0.9 0.9],...
    'PaperPositionMode','auto',...
    'Name','Шкала->Выбор шкалы',...    
    'Tag','gui',...
    'Resize','off',...
    'WindowStyle','modal');
    LNumber = uicontrol('Parent',fchoice,'Style', 'text', 'FontSize',16,'String','Номер шкалы:',...
     'Position', [20 sz(1)-50 200 40],'BackgroundColor',[0.9 0.9 0.9]);   
    ENumber = uicontrol('Parent',fchoice,'Style', 'edit', 'FontSize',16,'String',sdev,...
     'Position', [20 sz(1)-100 200 50]);
    BNumber = uicontrol('Parent',fchoice,'Style', 'pushbutton', 'FontSize',16,'String','OK',...
     'Position', [230 sz(1)-100 200 50],'Enable','off','Callback',{@bchoiceScale});
    LLevels = uicontrol('Parent',fchoice,'Style', 'text', 'FontSize',10,'String','Выдаваемые уровни сигнала:',...
     'Position', [470 sz(1)-250 300 120],'BackgroundColor',[0.9 0.9 0.9]);
    if (~ismax) maxmessage='Задать максимум';
    else maxmessage='Задать ноль';
    end
    BMaxMin = uicontrol('Parent',fchoice,'Style', 'pushbutton', 'FontSize',16,'String',maxmessage,...
     'Position', [450 sz(1)-100 300 50],'Callback',{@bcmaxmin});   
SText=['Выбрана шкала: ',sdev];
statusbar(fchoice, SText);
bchoiceScale(hObject, eventdata);
set(BNumber,'Enable','on'); 
 %Set focut to Edit
%uicontrol(ENumber);
end
  
function bchoiceScale(hObject, eventdata)
global ENumber fchoice panel mode LLevels isinit;
sdev=get(ENumber,'String');
%Check if the scale is exists
device=strcat('device',sdev);
try    
    mode=getModeR(device); 
    imscale(sdev);
catch exception
    statusbar(fchoice, 'Шкалы с таким номером нет');  
    return;
end
    axis off;   
    ChoiceAxes=axes('Parent',fchoice,'Position',[0 0.1 0.6 0.6]);
    %set(gca,'units','normalized','position',[0 0.1 0.6 0.6]); % axis for the image     
    axes(ChoiceAxes);
    im=imread('scale_o.jpg');
    imshow(im);
    SText=['Выбрана шкала: ',sdev];
statusbar(fchoice, SText);
%Save the scale's number to ini-file
writeKeys = {'Scale','number','name',sdev};
inifile('settings.ini','write',writeKeys,'plain');
panel.addMessage(['Выбрана шкала ' sdev],[0.6 0.9 0.6]);
scale1=mode{2};
params=getParams(scale1);
lstring=strcat('Выдаваемые уровни сигнала:',params{2});
set(LLevels,'String',lstring);
isinit=false;
%levels=regexp(params{2}, ' ', 'split')
%imshow(image);
end

function setNumber(hObject, eventdata)
global SNumber fsetNumber;
%5-значный номер???
readKeys = {'device35','number','name'};
readSet = inifile('settings.ini','read',readKeys); 
n=str2num(readSet{1}); 
s=int2str(n);

fsetNumber = figure...    
    ('Color'            , [0.9 0.9 0.9],...
    'NumberTitle'       ,'off', ...
    'Name'              ,'Шкала->Задать номер',...
    'Tag'               ,'fmain',...    
    'Units'             ,'normalized',...
    'Outerposition'     ,[0.4 0.4 0.3 0.25],...
    'Resize'            , 'off',...
    'MenuBar'           ,'none');
SNumber = uicontrol('Parent',fsetNumber,'Style', 'edit', 'FontSize',16,'String',s,...
     'Units','normalized','Position', [0.2 0.6 0.5 0.3]);
BSetNumber = uicontrol('Parent',fsetNumber,'Style', 'pushbutton', 'FontSize',16,'String','OK',...
     'Units','normalized','Position', [0.2 0.15 0.5 0.4],'Callback',{@bSaveNumber});
uicontrol(SNumber);
end

function bSaveNumber(hObject, eventdata)
global SNumber fsetNumber;
%5-значный номер
s = get(SNumber,'String');
czeros=5-length(s);
for i=1:1:czeros 
    s=strcat('0',s); 
end 
writeKeys = {'device35','number','name',s};
inifile('settings.ini','write',writeKeys,'plain');
close(fsetNumber);
end

function bcmaxmin(hObject, eventdata)
%Maximal or minimal level of a signal
global ismax isinit BMaxMin maxlevel mode valueOrFreq;
if (~isinit)
% Init calibrator; output to com port mode set commands
modes=regexp(mode{1}, ';', 'split');
if modes{size(modes,2)}(1:1)=='F'
    valueOrFreq = 'V';
else valueOrFreq = 'F';
end
disp(valueOrFreq);
for j=1:1:size(modes,2)
    OutputCom(modes{j});
end
scale1=mode{2};
% Read parameters of the first scale
params=getParams(scale1);
levels=regexp(params{2}, ' ', 'split');
maxlevel=strcat(valueOrFreq,levels{params{1}});
isinit=true;
end
if (~ismax)
    OutputCom(maxlevel);
    OutputCom('OPR');
    ismax=true;    
else
    OutputCom('OPR');
    ismax=false;
end
    if (~ismax) maxmessage='Задать максимум';
    else maxmessage='Задать ноль';
    end
set(BMaxMin,'String',maxmessage);
end

function imscale(Number)
%Forming an image of the linear scale
sdev=Number;
device=strcat('device',sdev);
mode=getModeR(device);
scale1=mode{2};
params=getParams(scale1);
marks=MarksR(params);
marks.Angles=linspace(135,45,marks.Count); 
marks.Angles=marks.Angles*pi/180;
imd=ImFigureDrawR(72,52);
DrawScaleR(imd,device);
marks.draw(imd);
delete('scale_o.jpg');
imd.saveToFile('scale_o'); 
%image=frame2im(getframe(gca));
end

function brun(hObject, eventdata)
global video panel BRun ismax Angles alpha params valueOrFreq;

if ismax
OutputCom('OPR');
    ismax=false;
end;    
set(BRun,'Enable','off');
%showScale; return;
%im0=imread('resa.jpg'); im0=rgb2gray(im0);
rgb=getsnapshot(video); %imwrite(rgb,'res0.jpg'); return;
box = cropScale(rgb);
Index = 1;
tdel=0; %Пауза для остановки стрелки, с
% Define mode, scale1, scale2 by device name
%Read the scale's number from ini-file
sdev = getScale();
device=strcat('device',sdev);
mode=getModeR(device);
scale1=mode{2};
scale2=mode{3};
% Init calibrator; output to com port mode set commands
modes=regexp(mode{1}, ';', 'split');
for j=1:1:size(modes,2)
    OutputCom(modes{j});
    %modes{j}
end

% Get angle for the zero signal
pause(tdel);
Angle=getAngleVideo(video,box,1);
Angle0=Angle;

%Angle0=135;
% Read parameters of the first scale
params=getParams(scale1);
% Get angle for the first signal
%Put signal
levels=regexp(params{2}, ' ', 'split');
s=strcat(valueOrFreq,levels{2}); 
OutputCom(s);  
OutputCom('OPR');
pause(tdel);
Angle=getAngleVideo(video,box,0);
Angle1=Angle;
% If the difference of the arrow positions more than 13,6 degree, then loading the second scale
%Angle0,Angle1
if (Angle0-Angle1)>13
    params=getParams(scale2);
    %Put signal
    levels=regexp(params{2}, ' ','split');
    s=strcat(valueOrFreq,levels{2}); 
    OutputCom(s);
    pause(tdel);
    Angle=getAngleVideo(video,im0,0);    
    Angle1=Angle;
end
%return;
% Get angle for first signal

% Провести измерения
%Create marks
markss=MarksR(params);
Angles=zeros(1,markss.Count);
Angles(1)=Angle0; Angles(2)=Angle1; 
%Output to calibrator
for i=3:1:markss.Count    
    s=strcat(valueOrFreq,levels{i});
    OutputCom(s); 
    pause(tdel);
Angle=getAngleVideo(video,box,0);    
Angles(i)=Angle; 

% Change message
if Index<=markss.Count
% Update handles structure
if (strcmp(modes{1},'MIDC'))||(strcmp(modes{1},'MIAC'))
    s=strcat({'Сила тока установлена на '},num2str(params{2}(i),2),' A');
else
    s=strcat({'Напряжение установлено на '},num2str(params{2}(i),2),' В');
end
%set(handles.txt,'String',s);
Index=Index+1;
end
end
%Перевести на 0!
s=strcat(valueOrFreq,levels{2});
OutputCom(s);
OutputCom('OPR');
s=strcat({'Готово'}); 

%Output scale. Prepare creating an image
imd=ImFigureDrawR(72,52); 
% alpha=-2.9; 
alpha=0.9;
dAngle=1.5;
fi1min=135-dAngle+alpha; fi1max=135+dAngle+alpha;
fi2min=45-dAngle+alpha; fi2max=45+dAngle+alpha;
fi3min=90-dAngle; fi3max=90+dAngle;
Angles
markss.Angles=(Angles+alpha)*pi/180; 
%Check angles
Ang1=Angles(1)+alpha; Ang2=Angles(size(Angles,2))+alpha; dAng=Ang1-Ang2;
if (Ang1<fi1min)||(Ang1>fi1max)
    s=['Первый угол не входит ' num2str(Ang1,3)];
    panel.addMessage(s,[0.9 0.4 0.7]);
else 
    s=['Первый угол входит ' num2str(Ang1,3)];
    panel.addMessage(s,[0.9 0.4 0.7]);
end

if (Ang2<fi2min)||(Ang2>fi2max)
    s=['Второй угол не входит ' num2str(Ang2,3)];
    panel.addMessage(s,[0.9 0.4 0.7]);
else 
    s=['Второй угол входит ' num2str(Ang2,3)];
    panel.addMessage(s,[0.6 0.9 0.6]);
end

if (dAng<fi3min)||(dAng>fi3max)
    s=['Разность углов не входит ' num2str(dAng,3)];
    panel.addMessage(s,[0.9 0.4 0.7]);
else 
    s=['Разность углов входит ' num2str(dAng,3)];
    panel.addMessage(s,[0.6 0.9 0.6]);
end

DrawScaleR(imd,device);
markss.draw(imd);
%delete('scale.jpg');
imd.saveToFile('scale'); 
panel.addMessage('Рисунок шкалы сформирован',[0.6 0.9 0.6]);
set(BRun,'Enable','on');
showScale;
end

function showScale()
global fshow;
%Read the scale's number from ini-file
sdev = getScale();
%Choice a scale by their number
sz = [600 800]; % figure size
screensize = get(0,'ScreenSize');
xpos = ceil((screensize(3)-sz(2))/2); % center the figure on the screen horizontally
ypos = ceil((screensize(4)-sz(1))/2); % center the figure on the screen vertically
fshow = figure(...
    'position',[xpos, ypos, sz(2), sz(1)],...
    'NumberTitle','off', ...
    'units','pixels',...    
    'MenuBar','none',...
    'color', [0.9 0.9 0.9],...
    'PaperPositionMode','auto',...
    'Name','Вид готовой шкалы',...
    'Tag','gui',...
    'Resize','off');    
    %BNumber = uicontrol('Parent',fshow,'Style', 'pushbutton', 'FontSize',16,'String','Печать',...
     %'Position', [200 sz(1)-550 200 50],'Callback',{@bprint});
    BSave = uicontrol('Parent',fshow,'Style', 'pushbutton', 'FontSize',16,'String','Сохранить',...
     'Position', [450 sz(1)-550 200 50],'Callback',{@bsave});
 
    ShowAxes=axes('Parent',fshow,'Position',[0.1 0.2 0.8 0.7]);
    axes(ShowAxes);
    im=imread('scale.jpg');
    imshow(im);
end

function bsave(hObject, eventdata)
%Run script for CorelDraw saving
global fshow commands Angles alpha params;
close(fshow); %Закрыть окно
sdev = getScale();
sdev

%Сформировать имя файла для сохранения
readKeys = {'Scale','id','name'}; 
readSet = inifile('settings.ini','read',readKeys); 
n=str2num(readSet{1}); 

dial_root = fullfile(pwd);
%Подключение библиотеки dll
asm = NET.addAssembly(fullfile(dial_root, 'CLOutput\bin\Debug\CLOutput.dll'));

%Создание списка команд
commands = cell(1,1);

path = fullfile(dial_root, 'Images\\');
%Создание документа
commands{end+1,1} = 'corelDraw = CLOutput.CorelDraw(false);';
commands{end+1,1} = 'application = corelDraw.Application;';
commands{end+1,1} = strcat('corelDraw.openDocument(''', fullfile(dial_root, 'Images\\sample.cdr'), ''');');
commands{end+1,1} = 'drawer = CLOutput.Drawer(corelDraw);'; %Запускается только при наличии открытого документа

%В формате cdr
device=strcat('device',sdev);
mode=getModeV(device);

marks=MarksV(params);
%marks.Angles=linspace(135,45,marks.Count); 
marks.Angles=(Angles+alpha)*pi/180;
imd=ImFigureDrawV(72,52);
DrawScaleV(imd,device);
marks.draw(imd);
imd.saveToFile('Images/scale');

commands{end+1,1} = 'drawer.groupAll();';
commands{end+1,1} = 'corelDraw.deleteLayers();';
snumber = num2str(n);
commands{end+1,1} = strcat('corelDraw.saveDocumentAs(''', fullfile(dial_root, strcat('Output\\', snumber, '_v.cdr')), ''');');
commands{end+1,1} = strcat('corelDraw.closeDocument();');
commands{end+1,1} = strcat('corelDraw.closeDocument();');


%Выполнение всех команд
commands = commands(~cellfun('isempty',commands));
tic;

% если 1 - печатаются все выполняемые команды, если 0 - только в случае
% возникновения ошибки
verbose_evaluating = 0;
for i=1:1:size(commands,1)
    if verbose_evaluating 
        disp(strcat('Evaluating command#', num2str(i), ':', commands{i,1}))
    end
try
    eval(commands{i,1});
catch ME
    if ~verbose_evaluating 
        disp(strcat('Error in command#', num2str(i), ':', commands{i,1}))
    end
    disp(ME.identifier)
    disp(ME.message)
    disp(ME.cause)
    disp(ME.stack)
end
%disp(i);
end
toc;
%Сохранение номера шкалы
clear commands;
incNumber;
end

function bsaveCorel(hObject, eventdata)
%Save with linear scale
global commands;

sdev = getScale();

readKeys = {'Scale','id','name'}; 
readSet = inifile('settings.ini','read',readKeys); 
n=str2num(readSet{1}); 

dial_root = fullfile(pwd);
%Подключение библиотеки dll
asm = NET.addAssembly(fullfile(dial_root, 'CLOutput\bin\Debug\CLOutput.dll'));

%Создание списка команд
commands = cell(1,1);

path = fullfile(dial_root, 'Images\\');
%Создание документа
commands{end+1,1} = 'corelDraw = CLOutput.CorelDraw(false);';
commands{end+1,1} = 'application = corelDraw.Application;';
commands{end+1,1} = strcat('corelDraw.openDocument(''', fullfile(dial_root, 'Images\\sample.cdr'), ''');');
commands{end+1,1} = 'drawer = CLOutput.Drawer(corelDraw);'; %Запускается только при наличии открытого документа

%В формате cdr
device=strcat('device',sdev);
mode=getModeV(device);
scale1=mode{2};
params=getParams(scale1);
marks=MarksV(params);
marks.Angles=linspace(135,45,marks.Count); 

marks.Angles=marks.Angles*pi/180;
imd=ImFigureDrawV(72,52);
DrawScaleV(imd,device);
marks.draw(imd);
imd.saveToFile('Images/scale');

commands{end+1,1} = 'drawer.groupAll();';
commands{end+1,1} = 'corelDraw.deleteLayers();';
snumber = num2str(n);
commands{end+1,1} = strcat('corelDraw.saveDocumentAs(''', fullfile(dial_root, strcat('Output\\', snumber, '_v.cdr')), ''');');
commands{end+1,1} = strcat('corelDraw.closeDocument();');

%Выполнение всех команд
commands = commands(~cellfun('isempty',commands));
tic;

% если 1 - печатаются все выполняемые команды, если 0 - только в случае
% возникновения ошибки
verbose_evaluating = 0;
for i=1:1:size(commands,1)
    if verbose_evaluating 
        disp(strcat('Evaluating command#', num2str(i), ':', commands{i,1}))
    end
try
    eval(commands{i,1});
catch ME
    if ~verbose_evaluating 
        disp(strcat('Error in command#', num2str(i), ':', commands{i,1}))
    end
    disp(ME.identifier)
    disp(ME.message)
    disp(ME.cause)
    disp(ME.stack)
end
%disp(i);
end
toc;
%Сохранение номера шкалы
readKeys = {'scale','id','name'}; 
readSet = inifile('settings.ini','read',readKeys); 
n=str2num(readSet{1}); 
n=n+1;
s=int2str(n);
writeKeys = {'scale','id','name',s};
inifile('settings.ini','write',writeKeys,'plain');
end
