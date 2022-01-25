classdef ImFigureDrawR < ImFigureR
    %for drawing graphical primitives
    
    properties
        LineWidth=1;
        Color=[0 0 0];
        FontName='GOST 26.008—85';
        FontSize=20;
        FontWeight='normal';
        %Options for edge
        EdgeColor=[0 0 0];
        EdgeLineWidth=2;
        Margin=5;
    end
    
    methods
        function ImFig = ImFigureDrawR(widthMm,heightMm)                
            ImFig@ImFigureR(widthMm,heightMm);
        end          

        function line(imFig,x,y)
            px=imFig.PxInMm;            
            gl=line(x*px,imFig.HeightPx-y*px);
            set(gl,'LineWidth',imFig.LineWidth,'Color',imFig.Color);
        end

        function circle(imFig,x,y,r)
            %x,y - center, r- radius
            px=imFig.PxInMm;           
            gr=rectangle('Position',[(x-r)*px,imFig.HeightPx-(y+r)*px,2*r*px,2*r*px]);
            set(gr,'Curvature',[1,1],'LineWidth',imFig.LineWidth);
        end

        function rectangle(imFig,x,y,w,h)
            %x,y is left top corner; w,h - width and height
            px=imFig.PxInMm;           
            gr=rectangle('Position',[x*px,imFig.HeightPx-y*px,w*px,h*px]);
            set(gr,'LineWidth',imFig.LineWidth);
        end
        
        function text(imFig,x,y,str)
            px=imFig.PxInMm;
            gt=text(x*px,imFig.HeightPx-y*px,str);
            %Change font
            set(gt,'FontName',imFig.FontName,'FontSize',imFig.FontSize,'FontWeight',imFig.FontWeight,'VerticalAlignment','baseline');
        end

        function textEdge(imFig,x,y,str)
            px=imFig.PxInMm;
            gc=text(x*px,imFig.HeightPx-y*px,str);
            %Change font
            set(gc,'FontName',imFig.FontName,'FontSize',imFig.FontSize,'FontWeight',imFig.FontWeight,'VerticalAlignment','baseline');
            set(gc,'EdgeColor',imFig.EdgeColor,'LineWidth',imFig.EdgeLineWidth,'Margin',imFig.Margin);
        end
        
        function insertImage(imFig,x,y,imf)
            px=imFig.PxInMm;
            rgb = imread(imf);
            image(x*px,imFig.HeightPx-y*px,rgb);
        end
        
    end
end

