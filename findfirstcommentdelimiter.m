function fcd = findfirstcommentdelimiter(line)
dc = [];
commentdelimiters = {'/', ';', '\'};
for i = 1:length(commentdelimiters)
    thisfdc = strfind(line,commentdelimiters{i});
    if ~isempty(thisfdc)
        dc = [dc thisfdc];
    end   
end
     fcd = min(dc);        
end