module lc3_PC ( input [15:0] ADDR, 
                inout [15:0] main_bus, 
                output reg [15:0] PC,
                input GatePC, 
                input LDPC, 
                input [1:0] PCMUX, 
                input clk, 
                input rst );
                
    reg [15:0] PCMUX_out;

    always @(*) begin
        case (PCMUX) 
            2'b00 : PCMUX_out <= PC + 1'b1;
            2'b01 : PCMUX_out <= main_bus;
            2'b10 : PCMUX_out <= ADDR;
            default : PCMUX_out <= PC + 1'b1; // Shouldn't happen?
        endcase
    end

    always @(posedge clk) begin
        if (rst == 1'b0) begin
            PC <= 16'h0200; // OS starting addr
        end

        else if (LDPC == 1'b1) begin
            PC <= PCMUX_out;
        end
    end

    assign main_bus = (GatePC == 1'b1) ? PC : {16{1'bZ}};

endmodule