clc; clear all; close all;
Number = '024';
sdev=Number;
device=strcat('device',sdev);
mode=getMode(device);
scale1=mode{2};
params=getParams(scale1);
marks=Marks(params);
marks.Angles=linspace(135,45,marks.Count); 
marks.Angles=marks.Angles*pi/180;
imd=ImFigureDraw(72,52);
DrawScale(imd,device);
marks.draw(imd);
%delete('scale.jpg');
imd.saveToFile('scale0'); 