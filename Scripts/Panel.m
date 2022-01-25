classdef Panel<handle
    
    properties
        MaxCount=10;
        Count=0;
        List
        hp
    end
    
    methods
        function obj = Panel(hFigure)
            obj.List = zeros(1,obj.MaxCount);
            obj.hp = uipanel('Parent',hFigure,'FontSize',12,...
             'BackgroundColor','white',...
             'Position',[.58 1-0.5-0.01 0.4 0.5]);            
         end

        function addMessage(obj,message,color)            
            if obj.Count>obj.MaxCount-1                 
            deleteMessage(obj,1);
            end
            obj.Count=obj.Count+1;
            y=1-(obj.Count)*0.1;
            Caption=[blanks(1) message blanks(150)];
            but1 = uicontrol('Parent',obj.hp,'Style', 'pushbutton','String',Caption,'FontSize',14,...
              'Units','normalized','Position',[.0 y 1. .1],'BackgroundColor',color,'Callback',{@obj.bclick});            
            obj.List(obj.Count)=but1;
        end

        function bclick(obj,hObject, eventdata)            
            y=get(hObject,'Position');
            Index=uint32((1-y(2))*10);
            obj.deleteMessage(Index);
        end

        function deleteMessage(obj,Index)            
            delete(obj.List(Index));
            obj.List(Index)=[];
            obj.Count=obj.Count-1;
            %Index,Count
            for i=Index:obj.Count    
                yn=1-double(i)*0.1;    
                set(obj.List(i),'Position',[.0 yn 1. .1]);
            end            
        end    
    
    end
end

