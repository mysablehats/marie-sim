function displayascii(output)
fprintf('ASCII:')
for i = 1:length(output)
    fprintf('%s',hex2dec(output(i)))
end
fprintf('\n')