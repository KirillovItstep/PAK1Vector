function setColor(color)
%Задать текущий цвет в CorelDraw

global commands;

commands{end+1,1} = strcat ('color = application.CreateCMYKColor(',num2str(color(1)),',',...
            num2str(color(2)),',',num2str(color(3)),',',num2str(color(4)),');');
        commands{end+1,1} = 'drawer.Color = color;';
end

