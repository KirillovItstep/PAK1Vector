clc; clear all;

%Удалить все объекты com порта
%instrreset;

%sdev = getScale();
sdev='024';
device=strcat('device',sdev);
mode=getMode(device);
scale1=mode{2};
scale2=mode{3};
% Init calibrator; output to com port mode set commands
modes=regexp(mode{1}, ';', 'split');
for j=1:1:size(modes,2)
    OutputCom(modes{j});
    modes{j}
end
%return;

params=getParams(scale1);
% Get angle for the first signal
%Put signal
levels=regexp(params{2}, ' ', 'split');

tdel=1;
if  size(instrfind,2)~=0     
    fclose(instrfind);
end
%Инициализация СОМ порта
sport=serial('COM1','BaudRate' ,9600,'DataBits' ,8,'Parity' ,'even','StopBits' ,1,'Terminator','LF');
fopen(sport); %Открытие порта

%Output to calibrator
s=strcat('V',levels{1});
    fprintf(sport,s); 
    pause(tdel);
    fprintf(sport,'OPR'); 

%Output maximal level

for i=1:1:size(levels,2)
    s=strcat('V',levels{i});
    OutputCom(s);
    pause(tdel);    
end 
OutputCom('OPR');