function [x,y] = getCoords()
%Get coordinates
xKey = {'Laser','coords','x','d',0};
x= inifile('settings.ini','read',xKey);
x=x{1};
yKey = {'Laser','coords','y','d',0};
y= inifile('settings.ini','read',yKey);
y=y{1};
end

