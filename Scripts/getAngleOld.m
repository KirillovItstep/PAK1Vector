function [Angle] = getAngle(image,image0)
% Calculate the Angle of an Arrow. Data gets from file.
%ќпределение угла с белой технологической шкалой
frame=image;
im0=image0;

frame=rgb2gray(frame); 

frame=imsubtract(frame,im0);
frame(frame==0)=255;
bw=im2bw(frame,0.5);

%{
se = strel('disk',8);
bw = imopen(bw,se);

se = strel('disk',2);        
bw=imclose(bw,se);
%}
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
end

