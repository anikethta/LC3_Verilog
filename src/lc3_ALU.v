module lc3_ALU (input [15:0] IR, 
                input [15:0] SR1, 
                input [15:0] SR2,
                input [1:0] ALUK, 
                input GateALU, 
                output [15:0] main_bus); 

    wire [15:0] in_val;
    reg [15:0] data_out;

    assign in_val = (IR[5] == 1'b1) ? {{11{IR[4]}}, IR[4:0]} : SR2;

    always @(*) begin
        case (ALUK)
            2'b00: data_out = SR1 + in_val;
            2'b01: data_out = SR1 & in_val;
            2'b10: data_out = ~SR1;
            2'b11: data_out = SR1;
            default: data_out = SR1 + in_val;
        endcase
    end

    assign main_bus = (GateALU == 1'b1) ? data_out : {16{1'bZ}};

endmodule