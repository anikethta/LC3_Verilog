module lc3_cc(input clk, input rst, input LDBEN, input [15:0] IR, input [15:0] main_bus, input LDCC, output reg BEN);
    reg N;
    reg Z;
    reg P;

    always @(posedge clk) begin
        if (rst == 1'b0) begin
            N <= 1'b0;
            Z <= 1'b0;
            P <= 1'b0;
            BEN <= 1'b0;
        end
        if (LDBEN == 1'b1) begin
            BEN <= (IR[11] && N) || (IR[10] && Z) || (IR[9] && P);
        end
    end

    always @(posedge clk) begin
        if (LDCC == 1'b1) begin
            N <= main_bus[15];
            Z <= (main_bus == {16{1'b0}});
            P <= (~main_bus[15]) && (main_bus != {16{1'b0}});
        end
    end

endmodule