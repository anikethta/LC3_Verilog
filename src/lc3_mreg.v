`include "lc3_Memory.v"

module lc3_mreg(input GateMDR,
                input LD_MDR,
                input MIO_EN,
                input LD_MAR, 
                input RW, 
                input clk,
                output R, 
                inout [15:0] main_bus
                );

    reg [15:0] MAR;
    reg [15:0] MDR;
    wire [15:0] current_ram_val;
    lc3_memory lc3_memory_m (clk, MIO_EN, RW, MAR, MDR, current_ram_val, R);



    always @(posedge clk) begin
        if (LD_MAR == 1'b1) begin
            MAR <= main_bus;
        end
        if (LD_MDR == 1'b1) begin
            MDR <= (MIO_EN == 1'b1) ? current_ram_val : main_bus;
        end
    end

    assign main_bus = (GateMDR == 1'b1) ? current_ram_val : {16{1'bz}};
    
endmodule
