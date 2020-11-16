`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Joseph Nguyen
// Create Date: 03/15/2020 10:47:31 AM
// 
// Module Name: deb_ped
// 
// Description: This module feeds the two button input signals through a debouncer and
// PED.
// 
// 
//////////////////////////////////////////////////////////////////////////////////


module deb_ped(clock,reset,step_mem_btn,step_clk_btn,step_mem_ped,step_clk_ped);

//----------------------------------------------------
//----------------------IO PORTS----------------------
//----------------------------------------------------
    input clock,reset;
    input step_mem_btn,step_clk_btn;

    output step_mem_ped,step_clk_ped;
    
//----------------------------------------------------
//----------------------DEBOUNCE----------------------
//----------------------------------------------------
    debounce d0(
        .clock(clock),
        .reset(reset),
        .button(step_mem_btn),
        .deb_sig(step_mem_deb)
        );
    debounce d1(
        .clock(clock),
        .reset(reset),
        .button(step_clk_btn),
        .deb_sig(step_clk_deb)
        );
//----------------------------------------------------
//------------------------PED-------------------------
//----------------------------------------------------
    PED p0(
        .clock(clock),
        .reset(reset),
        .deb_sig(step_mem_deb),
        .ped_sig(step_mem_ped)
        );
    PED p1(
        .clock(clock),
        .reset(reset),
        .deb_sig(step_clk_deb),
        .ped_sig(step_clk_ped)
        );

endmodule
