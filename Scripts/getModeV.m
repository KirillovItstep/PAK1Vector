function [modes] = getModeV(device)
%Get mode, scale1, scale2 by name of device
readKeys = {device,'parent','name','',
    device,'parent','mode','',
    device,'parent','scale1','',
    device,'parent','scale2',''};
readSet = inifile(strcat('devicesV.ini'),'read',readKeys);
mode=readSet{2};
scale1=readSet{3};
scale2=readSet{4};
modes={mode;scale1;scale2};
end

