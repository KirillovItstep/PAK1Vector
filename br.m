r1=38; r2=40.5; w1=0.3; r3=42; w2=0.7;
readKeys = {'device35','number','name'}; readSet = inifile('settings.ini','read',readKeys); format='yy'; k=datestr(now,format);k(2)=k(2);  k=strcat(k,readSet); text(54*px,imd.HeightPx-11.5*px,k,'FontName','GOST 26.008—85','FontSize',1.8*px*1.2,'VerticalAlignment','baseline');
text(36*px,imd.HeightPx-12.5*px,'50Hz','FontName','GOST 26.008—85','FontSize',1.6*px*1.33,'VerticalAlignment','baseline','HorizontalAlignment','center');
text(36*px,imd.HeightPx-21*px,'x10V','FontName','GOST 26.008—85','FontSize',6*px,'VerticalAlignment','baseline','HorizontalAlignment','center');
text(54*px,imd.HeightPx-14.5*px,'Ý8033','FontName','GOST 26.008—85','FontSize',2*px*1.33,'VerticalAlignment','baseline');
rectangle('Position',[0.1,0.1,71.9,51.9]*px,'LineWidth',3);
line([33.4,35.8]*px,imd.HeightPx-[12,12]*px,'LineWidth',0.25*px,'Color',[0 0 0]);
im=imread('Images/field_a25.bmp'); [h,w,d]=size(im); imagesc(6*px,imd.HeightPx-12.5*px-h/2,im);
