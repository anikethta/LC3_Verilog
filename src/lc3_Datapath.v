`include "lc3_ADDR.v"
`include "lc3_ALU.v"
`include "lc3_ControlFSM.v"
`include "lc3_MARMUX.v"
`include "lc3_mreg.v"
`include "lc3_PC.v"
`include "lc3_RegFile.v"
`include "lc3_IR.v"
`include "lc3_cc.v"
`include "lc3_VECTOR.v"
`include "lc3_SP.v"


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

    // INT, PRIV, and I/O
    wire          INT;
    wire [7:0]    INTV;
    wire          ACV;
    wire          LDSavedUSP;
    wire          LDSavedSSP;
    wire          GateSP;
    wire [1:0]    SPMUX;
    wire          GateVector;
    wire          TableMUX;
    wire [1:0]    VectorMUX;
    wire          LDVector;

// verilator lint_off WIDTHTRUNC
    assign {LDBEN, LDCC, LDIR, LD_MAR, LD_MDR, LDPC, 
            LDREG, GateALU, GateMARMUX, GateMDR, GatePC, 
            MARMUX, MIO_EN, PCMUX, RW, SR1MUX, DRMUX, 
            ADDR1MUX, ADDR2MUX, ALUK} = control_signals;
// verilator lint_on WIDTHTRUNC

    assign PSR[15] = 1'b1; // running in user mode
    assign INT = 1'b0;
    assign ACV = 1'b0;
    assign GateSP = 1'b0;
    assign GateVector = 1'b0;

    lc3_ADDR lc3_ADDR_m (IR, ADDR2MUX, SR1OUT, ADDR1MUX, PC, addr_sel_out);
    lc3_ALU lc3_ALU_m (IR, SR1OUT, SR2OUT, ALUK, GateALU, main_bus);
    lc3_IR lc3_IR_m (main_bus, LDIR, clk, rst, IR);
    lc3_MARMUX lc3_MARMUX_m (IR, addr_sel_out, MARMUX, GateMARMUX, main_bus);
    lc3_mreg lc3_mreg_m (GateMDR, LD_MDR, MIO_EN, LD_MAR, RW, clk, R, main_bus);
    lc3_PC lc3_PC_m (addr_sel_out, main_bus, PC, GatePC, LDPC, PCMUX, clk, rst);
    lc3_RegFile lc3_RegFile_m (IR, LDREG, clk, rst, DRMUX, SR1MUX, main_bus, SR1OUT, SR2OUT);
    lc3_cc lc3_cc_m(clk, rst, LDBEN, IR, main_bus, LDCC, BEN, PSR);
    lc3_ControlFSM lc3_ControlFSM_m (IR, R, clk, rst, BEN, PSR, INT, ACV, main_bus, control_signals);
    lc3_SP lc3_SP_m (SR1OUT, LDSavedUSP, LDSavedSSP, GateSP, clk, SPMUX, main_bus);
    lc3_VECTOR lc3_VECTOR_m ( main_bus, GateVector, TableMUX, clk, VectorMUX, INTV, LDVector);
endmodule