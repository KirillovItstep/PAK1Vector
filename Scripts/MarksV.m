classdef MarksV
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
    function marks = MarksV(params)
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
        
         function draw(MarksV,imd)            
            r1=38; r2=40.5; w1=0.3; r3=42; w2=0.7; 
            k1=3.8; %Коэффициент увеличения шрифта
            delta = 1; %Смещение меток относительно остальной части шкалы???

            shorts=MarksV.Shorts; 
            angles=MarksV.Angles;
            labs=MarksV.Labs;
            count=MarksV.Count;
            NumAng=linspace(1,count,count);
            NumAnglel=setdiff(NumAng,shorts);
            px=imd.PxInMm;
            %Short marks
for i=1:1:size(MarksV.Shorts,2)        
x1=36+r1*cos(angles(shorts(i))); y1=r1*sin(angles(shorts(i))); 
x2=36+r2*cos(angles(shorts(i))); y2=r2*sin(angles(shorts(i)));  
lineCorel([x1,x2]*px,[y1,y2]*px,'LineWidth',w1*px,'Color',[0 0 0 100]); 
end
%Long marks
for i=1:1:size(NumAnglel,2)        
x1=36+r1*cos(angles(NumAnglel(i))); y1=r1*sin(angles(NumAnglel(i))); 
x2=36+r3*cos(angles(NumAnglel(i))); y2=r3*sin(angles(NumAnglel(i)));  
lineCorel([x1,x2]*px,[y1,y2]*px,'LineWidth',w2*px,'Color',[0 0 0 100]); 
end
%Different positions for Labs: first - digit; second - mark, third - type

for i=1:1:size(labs,1) 
    %{
    r = r1;
    x = (36+r*cos(angles(labs{i,2})))*px; disp(x);
    y = r*sin(angles(labs{i,2}))*px; disp(y);
    %}
switch labs{i,3}
    case 0     
    r=r1-0.7;     
    %r=r1-2.2;     
    textCorel((36+r*cos(angles(labs{i,2})))*px,r*sin(angles(labs{i,2}))*px,char(labs(i,1)),'FontName',getGostFont(),'FontSize',4*px*1.33*k1,'VerticalAlignment','top','HorizontalAlignment','center');
    case 1
    %r=r1+4.7; 
    r=r1+4; 
    textCorel((36+r*cos(angles(labs{i,2})))*px,r*sin(angles(labs{i,2}))*px,char(labs(i,1)),'FontName',getGostFont(),'FontSize',2.5*px*1.33*k1,'VerticalAlignment','bottom','HorizontalAlignment','right');
    case 2
    %r=r1+6.15; 
    r=r1+5; 
    textCorel((36+r*cos(angles(labs{i,2})))*px,r*sin(angles(labs{i,2}))*px,char(labs(i,1)),'FontName',getGostFont(),'FontSize',4*px*1.33*k1,'VerticalAlignment','bottom','HorizontalAlignment','center');    
    case 3
    %r=r1-2.2; 
    r=r1-1; 
    textCorel((36+r*cos(angles(labs{i,2})))*px,r*sin(angles(labs{i,2}))*px,char(labs(i,1)),'FontName',getGostFont(),'FontSize',4*px*1.33*k1,'VerticalAlignment','top','HorizontalAlignment','center');
end
end
%Point for the first mark
im=imreadCorel('Images\circle1.bmp'); [h,w,d]=sizeCorel(im); r=r1-1; imagescCorel((36+r*cos(angles(2)))*px+w/2,r*sin(angles(2))*px-h/2-delta,im);
%Run script
run('v.m');

        end
    end    
end


