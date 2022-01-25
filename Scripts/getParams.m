function [params] = getParams(scale)
%Get parameters of a scale by its name
%Read from ini file

readKeys = {scale,'script','string','',
    scale,'script','count','i',
    scale,'script','levels','',
    scale,'script','shorts','i',
    scale,'script','labels','',
    scale,'script','options','i'};
readSet = inifile(strcat('scales.ini'),'read',readKeys);

%If record 'Mode' exists
if ~isempty(readSet{2})     
    count=readSet{2};
    levels=regexp(readSet{3}, ' ', 'split');
    shorts=readSet{4};
    label=readSet{5};
    options=readSet{6};    
    labels=regexp(label, ';', 'split');    
    countl=size(labels,2); %Count of labels
    labs=cell(countl,3);
    for j=1:1:countl
        labs{j,1}=labels{j};
        labs{j,2}=options(j,1);
        labs{j,3}=options(j,2);
    end  
end    
params={readSet{2};readSet{3};readSet{4};readSet{5};readSet{6}};
end

