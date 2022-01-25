r1=38; r2=40.5; w1=0.3; r3=42; w2=0.7; k1=3.8;
readKeys = {'device35','number','name'}; readSet = inifile('settings.ini','read',readKeys); format='yy'; k=datestr(now,format); k=char(strcat(k,readSet)); textCorel(54*px,11.5*px,k,'FontName','GOST 26.008—85','FontSize',1.8*px*1.2*k1,'VerticalAlignment','baseline','HorizontalAlignment','left');
textCorel(36*px,12.5*px,'50Hz','FontName','GOST 26.008—85','FontSize',1.6*px*1.33*k1,'VerticalAlignment','baseline','HorizontalAlignment','center');
textCorel(36*px,21*px,'x10V','FontName','GOST 26.008—85','FontSize',6*px*k1,'VerticalAlignment','baseline','HorizontalAlignment','center');
textCorel(54*px,14.5*px,'Ý8033','FontName','GOST 26.008—85','FontSize',2*px*1.33*k1,'VerticalAlignment','baseline','HorizontalAlignment','left');
setColor([0 0 0 0]); rectangleCorel('Position',[0,0,72,52]*px,'LineWidth',0.0762);setColor([0 0 0 100]);
lineCorel([33.4,35.8]*px,[12,12]*px,'LineWidth',0.25*px,'Color',[0 0 0 100]);
im=imreadCorel('Images/field_a25.bmp'); [h,w,d]=sizeCorel(im); imagescCorel(13*px,12.5*px,im);
