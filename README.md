# LC-3 Implementation in Verilog

## This is a WIP, currently working on:
    - Implementing INT functionality
    - Priority
    - Updating microcode

## To run, 
    - ``` cd src ```
    - ``` iverilog -o [fname].vvp lc3_tb.v ```
    - ``` vvp [fname].vvp ```

A test program (test.asm) has already been compiled into the RAM, but to run custom programs, you need to compile your LC-3 .asm code into a .hex file, and load it manually into lc3_memory.v with:
``` $readmemh("../run/[fname].hex", Memory); ```

For compilation, use lc3tools. 

