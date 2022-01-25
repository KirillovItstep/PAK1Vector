clc; clear all; close all;

im0=imread('resa.jpg'); im0 = rgb2gray(im0);
image = imread('Frames/17.jpg');
frame = image;
frame=rgb2gray(frame); 

frame=imsubtract(frame,im0);
%figure,imshow(frame); return;

frame(frame==0)=255;
bw=im2bw(frame,0.5);
%figure,imshow(bw);

bw=imcomplement(bw);
imwrite(bw,'scale_last.jpg','jpg');

% Get properties of regions
[L,numObjects]=bwlabel(bw);
stats = regionprops(L,'Area','Orientation');

% Sort by area
area=0; ind=1;
for i=1:1:length(stats)
    if (stats(i).Area>area)
        area=stats(i).Area;
        ind=i;
    end 
end
Area=stats(ind).Area; Orientation=stats(ind).Orientation;
if (Orientation<0)
    Orientation=Orientation+180;
end
Angle=Orientation;
disp(Angle);