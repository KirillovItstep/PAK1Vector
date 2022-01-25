frame=imread('res0.jpg');
%Оставить только стрелку
%frame - рисунок
%box - прямоугольник для обрезки

%Масштабирование для повышения скорости
image = imresize(frame,0.25);
%figure,imshow(image); return;
gray = rgb2gray(image);

%Метод Оцу для трех областей
idx = uint8(otsu(gray,3));

%Удалить один светлый объект
bw = im2bw(gray);
bw(idx==1) = 0;
bw(idx==2) = 0;
bw(idx==3) = 1;

%figure,imshow(bw); return;
%{
%Particle swarm optimization method
[imageSeg, intensity]=segmentation(gray,3,'pso');
maxInt = max(intensity);
imageSeg(imageSeg<maxInt) = 0;
%figure, imshow(imageSeg); return;

bw = im2bw(imageSeg,graythresh(imageSeg));
%}

%figure,imshow(bw); return;

bw = bwareaopen(bw,250);
%figure,imshow(bw); return;

se = strel('disk',3);
bw = imclose(bw,se);

bw = imfill(bw,'holes');
%figure,imshow(bw); return;

%Определить подходящий по характеристикам объект
stats = regionprops(bw,'Area', 'Perimeter');
areas = cat(1,stats.Area);
perimeters = cat(1,stats.Perimeter);
%return;

%Найти индексы областей с нужными параметрами
indexes = find((areas>2500)&(perimeters>250)&(areas./perimeters.^2<1/10)&(areas./perimeters.^2>1/25));
%Удалить с изображения ненужные области
labels = bwlabel(bw);
[height, width] = size(bw);
wanted = boolean(zeros(height,width));
for i=1:size(indexes,1)
    wanted = (wanted)|(labels==indexes(i));
end
bw = wanted;

%figure,imshow(bw); return;

%Оставить только один максимальной площади
stats = regionprops(bw,'Area');
areas = cat(1,stats.Area);
%Максимальная площадь
maxArea = max(areas(:));
index = find(maxArea); 
labeledImage = bwlabel(bw);
bw = ismember(labeledImage, index); 
%figure, imshow(bw);

stats = regionprops(bw,'BoundingBox');
boundingBoxes = cat(1,stats.BoundingBox);

%Результат - координаты обрезки шкалы
box = boundingBoxes*4;

%rgbIm = imcrop(origin,box);

