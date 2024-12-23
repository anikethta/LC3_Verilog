`timescale 1ns/1ns
`include "lc3_Datapath.v"

module lc3_tb();
    reg clk;
    reg rst;

    lc3_Datapath DUT(clk, rst);

    always begin
        #5;
        clk <= ~clk;
    end

    initial begin
        $dumpvars(0, DUT);
        clk = 1'b0;
        rst = 1'b0;
        #10;
        rst = 1'b1;
    end

endmodule

