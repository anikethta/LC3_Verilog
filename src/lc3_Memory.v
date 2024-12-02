module lc3_Memory( input GateMDR,
                input LD_MDR,
                input MIO_EN,
                input LD_MAR, 
                input RW, 
                input clk,
                output reg R, 
                inout [15:0] main_bus
                );

    reg [15:0] Memory [0:65535]; // 2^16 memory addresses, 16 bit addressability
    reg [15:0] MAR;
    reg [15:0] MDR;
    reg [15:0] current_out;

    initial begin
       $readmemh("../run/lc3os.hex", Memory);
       $readmemh("../run/test.hex", Memory);
    end

    always @(posedge clk) begin
        if (MIO_EN == 1'b1) begin
            if (RW == 1'b1) begin
                Memory[MAR] <= MDR;
            end 
            else begin
                MDR <= Memory[MAR];
            end

            R <= 1'b1;
        end

        else begin
            R <= 1'b0;
        end

        current_out <= (RW == 1'b1) ? {16{1'bz}} : MDR; // High-Z whilst writing
    end

    always @(posedge clk) begin
        if (LD_MAR == 1'b1) begin
            MAR <= main_bus;
        end
        if (LD_MDR == 1'b1) begin
            MDR <= (MIO_EN == 1'b1) ? current_out : main_bus;
        end
    end

    assign main_bus = (GateMDR == 1'b1) ? MDR : {16{1'bz}};

endmodule