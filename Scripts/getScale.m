function [NumberScale] = getScale()
%Get scale
readKeys = {'Scale','number','name',''};
sdev = char(inifile('settings.ini','read',readKeys));
%Check if the scale is exists
device=strcat('device',sdev);
mode=getModeR(device);
if isempty(mode{2})
NumberScale='000';
else
NumberScale=sdev;
end
end

