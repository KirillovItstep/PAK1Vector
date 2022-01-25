function [fileName]=imreadCorel(fileName)
%Изменяет расширение файла на cdr
fileName = regexprep(fileName,'.bmp','','ignorecase');
fileName = strcat(fileName,'.cdr');

end

