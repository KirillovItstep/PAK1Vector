clc; clear all;
imd=ImFigureDraw(72,52);
% �� �������� ������� ���������� �����, �����1, �����2
device='device012';
mode=getMode(device);
scale1=mode{2};
scale2=mode{3};
% ���������� ������ ����� �� �������
modes=regexp(mode{1}, ';', 'split');
%Output to com port mode set commands
for j=1:1:size(modes,2)
    %OutputCom(modes{j});        
    modes{j};
end
% ���������� ���� ������� ��� 0-�� �������
Angle0=135;
% ��������� ��������� ������ �����
params=getParams(scale1);
% ������ ������ ������
 %s=strcat('V',num2str(params{2}(2},2)); OutputCom(s);
sig1=params{2}(2);
% ���������� ���� ������� ��� 1-�� �������
Angle1=125;
% ���� ������� ������� �����, ��� �� 13,6 ��������, ��������� ������ �����
if (Angle0-Angle1)>13.6
    params=getParams(scale2);
end
% �������� ���������
Angles=linspace(135,45,params{1});
% ������� ����� � �����
marks=Marks(params);
marks.Angles=Angles*pi/180; 
marks.draw(imd);
DrawScale(imd,device);
delete('scale.jpg');
imd.saveToFile('scale');
