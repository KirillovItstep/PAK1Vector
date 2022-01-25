function [Value] = fromCom()
if  size(instrfind,2)~=0 
    fclose(instrfind);
end
%Инициализация СОМ порта
s=serial('COM1','BaudRate' ,9600,'DataBits' ,8,'Parity' ,'even','StopBits' ,1,'Terminator','LF');
fopen(s); %Открытие порта
fprintf(s,'V?'); 
str=fscanf(s,'%c');
%Закрытив порта
fclose(s);
delete(s);
clear s;
Value=str2double(str);
end