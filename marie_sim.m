function [output, Prog] = marie_sim(Prog, input)

%%% clear up invalid opcodes
% say we have a 7XXX halt,,, that needs to become 7000

%%% Implements the program itself
AC = dec2hex(0,4);
PC = Prog.initialPC;%dec2hex(0,3);

%%% starts output to nothing:
output.value = {};
output.counter = 0;

%%% sets debug variables:
Prog.debug.realprogramcounter = 0;
Prog.debug.maxnumiterations = 1000000;
Prog.debug.crashreason = '';
Prog.debug.ME = '';
Prog.debug.PC = PC;
Prog.debug.AC = AC;
Prog.debug.operation = '';
Prog.debug.debug = false; 
Prog.debug.acoverflow = 0;
Prog.debug.pcoverflow = 0;
Prog.debug.errors.overflow = false;
Prog.debug.errors.underflow = false;
Prog.debug.halt = -1;
Prog.debug.zeroProgramCounterEachNewInput = true; %%% Needed so as to check a particular program! Remember to set to false!!!
breakpoint = []; %lines on which you want the program to halt


%%% main program loop:

while(Prog.debug.maxnumiterations>Prog.debug.realprogramcounter) %% ~strcmp(Prog.wline(PC),'7000')&&
    Prog.debug.realprogramcounter = Prog.debug.realprogramcounter +1;
    try
    [operation, li] = Prog.wline(PC);
    wop = operation(1);
    X = operation(2:4);
    [wline, idx, Prog] = Prog.wline(X); %%%% this adds lines to the program for out of index accessed memory locations. necessary since technically you can also write on them. this might break everything since the program will change size in an unpredictable way!
      PC = dec2hextc(hextc2dec(PC)+1,3);%dec2hex(hex2dec(PC)+1,3);
    if Prog.debug.debug||any(li == breakpoint)
        disp(['wOP:' wop ' X:' X '       ' 'AC: ' AC ' PC:' PC ' line:' num2str(li) '              '  Prog.prog(li).op ])
        %disp(['AC: ' AC ' PC:' PC ' line:' num2str(li)] )
    end
    
    switch wop
        case '0' %%JnS            
%             %disp(Prog.prog(li).op)
%             disp(['AC: ' AC ' PC:' PC ' line:' num2str(li)] )
             Prog.prog(idx).opcode(2:4) = PC; 
%             %lol
%             %PC = dec2hextc(hextc2dec(operand)+1,3); %%% i dont need to add
%             %one because PC will be incremented afterwards!
%             %actually this uses ac for this calculation, so i should do
%             %that too
            AC = dec2hextc(hextc2dec(X)+1,4);            
            PC = AC(2:4);       
        case '1' %% load X into AC
            AC = wline;
        case '2' %% stores AC in address X
            Prog.prog(idx).opcode = AC;
        case '3'
            acval = hextc2dec(AC);
            opval = hextc2dec(wline);
            sumsum = acval + opval;
            AC = dec2hextc(sumsum,4);
            %AC = dec2hextc(hextc2dec(AC) + hextc2dec(wline),4);
            %%% here there should be an overflow check
            ovcheck = hextc2dec(AC);
            if acval> ovcheck
                Prog.debug.errors.overflow = true;
            end
        case '4'
            acval = hextc2dec(AC);
            opval = hextc2dec(wline);
            difdif = acval - opval;
            AC = dec2hextc(difdif,4);
            %AC = dec2hextc(hextc2dec(AC) - hextc2dec(wline),4);
            %%% here there should be an underflow check
            uncheck = hextc2dec(AC);
            if acval<uncheck
                Prog.debug.errors.underflow = true;
            end
        case '5'
            if Prog.debug.zeroProgramCounterEachNewInput
                Prog.debug.realprogramcounter = 0; %%% will do this so that i can check a particular program
            end
            try
                dispp('Input ', input.input(input.counter),Prog.debug.realprogramcounter)
                AC = dec2hextc(input.input(input.counter),4);
            catch
                Prog.debug.crashreason = 'Ran out of inputs!';
                break
            end
            input.counter = input.counter + 1;
        case '6'
            %disp(tc(AC,16))
            output.counter = output.counter + 1;
            output.value{output.counter} = AC;
            dispp('Output',hextc2dec(AC),Prog.debug.realprogramcounter)
        case '7'
            Prog.debug.halt = 0;
            break
        case '8'
            binoperand = dec2bin(str2num(X(1)),4); %only the first part is important
            binop = binoperand(1:2);
            switch binop
                case '10'%'800'
                    if hextc2dec(AC)>0
                        PC = dec2hextc(hextc2dec(PC)+1,3);
                    end
                case '01'%'400'
                    if hextc2dec(AC)==0
                        PC = dec2hextc(hextc2dec(PC)+1,3);
                    end
                case '00'%'000'
                    if hextc2dec(AC)<0
                        PC = dec2hextc(hextc2dec(PC)+1,3);
                    end
            end
        case '9' %%jump
            %PC = operand;         
            PC = X; %%% according to rtl definitions this is what should happen. idk            
        case 'A'
            AC = '0000'; %dec2hex(0,4);    
        case 'B'
            AC = dec2hextc(hextc2dec(AC) + hextc2dec(Prog.prog(idx).opcode),4);
            %%% here there should be an overflow check
        case 'C' %%jumpi
            ooop = wline;
            PC = ooop(2:4); %%%????? or 1:3? must read specifications to be sure
        case 'D'
            error('LoadI not implemented!')
        case 'E'
            error('StoreI not implemented!')
        otherwise
            disp(['not implemented: ' operation])            
    end    
     % PC = dec2hextc(hextc2dec(PC)+1,3);%dec2hex(hex2dec(PC)+1,3);

  
    if hex2dec(PC)>16^3-1
        %disp('PC overflow!')
        Prog.debug.pcoverflow = Prog.debug.pcoverflow +1;
        PC = PC(end-2:end);
    end
    if hextc2dec(AC)>16^4
        %disp('AC overflow!')
        Prog.debug.acoverflow = Prog.debug.acoverflow +1;
        AC = AC(end-3:end);
    end
    catch ME
        Prog.debug.crashreason = 'Unknown crash.';
        Prog.debug.ME = ME;
        Prog.debug.PC = PC;
        Prog.debug.AC = AC;
        Prog.debug.operation = operation;
        for iii = 1:length(ME.stack)
            disp(ME.stack(iii))
        end
        disp(['PC:' PC])
        disp(['AC:' AC])
        disp(['operation:' operation])
        break
    end
end
%%%% setting up debugging variables
if Prog.debug.maxnumiterations<=Prog.debug.realprogramcounter
    Prog.debug.crashreason = 'Max num of operations reached';
end
if  Prog.debug.halt~=0
    disp(['Programm ended with an error:' Prog.debug.crashreason])
else
    disp('Program ended sucessfully.')
end
disp('=============================================================')