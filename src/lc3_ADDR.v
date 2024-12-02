module lc3_ADDR (input [15:0] IR, 
                    input [1:0] ADDR2MUX, 
                    input [15:0] SR1OUT, 
                    input ADDR1MUX, 
                    input [15:0] PC,
                    output [15:0] addr_sel_out);

    reg [15:0] ADDR2MUX_out;
    reg [15:0] ADDR1MUX_out;

    always @(*) begin
        case (ADDR2MUX)
            2'b00 : ADDR2MUX_out <= {16{1'b0}};
            2'b01 : ADDR2MUX_out <= {{10{IR[5]}}, IR[5:0]};
            2'b10 : ADDR2MUX_out <= {{7{IR[8]}}, IR[8:0]};
            2'b11 : ADDR2MUX_out <= {{5{IR[10]}}, IR[10:0]};
            default: ADDR2MUX_out <= {16{1'b0}};
        endcase
    end

    always @(*) begin
        case (ADDR1MUX)
            1'b0 : ADDR1MUX_out <= PC;
            1'b1 : ADDR1MUX_out <= SR1OUT;
            default: ADDR1MUX_out <= PC;
        endcase
    end

    assign addr_sel_out = ADDR1MUX_out + ADDR2MUX_out;


endmodule