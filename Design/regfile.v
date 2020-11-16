`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Joseph Nguyen
// Create Date: 02/05/2020 04:52:05 PM
// 
// Module Name: regfile
// 
// Description: The Register File can read and write into 8 16-bit registers.  The
// module writes into a register and outputs the contents of 2 registers
// independently.
// 
// 
//////////////////////////////////////////////////////////////////////////////////


module regfile(
    input clock,
    input reset,
    input [2:0] r_adr,
    input [2:0] s_adr,
    input [2:0] w_adr,
    input [15:0] w,
    input we,
    output [15:0] r_bin,
    output [15:0] s_bin
    );
    
//----------------------------------------------------
//-----------------ADDRESS TRANSLATOR-----------------
//----------------------------------------------------
    wire [7:0] w_loc;
    wire [7:0] r_loc;
    wire [7:0] s_loc;
    adr_to_loc w_trans(
        .adr(w_adr),
        .loc(w_loc)
        );
    adr_to_loc r_trans(
        .adr(r_adr),
        .loc(r_loc)
        );
    adr_to_loc s_trans(
        .adr(s_adr),
        .loc(s_loc)
        );


//----------------------------------------------------
//---------------------REG16 FILES--------------------
//----------------------------------------------------
    wire [15:0] a_r0;
    wire [15:0] b_r0;
    reg16 r0(
        .clock(clock),
        .reset(reset),
        .oe_a(r_loc[0]),
        .oe_b(s_loc[0]),
        .load(w_loc[0] && we),
        .d_in(w),
        .d_a(a_r0),
        .d_b(b_r0)
        );
    wire [15:0] a_r1;
    wire [15:0] b_r1;
    reg16 r1(
        .clock(clock),
        .reset(reset),
        .oe_a(r_loc[1]),
        .oe_b(s_loc[1]),
        .load(w_loc[1] && we),
        .d_in(w),
        .d_a(a_r1),
        .d_b(b_r1)
        );
    wire [15:0] a_r2;
    wire [15:0] b_r2;
    reg16 r2(
        .clock(clock),
        .reset(reset),
        .oe_a(r_loc[2]),
        .oe_b(s_loc[2]),
        .load(w_loc[2] && we),
        .d_in(w),
        .d_a(a_r2),
        .d_b(b_r2)
        );
    wire [15:0] a_r3;
    wire [15:0] b_r3;
    reg16 r3(
        .clock(clock),
        .reset(reset),
        .oe_a(r_loc[3]),
        .oe_b(s_loc[3]),
        .load(w_loc[3] && we),
        .d_in(w),
        .d_a(a_r3),
        .d_b(b_r3)
        );
    wire [15:0] a_r4;
    wire [15:0] b_r4;
    reg16 r4(
        .clock(clock),
        .reset(reset),
        .oe_a(r_loc[4]),
        .oe_b(s_loc[4]),
        .load(w_loc[4] && we),
        .d_in(w),
        .d_a(a_r4),
        .d_b(b_r4)
        );
    wire [15:0] a_r5;
    wire [15:0] b_r5;
    reg16 r5(
        .clock(clock),
        .reset(reset),
        .oe_a(r_loc[5]),
        .oe_b(s_loc[5]),
        .load(w_loc[5] && we),
        .d_in(w),
        .d_a(a_r5),
        .d_b(b_r5)
        );
    wire [15:0] a_r6;
    wire [15:0] b_r6;
    reg16 r6(
        .clock(clock),
        .reset(reset),
        .oe_a(r_loc[6]),
        .oe_b(s_loc[6]),
        .load(w_loc[6] && we),
        .d_in(w),
        .d_a(a_r6),
        .d_b(b_r6)
        );
    wire [15:0] a_r7;
    wire [15:0] b_r7;
    reg16 r7(
        .clock(clock),
        .reset(reset),
        .oe_a(r_loc[7]),
        .oe_b(s_loc[7]),
        .load(w_loc[7] && we),
        .d_in(w),
        .d_a(a_r7),
        .d_b(b_r7)
        );
    
    
    
    
//----------------------------------------------------
//----------------------CHOOSE R&S--------------------
//----------------------------------------------------
    
    assign r_bin =  (r_adr == 3'b000) ? a_r0:
                    (r_adr == 3'b001) ? a_r1:
                    (r_adr == 3'b010) ? a_r2:
                    (r_adr == 3'b011) ? a_r3:
                    (r_adr == 3'b100) ? a_r4:
                    (r_adr == 3'b101) ? a_r5:
                    (r_adr == 3'b110) ? a_r6:
                    (r_adr == 3'b111) ? a_r7:
                    16'b0;
    
    assign s_bin =  (s_adr == 3'b000) ? b_r0:
                    (s_adr == 3'b001) ? b_r1:
                    (s_adr == 3'b010) ? b_r2:
                    (s_adr == 3'b011) ? b_r3:
                    (s_adr == 3'b100) ? b_r4:
                    (s_adr == 3'b101) ? b_r5:
                    (s_adr == 3'b110) ? b_r6:
                    (s_adr == 3'b111) ? b_r7:
                    16'b0;
endmodule
