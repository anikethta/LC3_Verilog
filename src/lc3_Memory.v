module lc3_memory (input clk, input MIO_EN, input RW, input [15:0] addr, input [15:0] data_in, output reg [15:0] data_out, output reg R);
    reg [15:0] Memory [0:65535]; // 2^16 memory addresses, 16 bit addressability

    initial begin
        $readmemh("../run/lc3os.hex", Memory);
        $readmemh("../run/test.hex", Memory);
        Memory[16'hFE04] = 16'hFFFF; // Display status register, bit 15 must be set to 1 in order to simulate a character being printed to the screen
        Memory[16'hFFFE] = 16'hF000;
    end

    always @(posedge clk) begin
        if (MIO_EN == 1'b1) begin
            if (RW == 1'b1) begin
                Memory[addr] <= data_in;
            end 
            else begin
                data_out <= Memory[addr];
            end

            R <= 1'b1;
        end

        else begin
            R <= 1'b0;
        end
    end

endmodule