`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Joseph Nguyen
// Create Date: 03/14/2020 03:09:48 PM
//
// Module Name: risc_processor_top_level
// 
// Description: Top level of RISC processor project.
// 
// 
//////////////////////////////////////////////////////////////////////////////////


module risc_processor_top_level(clock,reset,step_mem_btn,step_clk_btn,display_sel,dump_mem,an,cat,led);

//----------------------------------------------------
//----------------------IO PORTS----------------------
//----------------------------------------------------
    input clock,reset;
    input step_mem_btn,step_clk_btn;            //buttons
    input display_sel,dump_mem;                 //switches

    output [3:0] an;
    output [6:0] cat;
    output [7:0] led;

//----------------------------------------------------
//--------------------DEBOUNCE/PED--------------------
//----------------------------------------------------
    deb_ped u0(
        .clock(clock),
        .reset(reset),
        .step_mem_btn(step_mem_btn),
        .step_clk_btn(step_clk_btn),
        .step_mem_ped(step_mem),
        .step_clk_ped(step_clk)
        );
        
//----------------------------------------------------
//-------------------------CU-------------------------
//----------------------------------------------------
    wire [15:0] IR;
    wire [2:0] alu_status, w_adr, r_adr, s_adr;
    wire [3:0] alu_op;
    Control_Unit u1(
        .clk(step_clk),
        .reset(reset),
        .IR(IR),
        .N(alu_status[2]),
        .Z(alu_status[1]),
        .C(alu_status[0]),
        .W_Adr(w_adr),
        .R_Adr(r_adr),
        .S_Adr(s_adr),
        .adr_sel(adr_sel),
        .s_sel(s_sel),
        .pc_ld(pc_ld),
        .pc_inc(pc_inc),
        .pc_sel(pc_sel),
        .ir_ld(ir_ld),
        .mw_en(mem_we),
        .rw_en(reg_we),
        .alu_op(alu_op),
        .status(led)
        );

        
//----------------------------------------------------
//-----------------------CPU EU-----------------------
//----------------------------------------------------
    wire [15:0] address, d_in, d_out;
    cpu_eu u2(
        .clock(step_clk),
        .reset(reset),
        .ir_ld(ir_ld),
        .pc_inc(pc_inc),
        .pc_ld(pc_ld),
        .pc_sel(pc_sel),
        .reg_we(reg_we),
        .adr_sel(adr_sel),
        .s_sel(s_sel),
        .w_adr(w_adr),
        .r_adr(r_adr),
        .s_adr(s_adr),
        .alu_op(alu_op),
        .D_in(d_out),
        .IR(IR),
        .alu_status(alu_status),
        .address(address),
        .D_out(d_in)
        );
    
//----------------------------------------------------
//-----------------------MEMORY-----------------------
//----------------------------------------------------
    reg [15:0] mem_ctr;
    always @ (posedge clock)
        begin
            if (reset)
                mem_ctr <= 0;
            else if (step_mem)
                mem_ctr = mem_ctr + 1;
            else
                mem_ctr <= mem_ctr;
        end
    wire [15:0] madr;
    assign madr = dump_mem ? mem_ctr : address;
    
    blk_mem_gen_0 u3(
        .clka(clock),
        .wea(mem_we),
        .addra(madr[7:0]),
        .dina(d_in),
        .douta(d_out)
        );
    
//----------------------------------------------------
//-------------------7SGMNT DISPLAY-------------------
//----------------------------------------------------
    sseg_display u4(
        .clock(clock),
        .reset(reset),
        .display_sel(display_sel),
        .display_0(d_out),
        .display_1(madr),
        .anode(an),
        .cathode(cat)
        );

endmodule
