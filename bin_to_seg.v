`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Joseph Nguyen
// Create Date: 02/05/2020 06:12:10 PM
// 
// Module Name: bin_to_seg
// 
// Description: This module converts a hexadecimal number into the 7-bit word that
// displays the digit on a 7-segment display.
// 
// 
//////////////////////////////////////////////////////////////////////////////////


module bin_to_seg(
    input [3:0] bin,
    output [6:0] seg
    );
    
    parameter [6:0] cat_0 = 7'b0111111;
    parameter [6:0] cat_1 = 7'b0000110;
    parameter [6:0] cat_2 = 7'b1011011;
    parameter [6:0] cat_3 = 7'b1001111;
    parameter [6:0] cat_4 = 7'b1100110;
    parameter [6:0] cat_5 = 7'b1101101;
    parameter [6:0] cat_6 = 7'b1111101;
    parameter [6:0] cat_7 = 7'b0000111;
    parameter [6:0] cat_8 = 7'b1111111;
    parameter [6:0] cat_9 = 7'b1101111;
    parameter [6:0] cat_a = 7'b1110111;
    parameter [6:0] cat_b = 7'b1111100;
    parameter [6:0] cat_c = 7'b1011000;
    parameter [6:0] cat_d = 7'b1011110;
    parameter [6:0] cat_e = 7'b1111001;
    parameter [6:0] cat_f = 7'b1110001;
    reg [6:0] display = cat_0;
    
    always @*
       case (bin)
            4'h0 : display <= cat_0;
            4'h1 : display <= cat_1;
            4'h2 : display <= cat_2;
            4'h3 : display <= cat_3;
            4'h4 : display <= cat_4;
            4'h5 : display <= cat_5;
            4'h6 : display <= cat_6;
            4'h7 : display <= cat_7;
            4'h8 : display <= cat_8;
            4'h9 : display <= cat_9;
            4'ha : display <= cat_a;
            4'hb : display <= cat_b;
            4'hc : display <= cat_c;
            4'hd : display <= cat_d;
            4'he : display <= cat_e;
            4'hf : display <= cat_f;
            default : display <= cat_0;
        endcase
    
    assign seg = display;
endmodule