module lc3_RegFile (input [15:0] IR, 
                    input LDREG,
                    input clk, 
                    input rst,
                    input [1:0] DRMUX, 
                    input [1:0] SR1MUX, 
                    input [15:0] main_bus, 
                    output reg [15:0] SR1OUT, 
                    output [15:0] SR2OUT);

    reg [2:0] DRMUX_mux;
    reg [15:0] regfile [7:0];

    always @(*) begin
        case (DRMUX)
            2'b00 : DRMUX_mux = {IR[11:9]};
            2'b01 : DRMUX_mux = 3'b111;
            2'b10 : DRMUX_mux = 3'b110;
            default : DRMUX_mux = {IR[11:9]}; // Happens on rst
        endcase
    end

    always @(*) begin
        case (SR1MUX)
            2'b00 : SR1OUT = regfile[IR[11:9]];
            2'b01 : SR1OUT = regfile[IR[8:6]];
            2'b10 : SR1OUT = regfile[3'b110];
            default : SR1OUT = regfile[IR[11:9]]; // Happens on rst
        endcase
    end

    assign SR2OUT = regfile[IR[2:0]];

    always @(posedge clk) begin
        if (rst == 1'b0) begin
            regfile[0] <= 16'h0000;
            regfile[1] <= 16'h0000;
            regfile[2] <= 16'h0000;
            regfile[3] <= 16'h0000;
            regfile[4] <= 16'h0000;
            regfile[5] <= 16'h0000;
            regfile[6] <= 16'h0000;
            regfile[7] <= 16'h0000;
        end

        else if (LDREG == 1'b1) begin
            regfile[DRMUX_mux] <= main_bus;
        end
    end
    // Testing test.asm
    always @(regfile[3]) begin
        $display("%x", regfile[3]);
    end
    

endmodule