`timescale 1ns/1ns
`include "lc3_Datapath.v"

module lc3_tb();
    reg clk;
    reg rst;

    lc3_Datapath DUT(clk, rst);

    always begin
        #5;
        clk <= 0;
        #5;
        clk <= 1;
    end

    initial begin
        $dumpvars(0, DUT);
        rst <= 1'b0;
        #20;
        rst <= 1'b1;
        #1000;
        $finish();
    end

endmodule

