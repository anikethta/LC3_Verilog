`include "lc3_ADDR.v"
`include "lc3_ALU.v"
`include "lc3_ControlFSM.v"
`include "lc3_MARMUX.v"
`include "lc3_mreg.v"
`include "lc3_PC.v"
`include "lc3_RegFile.v"
`include "lc3_IR.v"
`include "lc3_cc.v"


module lc3_Datapath (input clk, input rst);
    wire          LDIR;
    wire          LDBEN;
    wire          LDCC;
    wire          BEN;
    wire          LD_MAR;
    wire          LD_MDR;
    wire          LDPC;
    wire          LDREG;
    wire          GateALU;
    wire          GateMARMUX;
    wire          GateMDR;
    wire          GatePC;
    wire          MARMUX;
    wire          MIO_EN;
    wire [15:0]   PC;
    wire [1:0]    PCMUX;
    wire          RW;
    wire [1:0]    SR1MUX;
    wire [15:0]   addr_sel_out;
    wire [15:0]   main_bus;
    wire [15:0]   SR1OUT;
    wire [15:0]   SR2OUT;
    wire [1:0]    DRMUX;
    wire [15:0]   IR;
    wire          R;
    wire          ADDR1MUX;
    wire [1:0]    ADDR2MUX;
    wire [1:0]    ALUK;
    wire [25:0]   control_signals;
    wire [15:0]   PSR;
    wire          INT;
    wire          ACV;

    assign {LDBEN, LDCC, LDIR, LD_MAR, LD_MDR, LDPC, 
            LDREG, GateALU, GateMARMUX, GateMDR, GatePC, 
            MARMUX, MIO_EN, PCMUX, RW, SR1MUX, DRMUX, 
            ADDR1MUX, ADDR2MUX, ALUK} = control_signals;
    
    assign PSR[15] = 1'b1; // running in user mode
    assign INT = 1'b0;
    assign ACV = 1'b0;

    lc3_ADDR lc3_ADDR_m (IR, ADDR2MUX, SR1OUT, ADDR1MUX, PC, addr_sel_out);
    lc3_ALU lc3_ALU_m (IR, SR1OUT, SR2OUT, ALUK, GateALU, main_bus);
    lc3_IR lc3_IR_m (main_bus, LDIR, clk, rst, IR);
    lc3_MARMUX lc3_MARMUX_m (IR, addr_sel_out, MARMUX, GateMARMUX, main_bus);
    lc3_mreg lc3_mreg_m (GateMDR, LD_MDR, MIO_EN, LD_MAR, RW, clk, R, main_bus);
    lc3_PC lc3_PC_m (addr_sel_out, main_bus, PC, GatePC, LDPC, PCMUX, clk, rst);
    lc3_RegFile lc3_RegFile_m (IR, LDREG, clk, rst, DRMUX, SR1MUX, main_bus, SR1OUT, SR2OUT);
    lc3_cc lc3_cc_m(clk, rst, LDBEN, IR, main_bus, LDCC, BEN, PSR);
    lc3_ControlFSM lc3_ControlFSM_m (IR, R, clk, rst, BEN, PSR, INT, ACV, main_bus, control_signals);
endmodule