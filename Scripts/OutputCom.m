function [] = OutputCom(str)
%
if  size(instrfind,2)~=0 
    fclose(instrfind);
end
%������������� ��� �����
s=serial('COM1','BaudRate' ,9600,'DataBits' ,8,'Parity' ,'even','StopBits' ,1,'Terminator','LF');
fopen(s); %�������� �����
fprintf(s,str); 
%�������� �����
fclose(s);
delete(s);
clear s;
end

