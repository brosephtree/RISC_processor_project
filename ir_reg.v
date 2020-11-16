`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Joseph Nguyen
// Create Date: 02/05/2020 05:07:01 PM
// 
// Module Name: ir_reg
// 
// Description: The Instruction Register saves the instructions given by the RAM.
// 
// 
//////////////////////////////////////////////////////////////////////////////////


module ir_reg(
    input clock,
    input reset,
    input ir_ld,
    input [15:0] D_in,
    output [15:0] IR
    );
    
    reg [15:0] data;
    
    always @ (posedge clock, posedge reset)
        begin
        if (reset)
            data <= 16'b0;
        else if (ir_ld)
            data <= D_in;
        else
            data <= data;
        end
        
    assign IR = data;
    
endmodule
