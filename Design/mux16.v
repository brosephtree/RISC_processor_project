`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Joseph Nguyen
// Create Date: 02/05/2020 05:55:54 PM
// 
// Module Name: mux16
// 
// Description: A multiplexer that selects between two 16-bit inputs.
// 
// 
//////////////////////////////////////////////////////////////////////////////////


module mux16(
    input sel,
    input [15:0] choice_0,
    input [15:0] choice_1,
    output [15:0] final
    );
    

    assign final = sel ? choice_1 : choice_0;
    
endmodule
