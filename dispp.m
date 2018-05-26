function dispp(what,howmuch,numop)
%fprintf([what ':\tDEC:\t\t%d\tHEX:\t%s\n'], howmuch, dec2hextc(howmuch,4))
str = sprintf([what ':\tHEX:\t\t%s\tDEC:\t%05d\tNOP:\t%d\n'], dec2hextc(howmuch,4), howmuch,numop);
fprintf(str)
persistent h t 
if isempty(h)
    h = findobj('Tag', 'listbox1');  
    if ~isempty(h)
        h.String = '';
    end
end
if isempty(t)
    t = findobj('Tag', 'text2');
    if ~isempty(t)
        t.String = ' ';
    end
end

if ~isempty(h)
    text = h.String;
    h.String = [text;{str}];
    %disp(hello)
end
if ~isempty(t)
    text = reshape(t.String,1,[]);
    if howmuch>4 %%% will not try to print weird characters,,, see if that works
        if strcmp(what, 'Input ')
            text = [text 10]; %% newline
        end
        t.String = [text howmuch];
    end
    %disp(hello)
end