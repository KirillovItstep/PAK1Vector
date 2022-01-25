function DrawScale(imd,device)

px=imd.PxInMm;
path='';

%Open script file
fileID = fopen(strcat(path,'b.m'),'w');
%Read from ini file
readKeys = {device,'parent','name','',device,'','desc',''};
readSet = inifile(strcat(path,'devices.ini'),'read',readKeys);

%Processing parents scripts
parents=regexp(readSet(1), ',', 'split');
count=size(parents{1});

for i=1:1:count(2)  
%Read from ini file
parent=parents{1}(1,i);
readKeys = {parent{1},'script','string',''};
readSet = inifile(strcat(path,'devices.ini'),'read',readKeys);

fprintf(fileID,'%s\n',readSet{1});
end

%Close script file
fclose(fileID);

end

