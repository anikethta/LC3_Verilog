module lc3_IR (input [15:0] main_bus, 
                input LDIR, 
                input clk,
                input rst,
                output reg [15:0] IR_out); 

    always @(posedge clk) begin
        if (rst == 1'b0) begin
            IR_out <= 16'h0000;
        end

        else if (LDIR == 1'b1) begin
            IR_out <= main_bus;
        end

        $display("main bus current %b", main_bus);
    end

endmodule