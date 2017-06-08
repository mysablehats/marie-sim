function plagiarismcheck()
%%% run the compiler for all assignments
%aXX = countopcodes(Prog);
%AA = [a01 ... aXX ... a87]

AA = [];
labels = [];
for i = 1:100
    if exist(['a' num2str(i) '.mat'], 'file')
        aXX = load(['a' num2str(i) '.mat']);
        AA = cat(2, AA, aXX.(['a' num2str(i)]));
        labels = [labels i];
    end
end        

AAA = AA + 0.1*rand(size(AA)); % otherwise identical submissions will be condensed too closely
DD = pdist(AAA');
ZZ = linkage(DD);
dendrogram(ZZ,0, 'Orientation','left', 'Labels', num2str(labels(:)))

%examine close ones by hand