%clc; clear all; close all;
global commands ;

sdev = getScale();

readKeys = {'device35','number','name'}; 
readSet = inifile('settings.ini','read',readKeys); 
n=str2num(readSet{1}); 
n=n+1;
s=int2str(n);
czeros=5-length(s);
for i=1:1:czeros 
    s=strcat('0',s); 
end 
writeKeys = {'device35','number','name',s};
inifile('settings.ini','write',writeKeys,'plain');

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
