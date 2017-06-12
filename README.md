# marie-sim
marie simulator

This simulator was made to automate and speed up the execution of code for the MARIE assembly. Written in MATLAB, MARIE's machine is simulated (it doesnt generate x86 assembly code).

This simulator was based on the JRE implementation of MARIE assembly and it tries to mimic it's behaviour to the fullest. This implementation is meant to be used for bulk execution/ marking and provides poor debugging capabilities. For autoring, we recommend using the JRE version ([https://mariejs.xyz/] is nice, but we noticed some differences with the machine code generated and also mariejs has some overflow detections and some nice error detection that should be a part of the difficulty of coding in ASM). 

For a cheat sheet on MARIE'S instructions see [http://hwmath.com/dev/MarieSim/Marie-Instruction-Set-Cheat-Sheet.pdf]. 

For more details on MARIE's RTL implementation see: [https://github.com/MARIE-js/MARIE.js/wiki/Register-Transfer-Language]

## Usage

Open marieloop.m and change the variable 'inputs'. 

The inputs vector should be a sequence of decimals. Each time the MARIE assembly code encounters an INPUT instruction, the next decimal number will be provided and the input counter updated. 

The outputs are presented on the screen as HEX, DEC exactly after an OUTPUT instruction is found on the code, and after each program execution, as ASCII characters. 




## Known issues

- STOREI and LOADI were not implemented yet. It should be some couple lines of code, trying to use those features will get the compiler to fail. 

- The JRE simulator is quite permissive/ smart about some things that our implementation is not, for instance commenting. We accept only '/', '\' and '%' currently as comment delimiters. You might need to change the commenting on the loaded file to guarantee that the code will run correctly. 

- Some registers were not implemented verbatim such as MBR and MAR. This should not alter the program`s execution or simulation in any way.

- Also JRE MARIE allows labels that are not declared to be referenced. Our implementation does not. Actually this is a nifty feature and by using this, one may halt the machine in an abnormal state (and thus get a nice error escaping mechanism). However on our simulator, such attempt will fail to compile. 
