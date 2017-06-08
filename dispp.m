function dispp(what,howmuch)
%fprintf([what ':\tDEC:\t\t%d\tHEX:\t%s\n'], howmuch, dec2hextc(howmuch,4))
fprintf([what ':\tHEX:\t\t%s\tDEC:\t%d\n'], dec2hextc(howmuch,4), howmuch)