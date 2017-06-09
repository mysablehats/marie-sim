function inin = constructinput(vect, pick)
%pick = {1; [2 3]; 4};
fact = {0 1 2 3 4 5 6 7 8 -1 -6 256};
mult = {...
    [0 0]
    [2 2]
    [4 5]
    [-2 3]
    [7 -3]
    [-6 -2]
    [32767 2]
    [-32767 2]
    };
trig = {0 1 2 3 6 255 256 -1 -6}; 

inin = cell(length(fact)+length(mult)+length(trig),1);

for i = 1:length(trig)
    avect = vect;
    avect(pick{1}) = trig{i};
    inin{i} = avect;    
end

for i = 1:length(mult)
    avect = vect;
    avect(pick{2}) = mult{i};
    inin{length(trig)+i} = avect;    
end

for i = 1:length(fact)
    avect = vect;
    avect(pick{3}) = fact{i};
    inin{length(trig)+length(mult)+i} = avect;    
end
% 
% for i = 1:length(fact)
%     avect = vect;
%     avect(1) = fact{i};
%     inin{i} = avect;    
% end
% 
% for i = 1:length(mult)
%     avect = vect;
%     avect([2 3]) = mult{i};
%     inin{length(fact)+i} = avect;    
% end
% 
% for i = 1:length(trig)
%     avect = vect;
%     avect(4) = trig{i};
%     inin{length(fact)+length(mult)+i} = avect;    
% end