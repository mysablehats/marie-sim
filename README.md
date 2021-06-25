# marie-sim

This simulator was made to automate and speed up the execution of code for the MARIE assembly. Written in MATLAB, MARIE's machine is simulated (it doesnt generate x86 assembly code or produce a binary).

This simulator was based on the JRE implementation of MARIE assembly and it tries to mimic it's behaviour to the fullest. This implementation is meant to be used for bulk execution/ marking and provides poor debugging capabilities. For autoring, we recommend using the JRE version ([https://mariejs.xyz/] is nice, but we noticed some differences with the machine code generated and also mariejs has some overflow detections and some nice error detection that should be a part of the difficulty of coding in ASM). 

For a cheat sheet on MARIE'S instructions see [http://hwmath.com/dev/MarieSim/Marie-Instruction-Set-Cheat-Sheet.pdf]. 

For more details on MARIE's RTL implementation see: [https://github.com/MARIE-js/MARIE.js/wiki/Register-Transfer-Language]

## Usage

1. Open MATLAB.

2. Open the file marieloop.m and change the variable 'inputs' to the input you want. 

The inputs vector should be a sequence of decimals. Each time the MARIE assembly code encounters an INPUT instruction, the next decimal number will be provided and the input counter updated. 

3. Run marieloop.m and choose the .mas file you want to execute. 

The program will be compiled and if succeeded it will run with the inputs provided. 

Both the input and the outputs are presented on the screen as they are read, in HEX, DEC exactly after an OUTPUT or INPUT instruction is found on the code, and after each program execution, the output is presented as ASCII characters. 

## Debugging

To use the debug feature, it is necessary to set the debug property to true in line 22 of marie_sim. We recommend also setting a break point in one of the lines of the debug output to get a nice stepping function. You can also set breakpoints by changing the breakpoint variable (line 29 of marie_sim) to a vector of all the parts you want to print/stop at. 

## Longer execution cycles

You may want to also increase the amount of cycles MATLAB runs the program (for larger calculations). This can be done by setting `Prog.debug.maxnumiterations` to the amount you want. Larger values are not recommended as MATLAB itself simulating MARIE is not very fast. 


## Known issues

- STOREI and LOADI were not implemented yet. It should be some couple lines of code, trying to use those features will get the compiler to fail. 

- The JRE simulator is quite permissive/ smart about some things that our implementation is not, for instance commenting. We accept only '/', '\' and '%' currently as comment delimiters. You might need to change the commenting on the loaded file to guarantee that the code will run correctly. 

- Some registers were not implemented verbatim such as MBR and MAR. This should not alter the program`s execution or simulation in any way.

- Also JRE MARIE allows labels that are not declared to be referenced. Our implementation does not. Actually this is a nifty feature and by using this, one may halt the machine in an abnormal state (and thus get a nice error escaping mechanism). However on our simulator, such attempt will fail to compile. 
