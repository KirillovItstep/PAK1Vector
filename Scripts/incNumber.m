function [] = incNumber()
% Increment the number of the device.

readKeys = {'scale','id','name'}; 
readSet = inifile('settings.ini','read',readKeys); 
n=str2num(readSet{1}); 
n=n+1;
s=int2str(n);
writeKeys = {'scale','id','name',s};
inifile('settings.ini','write',writeKeys,'plain');

%5-значный номер???
readKeys = {'device35','number','name'};
readSet = inifile('settings.ini','read',readKeys); 
n=str2num(readSet{1}); 
n=n+1;
s=int2str(n);
%5-значный номер
czeros=5-length(s);
for i=1:1:czeros 
    s=strcat('0',s); 
end 
writeKeys = {'device35','number','name',s};
inifile('settings.ini','write',writeKeys,'plain');

end

