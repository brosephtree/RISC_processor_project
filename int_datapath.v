`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Joseph Nguyen
// Create Date: 02/04/2020 07:22:21 PM
// 
// Module Name: int_datapath
// 
// Description: The Integer Datapath is where computation takes place.  It feeds the
// outputs of the Register File into the ALU based on the instructions sent by the 
// Control Unit and outputs the resulting computation.
// 
// 
//////////////////////////////////////////////////////////////////////////////////


module int_datapath(
    input clock,
    input reset,
    input we,
    input [2:0] r_adr,
    input [2:0] s_adr,
    input [2:0] w_adr,
    input [3:0] alu_op,
    input s_sel,
    input [15:0] ds,
    output n,
    output z,
    output c,
    output [15:0] reg_out,
    output [15:0] alu_out
    );
    


//----------------------------------------------------
//---------------------REG16 FILES--------------------
//----------------------------------------------------
    wire [15:0] s_v0;
    regfile w1(
        .clock(clock),
        .reset(reset),
        .r_adr(r_adr),
        .s_adr(s_adr),
        .w_adr(w_adr),
        .w(alu_out),
        .we(we),
        .r_bin(reg_out),
        .s_bin(s_v0)
        );
    
//----------------------------------------------------
//------------------------S MUX-----------------------
//----------------------------------------------------
    wire [15:0] s_v1;
    mux16 s_mux(
        .sel(s_sel),
        .choice_0(s_v0),
        .choice_1(ds),
        .final(s_v1)
        );

//----------------------------------------------------
//-------------------------ALU------------------------
//----------------------------------------------------
    alu w2(
        .r(reg_out),
        .s(s_v1),
        .alu_op(alu_op),
        .y(alu_out),
        .n(n),
        .z(z),
        .c(c)
        );



    
    
endmodule
