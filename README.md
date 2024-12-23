# LC-3 Implementation in Verilog

## This is a WIP, currently working on:
    - Implementing INT functionality
    - Priority
    - Updating microcode

## To run with Verilator,
    - cd src
    - verilator --binary -j 0 lc3_tb.v

A test program (test.asm) has already been compiled into the RAM, but to run custom programs, you need to compile your LC-3 .asm code into a .hex file, and load it manually into lc3_memory.v with:
``` $readmemh("../run/[fname].hex", Memory); ```

For compilation, use lc3tools. 

