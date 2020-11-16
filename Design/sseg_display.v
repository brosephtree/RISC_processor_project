`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Joseph Nguyen
// Create Date: 02/05/2020 06:04:29 PM
// 
// Module Name: sseg_display
// 
// Description: The 7-Segment Display module takes a 4-digit (16-bit) hexadecimal
// number and displays it on a 4-digit 7-segment display by outputting the correct 
// anode and cathode signals.
// 
// 
//////////////////////////////////////////////////////////////////////////////////


module sseg_display(
    input clock,
    input reset,
    input display_sel,
    input [15:0] display_0,
    input [15:0] display_1,
    output [3:0] anode,
    output [6:0] cathode
    );
    
//----------------------------------------------------
//---------------------DSPLAY MUX---------------------
//----------------------------------------------------
    wire [15:0] display_raw;
    mux16 display_mux(
        .sel(display_sel),
        .choice_0(display_0),
        .choice_1(display_1),
        .final(display_raw)
        );
//----------------------------------------------------
//-------------------NUM TO DISPLAY-------------------
//----------------------------------------------------
    wire [27:0] display;
    num_to_display v1(
        .display_raw(display_raw),
        .display(display)
        );

//----------------------------------------------------
//-----------------DISPLAY COORDINATR-----------------
//----------------------------------------------------
    an_cat_coord v2(
        .clock(clock),
        .reset(reset),
        .display(display),
        .an(anode),
        .cat(cathode)
        );
    
endmodule
