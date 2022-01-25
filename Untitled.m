
if  size(instrfind,2)~=0     
    fclose(instrfind);
end
instrreset;

sport=serial('COM1','BaudRate' ,9600,'DataBits' ,8,'Parity' ,'even','StopBits' ,1,'Terminator','LF');
fopen(sport);
OutputCom('MIAC');
OutputCom('R6');
OutputCom('F50');
