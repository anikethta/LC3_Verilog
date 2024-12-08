module lc3_ControlFSM ( input [15:0] IR, 
                        input R, 
                        input clk, 
                        input rst,
                        input BEN,
                        input [15:0] PSR,
                        input INT, 
                        input ACV,
                        input [15:0] main_bus,
                        output [25:0] control_sgnl);
    reg [5:0] state;
    reg [34:0] control_signal_ROM [0:63];

    initial begin
        $readmemb("../microcode/microcode.bin", control_signal_ROM);
    end

// Implementing Next-State Transitions
    always @(posedge clk) begin
        if (rst == 1'b0) begin
            state <= 18;
        end
        else begin
            if (control_signal_ROM[state][25] == 1'b0) begin
                case (control_signal_ROM[state][28:26])
                    
                    3'b001 : begin
                        state <= (control_signal_ROM[state][34:29] | {{4{1'b0}}, R, {1'b0}});
                    end

                    3'b011 : begin
                        state <= (control_signal_ROM[state][34:29] | {{5{1'b0}}, IR[11]});
                    end

                    3'b010 : begin
                        state <= (control_signal_ROM[state][34:29] | {{3{1'b0}}, BEN, {2{1'b0}}});
                    end
                    
                    3'b100 : begin
                        state <= (control_signal_ROM[state][34:29] | {{2{1'b0}}, PSR[15], {3{1'b0}}});
                    end

                    3'b101 : begin
                        state <= (control_signal_ROM[state][34:29] | {{2{1'b0}}, INT, {3{1'b0}}});
                    end

                    3'b110 : begin
                        state <= (control_signal_ROM[state][34:29] | {{2{1'b0}}, ACV, {3{1'b0}}});
                    end

                    default: state <= control_signal_ROM[state][34:29];
                endcase
            end

            else begin
                state <= {2'b00, IR[15:12]};
            end
        end
    end

    assign control_sgnl = control_signal_ROM[state][24:0];
    
endmodule