frame=imread('res0.jpg');
%�������� ������ �������
%frame - �������
%box - ������������� ��� �������

%��������������� ��� ��������� ��������
image = imresize(frame,0.25);
%figure,imshow(image); return;
gray = rgb2gray(image);

%����� ��� ��� ���� ��������
idx = uint8(otsu(gray,3));

%������� ���� ������� ������
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

%���������� ���������� �� ��������������� ������
stats = regionprops(bw,'Area', 'Perimeter');
areas = cat(1,stats.Area);
perimeters = cat(1,stats.Perimeter);
%return;

%����� ������� �������� � ������� �����������
indexes = find((areas>2500)&(perimeters>250)&(areas./perimeters.^2<1/10)&(areas./perimeters.^2>1/25));
%������� � ����������� �������� �������
labels = bwlabel(bw);
[height, width] = size(bw);
wanted = boolean(zeros(height,width));
for i=1:size(indexes,1)
    wanted = (wanted)|(labels==indexes(i));
end
bw = wanted;

%figure,imshow(bw); return;

%�������� ������ ���� ������������ �������
stats = regionprops(bw,'Area');
areas = cat(1,stats.Area);
%������������ �������
maxArea = max(areas(:));
index = find(maxArea); 
labeledImage = bwlabel(bw);
bw = ismember(labeledImage, index); 
%figure, imshow(bw);

stats = regionprops(bw,'BoundingBox');
boundingBoxes = cat(1,stats.BoundingBox);

%��������� - ���������� ������� �����
box = boundingBoxes*4;

%rgbIm = imcrop(origin,box);

