clc; clear all; close all;
global commands;

%Forming an image of the linear scale
sdev='151';

%Получить рисунок в формате jpg
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
imd.saveToFile('Images/scale');

dial_root = fullfile(pwd);
%Подключение библиотеки dll
asm = NET.addAssembly(fullfile(dial_root, 'CLOutput\bin\Debug\CLOutput.dll'));

%Создание списка команд
commands = cell(1,1);

path = fullfile(dial_root, 'Pak1Matlab\\Images\\');
%Создание документа
commands{end+1,1} = 'corelDraw = CLOutput.CorelDraw(true);';
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

commands{end+1,1} = strcat('corelDraw.saveDocumentAs(''', fullfile(dial_root, 'Images\\scale.cdr'), ''');');
commands{end+1,1} = 'drawer.groupAll();';
commands{end+1,1} = 'corelDraw.deleteLayers();';
commands{end+1,1} = strcat('corelDraw.importJPG(''', fullfile(dial_root, 'Images/scale.jpg'), ''',0,0,72,52);');
%commands{end+1,1} = strcat('corelDraw.saveDocumentAs(''', fullfile(dial_root, 'Images\\scale.cdr'), ''');');
commands{end+1,1} = strcat('corelDraw.saveDocumentAs(''', fullfile(dial_root, strcat('Output\\', device, '_V.cdr')), ''');');

%delete('scale.jpg');
%imd.saveToFile('scale_o');
%image=frame2im(getframe(gca));

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
