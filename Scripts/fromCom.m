function [Value] = fromCom()
if  size(instrfind,2)~=0 
    fclose(instrfind);
end
%������������� ��� �����
s=serial('COM1','BaudRate' ,9600,'DataBits' ,8,'Parity' ,'even','StopBits' ,1,'Terminator','LF');
fopen(s); %�������� �����
fprintf(s,'V?'); 
str=fscanf(s,'%c');
%�������� �����
fclose(s);
delete(s);
clear s;
Value=str2double(str);
end