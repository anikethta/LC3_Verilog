module lc3_SP ( input [15:0] SR1OUT,
                input LDSavedUSP,
                input LDSavedSSP,
                input GateSP, 
                input clk,
                input [1:0] SPMUX,
                output [15:0] main_bus);

    reg [15:0] SavedUSP;
    reg [15:0] SavedSSP;

    reg [15:0] SPMUX_OUT;    

    always @(posedge clk) begin
        if (LDSavedUSP == 1'b1) begin
            SavedUSP <= SR1OUT;
        end

        if (LDSavedSSP == 1'b1) begin
            SavedSSP <= SR1OUT;
        end
    end

    always @(*) begin
        case (SPMUX)
            2'b00 : SPMUX_OUT = SavedUSP ; 
            2'b01 : SPMUX_OUT = SR1OUT + 1;
            2'b10 : SPMUX_OUT = SR1OUT - 1;
            2'b11 : SPMUX_OUT = SavedSSP ;
        endcase
    end

    assign main_bus = (GateSP == 1'b1) ? SPMUX_OUT : {16{1'bZ}};

endmodule