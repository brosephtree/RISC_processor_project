`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Joseph Nguyen
// Create Date: 02/03/2020 07:53:43 PM
// 
// Module Name: cpu_eu
// 
// Description: The Central Processing Unit Execution Unit is where data processing
// takes place.  Data is sent into the Integer Datapath for calculations, and jump
// instructions are processed in this module.
// 
// 
//////////////////////////////////////////////////////////////////////////////////


module cpu_eu(
    input clock,
    input reset,
    input ir_ld,
    input pc_inc,
    input pc_ld,
    input pc_sel,
    input reg_we,
    input adr_sel,
    input s_sel,
    
    input [2:0] w_adr,
    input [2:0] r_adr,
    input [2:0] s_adr,
    input [3:0] alu_op,
    
    input [15:0] D_in,
    
    output [15:0] IR,
    output [2:0] alu_status,
    output [15:0] address,
    output [15:0] D_out
    );
 
//----------------------------------------------------
//-----------------------IR REG-----------------------
//----------------------------------------------------
    
    ir_reg v1(
        .clock(clock),
        .reset(reset),
        .ir_ld(ir_ld),
        .D_in(D_in),
        .IR(IR)
        );
//----------------------------------------------------
//--------------------INT DATAPATH--------------------
//----------------------------------------------------
    wire [15:0] reg_out, alu_out;
    assign D_out = alu_out;
    assign alu_status = {n,z,c};
    int_datapath v2(
        .clock(clock),
        .reset(reset),
        .we(reg_we),
        .r_adr(r_adr),
        .s_adr(s_adr),
        .w_adr(w_adr),
        .alu_op(alu_op),
        .s_sel(s_sel),
        .ds(D_in),
        .n(n),
        .z(z),
        .c(c),
        .reg_out(reg_out),
        .alu_out(alu_out)
        );   
//----------------------------------------------------
//-----------------------PC REG-----------------------
//----------------------------------------------------
    wire [15:0] pc_data, PC;
    assign pc_data = pc_sel ? alu_out : (PC + {{8{IR[7]}},IR[7:0]});
    pc_reg v3(
        .clock(clock),
        .reset(reset),
        .pc_inc(pc_inc),
        .pc_ld(pc_ld),
        .alu_out(pc_data),
        .PC(PC)
        );
//----------------------------------------------------
//----------------------ADR MUX-----------------------
//----------------------------------------------------
    assign address = adr_sel ? reg_out : PC;
    
endmodule
