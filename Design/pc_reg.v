`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Joseph Nguyen
// Create Date: 02/05/2020 05:07:17 PM
// 
// Module Name: pc_reg
// 
// Description: The Position Counter register contains the position of the
// instruction being used by the RISC processor.
// 
// 
//////////////////////////////////////////////////////////////////////////////////


module pc_reg(
    input clock,
    input reset,
    input pc_inc,
    input pc_ld,
    input [15:0] alu_out,
    output [15:0] PC
    );
    
    reg [15:0] data;
    
    always @ (posedge clock, posedge reset)
        begin
        if (reset)
            data <= 16'b0;
        else if (pc_inc)
            data <= data + 1;
        else if (pc_ld)
            data <= alu_out;
        else
            data <= data;
        end
        
    assign PC = data;
    
endmodule
