function [h,w,d]=sizeCorel(fileName)
%Определяет размер изображения cdr

global commands;

corelDraw = CLOutput.CorelDraw(false);
corelDraw.createDocument();
drawer = CLOutput.Drawer(corelDraw);
fullFileName = strcat(pwd,'\',fileName);
drawer.getImageSize(fullFileName);
corelDraw.closeDocument();
h = drawer.Height;
w = drawer.Width;
d = 0;
end

