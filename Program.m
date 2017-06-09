classdef Program
    properties
        prog
        debug
        symboltable
        initialPC
%         line
%         command
%         comment
%         op
%         label
%         commcell
%         operation
%         operand
%         opcode
%         memlocation
%         opaddress
    end
    methods
        function PP = parse(PP, prog)
            %disp('hello')
            for i =1: length(prog)
                PP.prog(i).memlocation = prog(i).memlocation;
                PP.prog(i).opcode = prog(i).opcode;
                PP.prog(i).op = prog(i).line;
            end
        end        
        function [wline, index, program] = wline(program, memlocation)
            wline = [];
            index = [];
            for i =1:length(program.prog)
                try
                if program.prog(i).memlocation == memlocation
                    wline = program.prog(i).opcode;
                    index = i;
                end
                catch ME
                    %%% need to come up with a way to record this type of
                    %%% crash
                    disp(ME)
                end
            end
            if isempty(wline)||isempty(index)
                %%%maybe it is a skipcond operand
                if ~strcmp(memlocation,'000')&&~strcmp(memlocation,'400')&&~strcmp(memlocation,'800')
                    %%% they can be still out of bound operands, but i will
                    %%% squelch the warning if this was done. 
                    warning('out of bounds addressing. will create this place at the end of the program!')
                end
                %%%should I pad zeros here?
                program.prog(end+1).memlocation = memlocation;
                %%%if it was not on the code it should have zero there!
                program.prog(end).opcode = '0000';
                wline = '0000';
                index = []; %%%??? no idea
            end
        end
    end
end