module lc3_RegFile (input [15:0] IR, 
                    input LDREG,
                    input clk, 
                    input rst,
                    input [1:0] DRMUX, 
                    input [1:0] SR1MUX, 
                    input [15:0] main_bus, 
                    output reg [15:0] SR1OUT, 
                    output [15:0] SR2OUT);

    reg [2:0] DRMUX_out;
    reg [15:0] R [7:0];

    always @(*) begin
        case (DRMUX)
            2'b00 : DRMUX_out <= {IR[11:9]};
            2'b01 : DRMUX_out <= 3'b111;
            2'b10 : DRMUX_out <= 3'b110;
            default : DRMUX_out <= {IR[11:9]}; // Shouldn't happen?
        endcase
    end

    always @(*) begin
        case (SR1MUX)
            2'b00 : SR1OUT <= R[IR[11:9]];
            2'b01 : SR1OUT <= R[IR[8:6]];
            2'b10 : SR1OUT <= R[3'b110];
            default : SR1OUT <= R[IR[11:9]]; // Shouldn't happen?
        endcase
    end

    assign SR2OUT = R[IR[2:0]];

    always @(posedge clk) begin
        if (rst == 1'b0) begin
            R[0] = 16'h0000;
            R[1] = 16'h0000;
            R[2] = 16'h0000;
            R[3] = 16'h0000;
            R[4] = 16'h0000;
            R[5] = 16'h0000;
            R[6] = 16'h0000;
        end

        else if (LDREG == 1'b1) begin
            R[DRMUX_out] = main_bus;
        end
    end

endmodule