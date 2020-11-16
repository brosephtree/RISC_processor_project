`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Joseph Nguyen
// Create Date: 02/05/2020 04:55:55 PM
// 
// Module Name: reg16
// 
// Description: A 16 bit register with inputs to control two independent outputs.
// 
// 
//////////////////////////////////////////////////////////////////////////////////


module reg16(
    input clock,
    input reset,
    input oe_a,
    input oe_b,
    input load,
    input [15:0] d_in,
    output [15:0] d_a,
    output [15:0] d_b
    );
    
    reg [15:0] data;
    
    always @ (posedge clock, posedge reset)
        begin
        if (reset)
            data <= 16'b0;
        else if (load)
            data <= d_in;
        else
            data <= data;
        end
    
    assign d_a = oe_a ? data : 16'b0;
    assign d_b = oe_b ? data : 16'b0;
    
endmodule
