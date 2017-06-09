function Prog = load_marie_prog(fid)
%%%% this part is equivalent to the assemble procedure
debug = struct();
issues = 0;
program = struct();
program.label = [];
program.opaddress = [];

programlines = textscan(fid, '%s', 'Delimiter',{'\n','\r'}, 'CommentStyle', {'/'});
for i = 1:length(programlines{1})
    program(i).line = regexprep(programlines{1}{i}, '\t', ' '); %%%% substitutes tabs for spaces
    program(i).line = regexprep(program(i).line, '\v', ' ');
    program(i).line = upper(program(i).line);%%% convert to uppercase
    while(strfind(program(i).line,'  ')) %%% removes multiple spaces
        program(i).line = regexprep(program(i).line, '  ', ' ');
    end
end
clear programlines
%%% removes empty lines
linestoclear = [];
for i = 1:length(program)
    if isempty(program(i).line)
        linestoclear = [linestoclear i];
    end
end
program(linestoclear) = [];
clear linestoclear

for i =1:length(program)
    if ~isempty(findfirstcommentdelimiter(program(i).line))
        firstcommentdelim = findfirstcommentdelimiter(program(i).line);
        program(i).command = program(i).line(1:(firstcommentdelim)-1);
        program(i).comment = program(i).line((firstcommentdelim+1):end);
    else
        program(i).command = program(i).line;
    end
    if ~isempty(strfind(program(i).command,','))
        if ~isempty(strfind(program(i).command,', '))
            splitsplit = strsplit(program(i).command,', ');
        else
            splitsplit = strsplit(program(i).command,',');
        end
        program(i).label = splitsplit{1};
        program(i).op = splitsplit{2};
    else
        program(i).op = program(i).command;
    end
    
    program(i).commcell = strsplit(program(i).op);
    if length(program(i).commcell)>1
        program(i).operation = regexprep(program(i).commcell{1}, ' ', ''); %% in case i still have a space
        program(i).operand = regexprep(program(i).commcell{2}, ' ', '');
    else
        program(i).operation = regexprep(program(i).commcell{1}, ' ', '');
    end
end
%clear commentdelim firstcommentdelim splitsplit fid filename


%%% removes useless fields generated during parsing
%program = rmfield(program,{'line', 'op', 'command', 'commcell', 'comment'});


%%% create program's memory location

%%% first neet to check i dont have an ORG instruction
numoforgs = 0;
lineexist = zeros(1,length(program));
offsetvect = lineexist; 
for i =1:length(program)
    if strcmp(program(i).operation,'ORG')
        offsetvect(i) = hex2dec(program(i).operand);
        numoforgs = numoforgs +1; 
        if numoforgs>1||i>1
            warning('ORG instruction found! Not tested for multiple or non initil ORG instructions. Proceed with care!')
        end
        lineexist(i) = 0;
    else
        if i>1
            offsetvect(i) = offsetvect(i-1);
        else
            offesetvect(i) = 0;
        end
        lineexist(i) = 1; %%% will keep lines that are not ORG
    end
end
program = program(find(lineexist));
offsetvect = offsetvect(find(lineexist)); 

for i =1:length(program)
    program(i).memlocation = dec2hex(i-1+offsetvect(i),3);
end

%%% set up inition PC
initialPC = program(1).memlocation;


%%% actually this was not quite correct, because maybe we want to hard
%%% adress memory and do other weird things, so we should create the whole
%%% range of possible memory adresses and put zeros there as well. But this
%%% is really slow, so it wont be done. Instead, in execution time, any
%%% value we access that we don't know will be read as zero.

% for i =0:hex2dec('FFF')
%     program(i+1).memlocation = dec2hex(i,3);
%     program(i+1).opcode = '0000';
% end



%%% creates symbol table
symboltable = struct();
symboltable.symbol = [];
symboltable.memlocation = [];

numsymbols = 0;
for i =1:length(program)
    if ~isempty(program(i).label)
        numsymbols = numsymbols +1;
        symboltable(numsymbols).symbol = program(i).label;
        symboltable(numsymbols).memlocation = dec2hex(i-1+offsetvect(i),3);
    end
end

%%%substituting symbols for memory locations:
for i = 1:length(program)
    if ~isempty(program(i).operand)
        for j = 1:length(symboltable)
            if strcmp(program(i).operand,symboltable(j).symbol)
                program(i).opaddress = symboltable(j).memlocation;
            end
        end
        if isfield(program(i), 'opaddress')&&isempty(program(i).opaddress)
            try
                %%%% first try a direct assignment? or first go through the
                %%%% symboltable?? no idea how it is best.
                program(i).opaddress = dec2hex(hex2dec(program(i).operand),3);
                %should implement this warning
                %                 disp(program(i).line)
                %                 warning('Hard coded memory address.')
            catch
                error(['Assembly not successful. Cannot handle operand:' program(i).operand])
            end
            %         elseif            isempty(program(i).opaddress)
            %             disp(program(i).line)
            %             warning(['Probable invalid syntax in line:' num2str(i) '. Probable syntax abuse. Assuming ''000'' as operand!'])
            %             program(i).opaddress = '000';
        end
    end
end

%%% creating opcodes
for i = 1:length(program)
    if ~isempty(program(i).operation)
        switch program(i).operation
            case 'ADD'
                program(i).opcode = ['3' program(i).opaddress];
            case 'SUBT'
                program(i).opcode = ['4' program(i).opaddress];
            case 'ADDI'
                program(i).opcode = ['B' program(i).opaddress];
            case 'CLEAR'
                program(i).opcode = ['A' '000'];
            case 'LOAD'
                program(i).opcode = ['1' program(i).opaddress];
            case 'STORE'
                program(i).opcode = ['2' program(i).opaddress];
            case 'INPUT'
                program(i).opcode = ['5' '000'];
            case 'OUTPUT'
                program(i).opcode = ['6' '000'];
            case 'JUMP'
                program(i).opcode = ['9' program(i).opaddress];
            case 'SKIPCOND'
                if length(program(i).operand)~=3
                    issues = issues +1;
                    warning('Unusual operand for skipcond.')
                    debug.assembleproc(issues).issues = 'not optimal operand found!';
                    debug.assembleproc(issues).i = i;
                    debug.assembleproc(issues).program.operand = program(i).operand;
                    if strcmp(program(i).operand,'0')||strcmp(program(i).operand,'00')
                        program(i).operand = '000';
                    else
                        %%%damn students and their invalid but valid syntax!
                        switch length(program(i).operand)
                            case 2
                                program(i).operand = ['0' program(i).operand];
                            case 1
                                program(i).operand = ['00' program(i).operand];
                            otherwise
                                error('crashed. Wrong skipcond operand. see .debug for info')
                        end
                        %error('crashed. Wrong skipcond operand. see .debug for info')
                    end
                end
                program(i).opcode = ['8' program(i).operand];
            case 'JNS'
                program(i).opcode = ['0' program(i).opaddress];
            case 'JUMPI'
                program(i).opcode = ['C' program(i).opaddress];
            case 'STOREI'
                program(i).opcode = ['E' program(i).opaddress];
            case 'LOADI'
                program(i).opcode = ['D' program(i).opaddress];
            case 'HALT'
                program(i).opcode = ['7' '000'];
            case 'DEC'
                program(i).opcode = dec2hextc(str2double(program(i).operand),4);
            case 'HEX'
                program(i).opcode = dec2hextc(hextc2dec(program(i).operand),4);
        end
    end
end

Prog = Program();
Prog = Prog.parse(program);
Prog.debug = debug;
Prog.symboltable = symboltable;
Prog.initialPC = initialPC;
