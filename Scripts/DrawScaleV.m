function DrawScaleV(imd,device)

px=0;
path='';
clear v; delete('v.m');
%Open script file
fileID = fopen('v.m','w');
%Read from ini file
readKeys = {device,'parent','name','',device,'','desc',''};
readSet = inifile(strcat(path,'devicesV.ini'),'read',readKeys);

%Processing parents scripts
parents=regexp(readSet(1), ',', 'split');
count=size(parents{1});

for i=1:1:count(2)  
%Read from ini file
parent=parents{1}(1,i);
readKeys = {parent{1},'script','string',''};
readSet = inifile(strcat(path,'devicesV.ini'),'read',readKeys);
fprintf(fileID,'%s\n',readSet{1});
end

%Close script file
fclose(fileID);

end

