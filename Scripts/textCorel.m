function textCorel(x,y,txt,varargin )
%Вставка текста в CorelDraw
%x,y - координаты точек

global commands;

height = 0; %Высота по умолчанию
k1=4.796; %Коэффициент увеличения шрифта
%k1=4.85; %Коэффициент увеличения шрифта
for i=1:1:nargin-3
    if strcmp(varargin{i},'FontName')        
        commands{end+1,1} = strcat('drawer.Font = ''',varargin{i+1},''';');
    end
    if strcmp(varargin{i},'FontSize')           
        %commands{end+1,1} = strcat('drawer.FontSize = ',num2str(varargin{i+1}*10/2.137),';');        
        commands{end+1,1} = strcat('drawer.FontSize = ',num2str(varargin{i+1}),';');
        height = varargin{i+1}/k1*1.33;
    end    
        if strcmp(varargin{i},'Color')          
        commands{end+1,1} = strcat ('color = application.CreateCMYKColor(',num2str(varargin{i+1}(1)),',',...
            num2str(varargin{i+1}(2)),',',num2str(varargin{i+1}(3)),',',num2str(varargin{i+1}(4)),');');
        commands{end+1,1} = 'drawer.Color = color;';
end
end

%corelDraw = CLOutput.CorelDraw(false);
%corelDraw.createDocument();
%drawer = CLOutput.Drawer(corelDraw);
%[width,height] = drawer.getTextSize(txt);
%disp(width); disp(height);
%corelDraw.closeDocument();

%commands{end+1,1}=strcat('[width,height] = drawer.getTextSize(''',txt,''');');
%width =10; height = 5;

for i=1:1:nargin-3        
    if strcmp(varargin{i},'VerticalAlignment')        
        switch varargin{i+1}
            case 'baseline'
                y = y;
            case 'middle'
                y = y-height/2;    
            case 'bottom'
                y = y+height*0.2;
            case 'top'
                y = y-height;
        end        
    end  
    
    if strcmp(varargin{i},'HorizontalAlignment')        
        switch varargin{i+1}
            case 'left'
                commands{end+1,1} = strcat('drawer.SAlignment = ''Left'';');
            case 'center'
                commands{end+1,1} = strcat('drawer.SAlignment = ''Center'';');
            case 'right'
                commands{end+1,1} = strcat('drawer.SAlignment = ''Right'';');
        end        
    end
end

commands{end+1,1} =strcat('drawer.text(''',txt,''',',num2str(x),',',num2str(y),');');
end

