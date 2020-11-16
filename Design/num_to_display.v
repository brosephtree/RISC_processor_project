`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Joseph Nguyen
// Create Date: 02/05/2020 06:11:52 PM
// 
// Module Name: num_to_display
// 
// Description: This module converts a 4-digit (16-bit) hexadecimal number into
// a 28-bit bus of 4 7-bit words that display the corresponding digits on a 
// 7-segment display.
// 
// 
//////////////////////////////////////////////////////////////////////////////////


module num_to_display(
    input [15:0] display_raw,
    output [27:0] display
    );
    
    bin_to_seg d0(
        .bin(display_raw[3:0]),
        .seg(display[6:0])
        );
    bin_to_seg d1(
        .bin(display_raw[7:4]),
        .seg(display[13:7])
        );
    bin_to_seg d2(
        .bin(display_raw[11:8]),
        .seg(display[20:14])
        );
    bin_to_seg d3(
        .bin(display_raw[15:12]),
        .seg(display[27:21])
        );
    
    
endmodule
