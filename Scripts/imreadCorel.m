function [fileName]=imreadCorel(fileName)
%�������� ���������� ����� �� cdr
fileName = regexprep(fileName,'.bmp','','ignorecase');
fileName = strcat(fileName,'.cdr');

end

