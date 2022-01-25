classdef ImFigureV
    %Draw blank image via figure and save to file
   
properties 
    WidthMm
    HeightMm   
    Ext = '-djpeg100'; 
	%Ext='-dbmp';
	Visible='off'; 
    PxInMm=1; 
    ImFig
    WidthPx
    HeightPx
    corelDraw
end
   
    methods
    function imFig = ImFigureV(widthMm,heightMm)
        imFig.WidthMm = widthMm;        
        imFig.HeightMm = heightMm;
        %Создать файл в cdr
        %imFig.corelDraw = CLOutput.CorelDraw(false);
        %imFig.corelDraw.createDocument();
        %imFig.corelDraw.setPageSize(widthMm, heightMm);        
    end  
    
    function saveToFile(imFig,imf)
        [filepath,name,ext] = fileparts(imf);        
        if strcmp(ext,'.cdr')
             imFig.corelDraw.saveDocumentAs(imf);
        end      
        if strcmp(ext,'.jpg')
            imFig.corelDraw.saveDocumentAsJPG(imf);
        end
    end 
    
    end    
end

