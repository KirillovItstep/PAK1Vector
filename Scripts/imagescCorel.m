function imagescCorel(x,y,fileName)
%�������� ����������� cdr
%x,y - ���������� �����

global commands;

%strcat(pwd,'/',fileName)
fullFileName = strcat(pwd,'\',fileName);
commands{end+1,1} = strcat('drawer.insertImage(''',fullFileName,''',', num2str(x),',', num2str(y),');');
%drawer.insertImage('C:/Users/Kirillov/Documents/Dial/Pak1Matlab/Images/eac.cdr',x,y);
end

