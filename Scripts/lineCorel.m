function lineCorel(x,y, varargin )
%Рисует линию в CorelDraw
%x,y - координаты точек

global commands;

for i=1:1:nargin-2
    if strcmp(varargin{i},'LineWidth')
        commands{end+1,1} = strcat('drawer.LineWidth = ',num2str(varargin{i+1}),';');
    end
    if strcmp(varargin{i},'Color')          
        commands{end+1,1} = strcat ('color = application.CreateCMYKColor(',num2str(varargin{i+1}(1)),',',...
            num2str(varargin{i+1}(2)),',',num2str(varargin{i+1}(3)),',',num2str(varargin{i+1}(4)),');');
        commands{end+1,1} = 'drawer.Color = color;';
    end    
end
commands{end+1,1} = strcat('drawer.line(',num2str(x(1)),',', num2str(y(1)),',',...
    num2str(x(2)),',', num2str(y(2)),');');
end

