clc; clear all;

%������� ��� ������� com �����
instrreset;
tdel = 0.5;

%������������� ��� �����
sport=serial('COM1','BaudRate' ,9600,'DataBits' ,8,'Parity' ,'even','StopBits' ,1,'Terminator','LF');
fopen(sport); %�������� �����
%���������� ���, 1�
s='MIAC'; fprintf(sport,s); 
s='R6'; fprintf(sport,s); 
s='F50'; fprintf(sport,s); 
s='V5'; fprintf(sport,s); 
pause(tdel);
fprintf(sport,'OPR'); 
fclose(sport);

