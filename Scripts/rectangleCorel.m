function rectangleCorel(varargin )
%Рисует прямоугольник в CorelDraw

global commands;

for i=1:1:nargin
    if strcmp(varargin{i},'LineWidth')
        commands{end+1,1} = strcat('drawer.LineWidth = ',num2str(varargin{i+1}),';');        
    end
    if strcmp(varargin{i},'Position')          
        x = varargin{i+1}(1);
        y = varargin{i+1}(2);
        width = varargin{i+1}(3);
        height = varargin{i+1}(4);
    end    
end

commands{end+1,1} = strcat('drawer.line(',num2str(x),',', num2str(y),',', num2str(x+width),',', num2str(y),');');
commands{end+1,1} = strcat('drawer.line(',num2str(x+width),',', num2str(y),',', num2str(x+width),',', num2str(y+height),');');
commands{end+1,1} = strcat('drawer.line(',num2str(x+width),',', num2str(y),',', num2str(x+width),',', num2str(y+height),');');
commands{end+1,1} = strcat('drawer.line(',num2str(x+width),',', num2str(y+height),',', num2str(x),',', num2str(y+height),');');
commands{end+1,1} = strcat('drawer.line(',num2str(x),',', num2str(y+height),',', num2str(x),',', num2str(y),');');
end

