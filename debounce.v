`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Joseph Nguyen
// Create Date: 02/05/2020 05:17:25 PM
// 
// Module Name: debounce
// 
// Description: The debouncer converts the bouncing waveforms of a button signal
// into a consistent on or off signal.
// 
// 
//////////////////////////////////////////////////////////////////////////////////


module debounce(
    input clock,
    input reset,
    input button,
    output deb_sig
    );
    
    parameter [31:0] basys_clk = 100 * 10**6;
    parameter [31:0] deb_clk = (basys_clk / 100) - 1;
    reg [31:0] deb_ctr = 0;
    reg [2:0] debouncer = 3'b000;
    
    always @ (posedge clock, posedge reset)
        begin
        if (reset)
            begin
            deb_ctr <= 0;
            debouncer <= 3'b000;
            end
        else if (deb_ctr == deb_clk)
            begin
            deb_ctr <= 0;
            case (debouncer)
                3'b000 : if (button == 1'b1) debouncer <= 3'b001; else debouncer <= 3'b000;
                3'b001 : if (button == 1'b1) debouncer <= 3'b011; else debouncer <= 3'b000;
                3'b011 : if (button == 1'b1) debouncer <= 3'b100; else debouncer <= 3'b000;
                3'b100 : if (button == 1'b0) debouncer <= 3'b101; else debouncer <= 3'b100;
                3'b101 : if (button == 1'b0) debouncer <= 3'b111; else debouncer <= 3'b100;
                3'b111 : if (button == 1'b0) debouncer <= 3'b000; else debouncer <= 3'b100;
                default : debouncer <= 3'b000;
            endcase
            end
        else
            deb_ctr <= deb_ctr + 1;
        end
    
    assign deb_sig = debouncer[2];
    
endmodule
