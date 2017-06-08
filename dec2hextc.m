function hextc = dec2hextc(dec, L)
N = L*4;
hextc = dec2hex(mod((dec),2^N),N/4);
end