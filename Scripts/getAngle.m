function [Angle] = getAngle(frame, box)
%����������� ���� � ����� ��������������� ������
%frame - ����, box - ������������� ��� �������

gray=rgb2gray(frame); 

mask = boolean(gray);
mask(:) = 0;
mask(box(2):box(2)+box(4), box(1):box(1)+box(3))= 1;
%figure, imshow(mask); return;
gray(~mask) = 0;
%figure, imshow(gray); return;

%��������� ����� ��� (������ ��������)
%gray = imresize(gray,0.25);

%����� ��� ��� ���� ��������
idx = uint8(otsu(gray,3));
%figure,imshow(IDX);
%�������� ���� ������� ������
bw = im2bw(gray);
bw(idx==1) = 0;
bw(idx==2) = 0;
bw(idx==3) = 1;

%figure,imshow(bw); return;

bw = imfill(bw,'holes');
stats = regionprops(bw,'Area');
areas = cat(1,stats.Area);
%������������ �������
maxArea = max(areas(:));
bw = bwareaopen(bw,maxArea);
%figure,imshow(bw); return;

bw2 = bw;
%������ �������
for i=0:30:180
se = strel('line',25,i);
bw2 = imclose(bw2,se);
end

%figure,imshow(bw); return;

%figure,imshow(gray); return;

bw = imcrop(bw,box);
bw2 = imcrop(bw2,box);
arrow = bw2-bw;
%figure,imshow(arrow); return;

%�������� ���� ������ ������������ �������
arrow = bwareaopen(arrow,100);
stats = regionprops(arrow,'Area');
areas = cat(1,stats.Area);
%������������ �������
maxArea = max(areas(:));
arrow = bwareaopen(arrow,maxArea);

%figure,imshow(arrow); return;

stats = regionprops(arrow,'Orientation');
orientations = cat(1,stats.Orientation);
Angle = orientations;
if (Angle<0)
    Angle=Angle+180;
end
end

