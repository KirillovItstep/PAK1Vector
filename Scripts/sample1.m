clc; clear all;
imd=ImFigureDraw(72,52);
% ѕо названию прибора определить режим, шкалу1, шкалу2
device='device012';
mode=getMode(device);
scale1=mode{2};
scale2=mode{3};
% ”становить нужный режим на приборе
modes=regexp(mode{1}, ';', 'split');
%Output to com port mode set commands
for j=1:1:size(modes,2)
    %OutputCom(modes{j});        
    modes{j};
end
% ќпределить угол стрелки дл€ 0-го сигнала
Angle0=135;
% ѕрочитать параметры первой шкалы
params=getParams(scale1);
% ѕодать первый сигнал
 %s=strcat('V',num2str(params{2}(2},2)); OutputCom(s);
sig1=params{2}(2);
% ќпределить угол стрелки дл€ 1-го сигнала
Angle1=125;
% ≈сли стрелка отстоит более, чем на 13,6 градусов, загрузить вторую шкалу
if (Angle0-Angle1)>13.6
    params=getParams(scale2);
end
% ѕровести измерени€
Angles=linspace(135,45,params{1});
% ¬ывести шкалу и метки
marks=Marks(params);
marks.Angles=Angles*pi/180; 
marks.draw(imd);
DrawScale(imd,device);
delete('scale.jpg');
imd.saveToFile('scale');
