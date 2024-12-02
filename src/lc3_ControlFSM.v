module lc3_ControlFSM ( input [15:0] IR, 
                        input R, 
                        input clk, 
                        input rst,
                        input BEN,
                        input [15:0] main_bus,
                        output [25:0] control_sgnl);
    reg [5:0] state;
    reg [0:25] control_signal_ROM [0:63];

    initial begin
        $readmemb("../microcode/microcode.bin", control_signal_ROM);
    end

// Implementing Next-State Transitions
    always @(posedge clk) begin
        if (rst == 1'b0) begin
            state <= 6'b010010;
        end
        else begin
            case (state) 
                18 : begin 
                    state <= 33; // Fetch
                end

                33 : begin
                    if (R == 1'b1) begin
                        state <= 35;
                    end else begin
                        state <= 33;
                    end
                end

                35 : begin
                    state <= 32;
                end

                32 : begin 
                    state <= {2'b00, IR[15:12]};
                end

                1 : begin 
                    state <= 18; // ADD
                end

                5 : begin 
                    state <= 18; // AND
                end

                9 : begin 
                    state <= 18; // NOT
                end

                15 : begin 
                    state <= 28; // TRAP
                end

                28 : begin
                    if (R == 1'b1) begin
                        state <= 30;
                    end else begin
                        state <= 28;
                    end
                end

                30 : begin 
                    state <= 18;
                end

                14 : begin 
                    state <= 18; // LEA
                end

                2 : begin 
                    state <= 25; // LD
                end

                25 : begin 
                    if (R == 1'b1) begin
                        state <= 27;
                    end else begin 
                        state <= 25;
                    end
                end

                27 : begin 
                    state <= 18;
                end

                6 : begin 
                    state <= 25; // LDR
                end

                10 : begin 
                    state <= 24; // LDI
                end
                
                24 : begin 
                    if (R == 1'b1) begin 
                        state <= 26;
                    end else begin
                        state <= 24;
                    end
                end

                26 : begin 
                    state <= 25;
                end

                11 : begin 
                    state <= 29; // STI
                end
                
                29 : begin 
                    if (R == 1'b1) begin 
                        state <= 31;
                    end else begin
                        state <= 29;
                    end
                end

                31 : begin 
                    state <= 23;
                end

                23 : begin 
                    state <= 16;
                end

                16 : begin 
                    if (R == 1'b1) begin 
                        state <= 18;
                    end else begin
                        state <= 16;
                    end
                end 

                7 : begin 
                    state <= 23; //  STR
                end

                3 : begin 
                    state <= 23; // ST
                end

                4 : begin // JSR
                    if (IR[11] == 1'b1) begin
                        state <= 21; 
                    end
                    else begin
                        state <= 20;
                    end
                end

                20 : begin 
                    state <= 18;
                end

                21 : begin 
                    state <= 18;
                end

                12 : begin 
                    state <= 18; // JMP
                end

                0 : begin // BR
                    if (BEN == 1'b1) begin 
                        state <= 22;
                    end
                    else if (BEN == 1'b0) begin
                        state <= 18;
                    end
                end

                22 : begin 
                    state <= 18;
                end

                // Misc States
                default : state <= 18; // Includes RTI instruction
            endcase
        end
    end

    assign control_sgnl = control_signal_ROM[state];
    
endmodule