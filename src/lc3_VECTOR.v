module lc3_VECTOR ( inout [15:0] main_bus,
                    input GateVector,
                    input TableMUX, 
                    input clk,
                    input [1:0] VectorMUX, 
                    input [7:0] INTV, 
                    input LDVector);
    
    reg [7:0] vector;
    reg [7:0] Table_;
    reg [7:0] VectorMUX_out;
    wire [7:0] TableMUX_out;
    wire [7:0] TableMUX2_out;

    always @(*) begin
        case (VectorMUX)
            2'b00 : VectorMUX_out = INTV;
            2'b01 : VectorMUX_out = 8'h00;
            2'b10 : VectorMUX_out = 8'h01;
            2'b11 : VectorMUX_out = 8'h02;
            default : VectorMUX_out = 8'h00;
        endcase
    end

    assign TableMUX_out = (TableMUX == 1'b1) ? (VectorMUX_out) : (main_bus[7:0]);
    assign TableMUX2_out = (TableMUX == 1'b1) ? (8'h01) : (8'h00);

    always @(posedge clk) begin
        if (LDVector == 1'b1) begin
            vector <= TableMUX_out;
            Table_ <= TableMUX2_out;
        end
    end

    assign main_bus = (GateVector == 1'b1) ? {Table_, vector} : {16{1'bZ}};
endmodule