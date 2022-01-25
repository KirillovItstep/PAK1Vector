function [] = putSignal(Value)
str=strcat('V',num2str(Value,'%6.2f'));
OutputCom(str);
ValueCurr=fromCom();
while (ValueCurr~=Value)
ValueCurr=fromCom();    
end
end

