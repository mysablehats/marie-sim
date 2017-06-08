function opcount = countopcodes(Prog)
opcount = zeros(17,1);
for i = 1:length(Prog.prog)
    for j = 1:16
        if strcmp(Prog.prog(i).opcode(1),dec2hex(j))&& isempty(strfind(Prog.prog(i).op,'DEC'))&& isempty(strfind(Prog.prog(i).op,'HEX'))
            opcount(j) = opcount(j) +1; 
        end
    end
    if ~isempty(strfind(Prog.prog(i).op,'DEC'))||~isempty(strfind(Prog.prog(i).op,'HEX'))
        opcount(17) = opcount(17) +1;
    end
end