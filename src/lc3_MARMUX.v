module lc3_MARMUX ( input [15:0] IR, 
                    input [15:0] ADDR, 
                    input MARMUX, 
                    input GateMARMUX, 
                    output [15:0] main_bus);

    wire [15:0] ZEXT_IR = {{8{1'b0}}, IR[7:0]}; // ZEXT
    wire [15:0] marmux_ungated;

    // Continuous Combinational Logic
    assign marmux_ungated = (MARMUX == 1'b1) ? ADDR : ZEXT_IR;
    assign main_bus = (GateMARMUX == 1'b1) ? marmux_ungated : {16{1'bz}};

endmodule