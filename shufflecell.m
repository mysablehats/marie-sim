function cel = shufflecell(celcel,idx)
cel = cell(size(celcel));
for i = 1:length(celcel)
    cela = celcel{i};
    cel{i} = [cela(idx)];
end