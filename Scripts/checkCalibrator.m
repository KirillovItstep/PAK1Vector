clc; clear all;

%Удалить все объекты com порта
instrreset;
tdel = 0.5;

%Инициализация СОМ порта
sport=serial('COM1','BaudRate' ,9600,'DataBits' ,8,'Parity' ,'even','StopBits' ,1,'Terminator','LF');
fopen(sport); %Открытие порта
%Переменный ток, 1А
s='MIAC'; fprintf(sport,s); 
s='R6'; fprintf(sport,s); 
s='F50'; fprintf(sport,s); 
s='V5'; fprintf(sport,s); 
pause(tdel);
fprintf(sport,'OPR'); 
fclose(sport);

