`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Joseph Nguyen
// Create Date: 02/07/2020 05:48:15 PM
// 
// Module Name: PED
// 
// Description: The positive edge detector (PED) asserts a signal for a single clock
// cycle at the rising edge of the input.
// 
// 
//////////////////////////////////////////////////////////////////////////////////


module PED(
    input clock,
    input reset,
    input deb_sig,
    output ped_sig
    );
    
    reg sig_delay;
    
    always @ (posedge clock, posedge reset)
        begin
        if (reset) sig_delay <= 1'b0;
        else sig_delay <= deb_sig;
        end
      
    assign ped_sig = deb_sig & ~sig_delay;
    
endmodule
