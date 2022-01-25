classdef ImFigure
    %Draw blank image via figure and save to file
   
properties 
    WidthMm
    HeightMm   
    Ext = '-djpeg100'; 
	%Ext='-dbmp';
	Visible='off'; 
    PxInMm=500/25.4; %Resolution - 500 px per inch    
    Im
    Fig
    WidthPx
    HeightPx	
end
   
    methods
    function imFig = ImFigure(widthMm,heightMm)
        imFig.WidthMm = widthMm;        
        imFig.HeightMm = heightMm;        
        imFig.WidthPx=imFig.WidthMm*imFig.PxInMm;    
        imFig.HeightPx=imFig.HeightMm*imFig.PxInMm;
        %imFig.PxInMm
        imFig.Im=zeros(round(imFig.HeightPx),round(imFig.WidthPx),'uint8');
        imFig.Im=imcomplement(imFig.Im);
        imFig.Fig=figure('Visible',imFig.Visible);         
    %Insert blank image into figure
    imshow(imFig.Im);
    axis off; 
    set(imFig.Fig,'units','points','position',[1 1 imFig.WidthPx imFig.HeightPx]) % set the screen size and position
    set(imFig.Fig,'paperunits','points','paperposition',[1 1 imFig.WidthPx imFig.HeightPx]) % set size and position for printing
    set(gca,'units','normalized','position',[0 0 1 1]) % make sure axis fills entire figure
    hold on;
    end  
    
    function saveToFile(imFig,imf)
        fig=imFig.Fig;
        ext=imFig.Ext;
        print(fig, '-r72',ext,imf);
    end 
    
    end    
end

