function plagiarismcheck()
%%% run the compiler for all assignments
%aXX = countopcodes(Prog);
%AA = [a01 ... aXX ... a87]

AA = [];
labels = [];
for i = 1:100
    aname = ['a' sprintf('%02d',i)];
    if exist([aname '.mat'], 'file')
        aXX = load([aname '.mat']);
        AA = cat(2, AA, aXX.(aname));
        labels = [labels i];
    else
        for j = 1:4 %%% look for subparts
            aname = ['a' sprintf('%02d',i) num2str(j)];
            if exist([aname '.mat'], 'file')
                aXX = load([aname '.mat']);
                AA = cat(2, AA, aXX.(aname));
                labels = [labels str2num([num2str(i) num2str(j)])];
            end
        end
    end
end

AAA = AA + 0.05*rand(size(AA)); % otherwise identical submissions will be condensed too closely
DD = pdist(AAA');
ZZ = linkage(DD);
%dendrogram(ZZ,0, 'Labels', num2str(labels(:)))
dendrogram(ZZ,0, 'Orientation','left', 'Labels', num2str(labels(:)))

%examine close ones by hand