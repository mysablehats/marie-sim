function decdec = hextc2dec(hexhex)
    unsignednum = hex2dec(hexhex);
    decdec = val2dec(unsignednum,16);
end
function value = val2dec(val,N)
%val = bin2dec(bin);
y = sign(2^(N-1)-val)*(2^(N-1)-abs(2^(N-1)-val));
if ((y == 0) && (val ~= 0))
  value = -val;
else
    value = y;
end
end