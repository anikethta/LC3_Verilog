module lc3_cc(input clk, input rst, input LDBEN, input [15:0] IR, input [15:0] main_bus, input LDCC, output reg BEN, output reg [15:0] PSR);
    
    reg N;
    reg Z;
    reg P;


    always @(posedge clk) begin
        if (rst == 1'b0) begin
            BEN <= 1'b0;

            PSR[2] = 1'b0;
            PSR[1] = 1'b0;
            PSR[0] = 1'b0;
        end
        if (LDBEN == 1'b1) begin
            BEN <= (IR[11] && PSR[2]) || (IR[10] && PSR[1]) || (IR[9] && PSR[0]);
        end
    end

    always @(posedge clk) begin
        if (LDCC == 1'b1) begin
            N <= main_bus[15];
            Z <= (main_bus == {16{1'b0}});
            P <= (~main_bus[15]) && (main_bus != {16{1'b0}});
        end
    end

    assign PSR[2:0] = {N, Z, P};

endmodule