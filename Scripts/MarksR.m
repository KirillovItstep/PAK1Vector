classdef MarksR
    % Draws marks of a scale
    %
    
    properties
        Count
        Levels
        Shorts
        Labs
        Angles        
    end
    
    methods
    function marks = MarksR(params)
    marks.Count=params{1};
    marks.Levels=params{2};
    marks.Shorts=params{3};
    label=params{4};
    options=params{5};    
    labels=regexp(label, ';', 'split');    
    countl=size(labels,2); %Count of labels
    marks.Labs=cell(countl,3);
    for j=1:1:countl
        marks.Labs{j,1}=labels{j};
        marks.Labs{j,2}=options(j,1);
        marks.Labs{j,3}=options(j,2);
    end
        end
        
         function draw(MarksR,imd)     
            r1=38; r2=40.5; w1=0.35; r3=42; w2=0.75;             
            shorts=MarksR.Shorts; 
            angles=MarksR.Angles;
            labs=MarksR.Labs;
            count=MarksR.Count;
            NumAng=linspace(1,count,count);
            NumAnglel=setdiff(NumAng,shorts);
            px=imd.PxInMm;                        
            %Short marks
for i=1:1:size(MarksR.Shorts,2)        
x1=36+r1*cos(angles(shorts(i))); y1=r1*sin(angles(shorts(i)))-1.1; 
x2=36+r2*cos(angles(shorts(i))); y2=r2*sin(angles(shorts(i)))-1.1;  
line([x1,x2]*px,imd.HeightPx-[y1,y2]*px,'LineWidth',w1*px,'Color',[0 0 0]); 
end
%Long marks
for i=1:1:size(NumAnglel,2)        
x1=36+r1*cos(angles(NumAnglel(i))); y1=r1*sin(angles(NumAnglel(i)))-1.1; 
x2=36+r3*cos(angles(NumAnglel(i))); y2=r3*sin(angles(NumAnglel(i)))-1.1;  
line([x1,x2]*px,imd.HeightPx-[y1,y2]*px,'LineWidth',w2*px,'Color',[0 0 0]); 
end
%Different positions for Labs: first - digit; second - mark, third - type
for i=1:1:size(labs,1)    
switch labs{i,3}
    case 0 
    r=r1-0.7; text((36+r*cos(angles(labs{i,2})))*px,imd.HeightPx-(r*sin(angles(labs{i,2})))*px,labs(i,1),'FontName','GOST 26.008—85','FontSize',4*px*1.33,'VerticalAlignment','top','HorizontalAlignment','center');
    case 1
    r=r1+4; text((36+r*cos(angles(labs{i,2})))*px,imd.HeightPx-(r*sin(angles(labs{i,2})))*px,labs(i,1),'FontName','GOST 26.008—85','FontSize',2.5*px*1.33,'VerticalAlignment','bottom','HorizontalAlignment','right');
    case 2
    r=r1+5; text((36+r*cos(angles(labs{i,2})))*px,imd.HeightPx-(r*sin(angles(labs{i,2})))*px,labs(i,1),'FontName','GOST 26.008—85','FontSize',4*px*1.33,'VerticalAlignment','bottom','HorizontalAlignment','center');    
    case 3
    r=r1-1; text((36+r*cos(angles(labs{i,2})))*px,imd.HeightPx-(r*sin(angles(labs{i,2})))*px,labs(i,1),'FontName','GOST 26.008—85','FontSize',4*px*1.33,'VerticalAlignment','top','HorizontalAlignment','center');
end
end
%Point for the first mark
im=imread('Images/circle1.bmp'); r=r1-1; imagesc((36+r*cos(angles(2)))*px,imd.HeightPx-(r*sin(angles(2))-1.1)*px,im);
%Run script
run('br');
%delete('br.m');
        end
    end
    
end


