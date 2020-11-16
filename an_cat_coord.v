`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Joseph Nguyen
// Create Date: 02/05/2020 06:15:11 PM
// 
// Module Name: an_cat_coord
// 
// Description: The Anode Cathode Coordinator coordinates the anode and cathode
// signals to display the 4 digits 7-segment display inputs.
// 
// 
//////////////////////////////////////////////////////////////////////////////////


module an_cat_coord(
    input clock,
    input reset,
    input [27:0] display,
    output [3:0] an,
    output [6:0] cat
    );
    
//----------------------------------------------------
//--------------------CHOOSE ANODE--------------------
//----------------------------------------------------
    parameter basys_clk = 100 * 10**6;          //clock at 100 MHz
    parameter an_clk = (basys_clk / 200) - 1;   //anodes switch at 200Hz
    reg [31:0] an_counter = 0;
    reg [3:0] an_pos = 4'b0001;
    
    always @ (posedge clock, posedge reset)
        begin
        if (reset)                              //RESET BUTTON
            begin
            an_counter <= 0;
            an_pos <= 4'b0001;
            end
        else if (an_counter == an_clk)
            begin
            an_counter <= 0;
            an_pos <= {an_pos[2:0], an_pos[3]};
            end
        else an_counter <= an_counter + 1;
        end
        
    assign an = ~an_pos;
//----------------------------------------------------
//--------------------CHOOSE CATHD--------------------
//----------------------------------------------------
    reg [6:0] choice = 7'b0111111;
    
    always @ (posedge clock, posedge reset)
        begin
        if (reset) choice <= 7'b0111111;
        else
            case (an_pos)
                4'b0001 : choice <= display[6:0];
                4'b0010 : choice <= display[13:7];
                4'b0100 : choice <= display[20:14];
                4'b1000 : choice <= display[27:21];
                default : choice <= choice;
            endcase
        end
    
   
    assign cat = ~choice;
    
endmodule