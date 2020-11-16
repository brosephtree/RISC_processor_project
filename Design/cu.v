`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Date: 02/05/2020
// File: Control_Unit.v
//
// A "Moore" finite state machine that implements the major cycles for fetching
// and executing instructions for a 16-bit RISC processor.
//////////////////////////////////////////////////////////////////////////////////

//********************************************************************************
module Control_Unit(clk, reset, IR, N, Z, C,      // Control Unit Inputs
                    W_Adr, R_Adr, S_Adr,          // Control Unit Outputs
                    adr_sel, s_sel,
                    pc_ld, pc_inc, pc_sel, ir_ld,
                    mw_en, rw_en, alu_op,
                    status);                      // LED Output
//********************************************************************************                    

    input        clk, reset;                    // clock and reset
    input [15:0] IR;                            // Instruction Register Input
    input        N, Z, C;                       // datapath status inputs 
               //Negative, Zero, Carry
    output [2:0] W_Adr, R_Adr, S_Adr;           // register file address outputs
    output       adr_sel, s_sel;                // Mux select outputs
    output       pc_ld, pc_inc, pc_sel, ir_ld;  // pc and ir register controls
    output       mw_en, rw_en;                  // memory write, register write
    output [3:0] alu_op;                        // alu opcode
    output [7:0] status;                        // 8 LED outputs to display current state
    
    //*******************
    // data structures
    //*******************

    // Control Word Signals
    reg [2:0] W_Adr, R_Adr, S_Adr;            
    reg       adr_sel, s_sel;                 
    reg       pc_ld, pc_inc, pc_sel, ir_ld;   
    reg       mw_en, rw_en;                   
    reg [3:0] alu_op;
    
    // LED Status/State Outputs
    reg [7:0] status;
    
    // State Registers (up to 32 states)
    reg [4:0] pstate;
    reg [4:0] nstate;
    
    // Present and Next State Flags
    reg ps_N, ps_Z, ps_C;
    reg ns_N, ns_Z, ns_C;
    
    parameter RESET=0, FETCH=1, DECODE=2,
              ADD=3, SUB=4, CMP=5, MOV=6,
              INC=7, DEC=8, SHL=9, SHR=10,
              LD=11, STO=12, LDI=13,
              JE=14, JNE=15, JC=16, JMP=17,
              HALT=18,
              ILLEGAL_OP=31;
              
   //****************************************
   // Control Unit Sequencer
   //****************************************
   
   // synchronous state register assignment
   always @(posedge clk or posedge reset)
     if (reset)
       pstate <= RESET;
     else
       pstate <= nstate;
       
   // synchronous flags register assignment
   always @(posedge clk or posedge reset)
     if (reset)
       {ps_N, ps_Z, ps_C} <= 3'b0;
     else
       {ps_N, ps_Z, ps_C} <= {ns_N, ns_Z, ns_C};
       
   // combinational logic section for both next state logic
   // and control word outputs for cpu_eu and memory
   
   always @ (*)
       case (pstate)
       
         RESET:  begin // Default Control Word Values -- LED Pattern = 1111_1111
            W_Adr   = 3'b000; R_Adr  = 3'b000; S_Adr = 3'b000;
            adr_sel = 1'b0;   s_sel  = 1'b0;
            pc_ld   = 1'b0;   pc_inc = 1'b0; pc_sel = 1'b0; ir_ld = 1'b0;
            mw_en   = 1'b0;   rw_en  = 1'b0; alu_op = 4'b0000;
            {ns_N, ns_Z, ns_C} = 3'b0;
            status = 8'hFF;
            nstate = FETCH;
         end
         
         FETCH:  begin // IR <- M[PC], PC <- PC + 1 -- LED Pattern = 1000_0000
            W_Adr   = 3'b000; R_Adr  = 3'b000; S_Adr = 3'b000;
            adr_sel = 1'b0;   s_sel  = 1'b0;
            pc_ld   = 1'b0;   pc_inc = 1'b1; pc_sel = 1'b0; ir_ld = 1'b1;
            mw_en   = 1'b0;   rw_en  = 1'b0; alu_op = 4'b0000;
            {ns_N, ns_Z, ns_C} = {ps_N, ps_Z, ps_C}; // flags remain the same
            status = 8'h80;
            nstate = DECODE;
         end
         
         DECODE:  begin // Default Control Word, NS <- case(IR[15:9]) -- LED Pattern = 1100_0000
            W_Adr   = 3'b000; R_Adr  = 3'b000; S_Adr = 3'b000;
            adr_sel = 1'b0;   s_sel  = 1'b0;
            pc_ld   = 1'b0;   pc_inc = 1'b0; pc_sel = 1'b0; ir_ld = 1'b0;
            mw_en   = 1'b0;   rw_en  = 1'b0; alu_op = 4'b0000;
            {ns_N, ns_Z, ns_C} = {ps_N, ps_Z, ps_C}; // flags remain the same
            status = 8'hC0;
            case (IR[15:9])
              7'h70:   nstate = ADD;
              7'h71:   nstate = SUB;
              7'h72:   nstate = CMP;
              7'h73:   nstate = MOV;
              7'h74:   nstate = SHL;
              7'h75:   nstate = SHR;
              7'h76:   nstate = INC;
              7'h77:   nstate = DEC;
              7'h78:   nstate = LD;
              7'h79:   nstate = STO;
              7'h7a:   nstate = LDI;
              7'h7b:   nstate = HALT;
              7'h7c:   nstate = JE;
              7'h7d:   nstate = JNE;
              7'h7e:   nstate = JC;
              7'h7f:   nstate = JMP;
              default: nstate = ILLEGAL_OP;
            endcase
         end
         
         ADD:  begin // R[IR[8:6]] <- R[IR[5:3]] + R[IR[2:0]] -- LED Pattern = {ps_N, ps_Z, ps_C, 5'b00000}
            W_Adr   = IR[8:6]; R_Adr  = IR[5:3]; S_Adr = IR[2:0];
            adr_sel = 1'b0;   s_sel  = 1'b0;
            pc_ld   = 1'b0;   pc_inc = 1'b0; pc_sel = 1'b0; ir_ld = 1'b0;
            mw_en   = 1'b0;   rw_en  = 1'b1; alu_op = 4'b0100;
            {ns_N, ns_Z, ns_C} = {N, Z, C};
            status = {ps_N, ps_Z, ps_C, 5'b00000};
            nstate = FETCH; // go back to fetch
         end
         
         SUB:  begin // R[IR[8:6]] <- R[IR[5:3]] - R[IR[2:0]] -- LED Pattern = {ps_N, ps_Z, ps_C, 5'b00001}
            W_Adr   = IR[8:6]; R_Adr  = IR[5:3]; S_Adr = IR[2:0];
            adr_sel = 1'b0;   s_sel  = 1'b0;
            pc_ld   = 1'b0;   pc_inc = 1'b0; pc_sel = 1'b0; ir_ld = 1'b0;
            mw_en   = 1'b0;   rw_en  = 1'b1; alu_op = 4'b0101;
            {ns_N, ns_Z, ns_C} = {N, Z, C};
            status = {ps_N, ps_Z, ps_C, 5'b00001};
            nstate = FETCH; // go back to fetch
         end
         
         CMP:  begin //  R[IR[5:3]] - R[IR[2:0]] -- LED Pattern = {ps_N, ps_Z, ps_C, 5'b00010}
            W_Adr   = IR[8:6]; R_Adr  = IR[5:3]; S_Adr = IR[2:0];
            adr_sel = 1'b0;   s_sel  = 1'b0;
            pc_ld   = 1'b0;   pc_inc = 1'b0; pc_sel = 1'b0; ir_ld = 1'b0;
            mw_en   = 1'b0;   rw_en  = 1'b0; alu_op = 4'b0101;
            {ns_N, ns_Z, ns_C} = {N, Z, C};
            status = {ps_N, ps_Z, ps_C, 5'b00010};
            nstate = FETCH; // go back to fetch
         end
         
         MOV:  begin // R[IR[8:6]] <- R[IR[2:0]] -- LED Pattern = {ps_N, ps_Z, ps_C, 5'b00011}
            W_Adr   = IR[8:6]; R_Adr  = IR[5:3]; S_Adr = IR[2:0];
            adr_sel = 1'b0;   s_sel  = 1'b0;
            pc_ld   = 1'b0;   pc_inc = 1'b0; pc_sel = 1'b0; ir_ld = 1'b0;
            mw_en   = 1'b0;   rw_en  = 1'b1; alu_op = 4'b0000;
            {ns_N, ns_Z, ns_C} = {N, Z, C};
            status = {ps_N, ps_Z, ps_C, 5'b00011};
            nstate = FETCH; // go back to fetch
         end
         
         SHL:  begin // R[IR[8:6]] <- R[IR[2:0]] << 1 -- LED Pattern = {ps_N, ps_Z, ps_C, 5'b00100}
            W_Adr   = IR[8:6]; R_Adr  = IR[5:3]; S_Adr = IR[2:0];
            adr_sel = 1'b0;   s_sel  = 1'b0;
            pc_ld   = 1'b0;   pc_inc = 1'b0; pc_sel = 1'b0; ir_ld = 1'b0;
            mw_en   = 1'b0;   rw_en  = 1'b1; alu_op = 4'b0111;
            {ns_N, ns_Z, ns_C} = {N, Z, C};
            status = {ps_N, ps_Z, ps_C, 5'b00100};
            nstate = FETCH; // go back to fetch
         end         
         
         SHR:  begin // R[IR[8:6]] <- R[IR[2:0]] >> 1 -- LED Pattern = {ps_N, ps_Z, ps_C, 5'b00101}
            W_Adr   = IR[8:6]; R_Adr  = IR[5:3]; S_Adr = IR[2:0];
            adr_sel = 1'b0;   s_sel  = 1'b0;
            pc_ld   = 1'b0;   pc_inc = 1'b0; pc_sel = 1'b0; ir_ld = 1'b0;
            mw_en   = 1'b0;   rw_en  = 1'b1; alu_op = 4'b0110;
            {ns_N, ns_Z, ns_C} = {N, Z, C};
            status = {ps_N, ps_Z, ps_C, 5'b00101};
            nstate = FETCH; // go back to fetch
         end
         
         INC:  begin // R[IR[8:6]] <- R[IR[2:0]] + 1 -- LED Pattern = {ps_N, ps_Z, ps_C, 5'b00110}
            W_Adr   = IR[8:6]; R_Adr  = IR[5:3]; S_Adr = IR[2:0];
            adr_sel = 1'b0;   s_sel  = 1'b0;
            pc_ld   = 1'b0;   pc_inc = 1'b0; pc_sel = 1'b0; ir_ld = 1'b0;
            mw_en   = 1'b0;   rw_en  = 1'b1; alu_op = 4'b0010;
            {ns_N, ns_Z, ns_C} = {N, Z, C};
            status = {ps_N, ps_Z, ps_C, 5'b00110};
            nstate = FETCH; // go back to fetch
         end
         
         DEC:  begin // R[IR[8:6]] <- R[IR[2:0]] - 1 -- LED Pattern = {ps_N, ps_Z, ps_C, 5'b00111}
            W_Adr   = IR[8:6]; R_Adr  = IR[5:3]; S_Adr = IR[2:0];
            adr_sel = 1'b0;   s_sel  = 1'b0;
            pc_ld   = 1'b0;   pc_inc = 1'b0; pc_sel = 1'b0; ir_ld = 1'b0;
            mw_en   = 1'b0;   rw_en  = 1'b1; alu_op = 4'b0011;
            {ns_N, ns_Z, ns_C} = {N, Z, C};
            status = {ps_N, ps_Z, ps_C, 5'b00111};
            nstate = FETCH; // go back to fetch
         end
         
         LD:  begin // R[IR[8:6]] <- M[ R[IR[2:0] ] -- LED Pattern = {ps_N, ps_Z, ps_C, 5'b01000}
            W_Adr   = IR[8:6]; R_Adr  = IR[2:0]; S_Adr = 3'b000;
            adr_sel = 1'b1;   s_sel  = 1'b1;
            pc_ld   = 1'b0;   pc_inc = 1'b0; pc_sel = 1'b0; ir_ld = 1'b0;
            mw_en   = 1'b0;   rw_en  = 1'b1; alu_op = 4'b0000;
            {ns_N, ns_Z, ns_C} = {N, Z, C};
            status = {ps_N, ps_Z, ps_C, 5'b01000};
            nstate = FETCH; // go back to fetch
         end
         
         STO:  begin // M[ R[IR[8:6] ] <- R[IR[2:0]] -- LED Pattern = {ps_N, ps_Z, ps_C, 5'b01001}
            W_Adr   = 3'b000; R_Adr  = IR[8:6]; S_Adr = IR[2:0];
            adr_sel = 1'b1;   s_sel  = 1'b0;
            pc_ld   = 1'b0;   pc_inc = 1'b0; pc_sel = 1'b0; ir_ld = 1'b0;
            mw_en   = 1'b1;   rw_en  = 1'b0; alu_op = 4'b0000;
            {ns_N, ns_Z, ns_C} = {N, Z, C};
            status = {ps_N, ps_Z, ps_C, 5'b01001};
            nstate = FETCH; // go back to fetch
         end
         
         LDI:  begin // R[IR[8:6]] <- M[PC], PC <- PC + 1 -- LED Pattern = {ps_N, ps_Z, ps_C, 5'b01010}
            W_Adr   = IR[8:6]; R_Adr  = IR[5:3]; S_Adr = IR[2:0];
            adr_sel = 1'b0;   s_sel  = 1'b1;
            pc_ld   = 1'b0;   pc_inc = 1'b1; pc_sel = 1'b0; ir_ld = 1'b0;
            mw_en   = 1'b0;   rw_en  = 1'b1; alu_op = 4'b0000;
            {ns_N, ns_Z, ns_C} = {N, Z, C};
            status = {ps_N, ps_Z, ps_C, 5'b01010};
            nstate = FETCH; // go back to fetch
         end
         
         JE:  begin // if (ps_Z=1) PC <- PC + se_IR[7:0] else PC <- PC -- LED Pattern = {ps_N, ps_Z, ps_C, 5'b01011}
            if (ps_Z == 1)
                begin
                W_Adr   = IR[8:6]; R_Adr  = IR[5:3]; S_Adr = IR[2:0];
                adr_sel = 1'b0;   s_sel  = 1'b0;
                pc_ld   = 1'b1;   pc_inc = 1'b0; pc_sel = 1'b0; ir_ld = 1'b0;
                mw_en   = 1'b0;   rw_en  = 1'b0; alu_op = 4'b0000;
                end
            else
                begin
                W_Adr   = IR[8:6]; R_Adr  = IR[5:3]; S_Adr = IR[2:0];
                adr_sel = 1'b0;   s_sel  = 1'b0;
                pc_ld   = 1'b0;   pc_inc = 1'b0; pc_sel = 1'b0; ir_ld = 1'b0;
                mw_en   = 1'b0;   rw_en  = 1'b0; alu_op = 4'b0000;
                end
            {ns_N, ns_Z, ns_C} = {N, Z, C};
            status = {ps_N, ps_Z, ps_C, 5'b01011};
            nstate = FETCH; // go back to fetch
         end
         
         JNE:  begin // if (ps_Z=0) PC <- PC + se_IR[7:0] else PC <- PC -- LED Pattern = {ps_N, ps_Z, ps_C, 5'b01100}
            if (ps_Z == 0)
                begin
                W_Adr   = IR[8:6]; R_Adr  = IR[5:3]; S_Adr = IR[2:0];
                adr_sel = 1'b0;   s_sel  = 1'b0;
                pc_ld   = 1'b1;   pc_inc = 1'b0; pc_sel = 1'b0; ir_ld = 1'b0;
                mw_en   = 1'b0;   rw_en  = 1'b0; alu_op = 4'b0000;
                end
            else
                begin
                W_Adr   = IR[8:6]; R_Adr  = IR[5:3]; S_Adr = IR[2:0];
                adr_sel = 1'b0;   s_sel  = 1'b0;
                pc_ld   = 1'b0;   pc_inc = 1'b0; pc_sel = 1'b0; ir_ld = 1'b0;
                mw_en   = 1'b0;   rw_en  = 1'b0; alu_op = 4'b0000;
                end
            {ns_N, ns_Z, ns_C} = {N, Z, C};
            status = {ps_N, ps_Z, ps_C, 5'b01100};
            nstate = FETCH; // go back to fetch
         end
         
         JC:  begin // if (ps_C=1) PC <- PC + se_IR[7:0] else PC <- PC -- LED Pattern = {ps_N, ps_Z, ps_C, 5'b01101}
           if (ps_C == 1)
                begin
                W_Adr   = IR[8:6]; R_Adr  = IR[5:3]; S_Adr = IR[2:0];
                adr_sel = 1'b0;   s_sel  = 1'b0;
                pc_ld   = 1'b1;   pc_inc = 1'b0; pc_sel = 1'b0; ir_ld = 1'b0;
                mw_en   = 1'b0;   rw_en  = 1'b0; alu_op = 4'b0000;
                end
            else
                begin
                W_Adr   = IR[8:6]; R_Adr  = IR[5:3]; S_Adr = IR[2:0];
                adr_sel = 1'b0;   s_sel  = 1'b0;
                pc_ld   = 1'b0;   pc_inc = 1'b0; pc_sel = 1'b0; ir_ld = 1'b0;
                mw_en   = 1'b0;   rw_en  = 1'b0; alu_op = 4'b0000;
                end
            {ns_N, ns_Z, ns_C} = {N, Z, C};
            status = {ps_N, ps_Z, ps_C, 5'b01101};
            nstate = FETCH; // go back to fetch
         end
         
         JMP:  begin // PC <- R[IR[2:0]] -- LED Pattern = {ps_N, ps_Z, ps_C, 5'b01110}
            W_Adr   = IR[8:6]; R_Adr  = IR[5:3]; S_Adr = IR[2:0];
            adr_sel = 1'b0;   s_sel  = 1'b0;
            pc_ld   = 1'b1;   pc_inc = 1'b0; pc_sel = 1'b1; ir_ld = 1'b0;
            mw_en   = 1'b0;   rw_en  = 1'b0; alu_op = 4'b0000;
            {ns_N, ns_Z, ns_C} = {N, Z, C};
            status = {ps_N, ps_Z, ps_C, 5'b01110};
            nstate = FETCH; // go back to fetch
         end
         
         HALT:  begin // Default Control Word, -- LED Pattern = {ps_N, ps_Z, ps_C, 5'b01111}
            W_Adr   = 3'b000; R_Adr  = 3'b000; S_Adr = 3'b000;
            adr_sel = 1'b0;   s_sel  = 1'b0;
            pc_ld   = 1'b0;   pc_inc = 1'b0; pc_sel = 1'b0; ir_ld = 1'b0;
            mw_en   = 1'b0;   rw_en  = 1'b0; alu_op = 4'b0000;
            {ns_N, ns_Z, ns_C} = {ps_N, ps_Z, ps_C}; // flags remain the same
            status = {ps_N, ps_Z, ps_C, 5'b01111};
            nstate = HALT; // loop here forever
         end
         
         ILLEGAL_OP:  begin // Default Control Word, -- LED Pattern = 1111_0000
            W_Adr   = 3'b000; R_Adr  = 3'b000; S_Adr = 3'b000;
            adr_sel = 1'b0;   s_sel  = 1'b0;
            pc_ld   = 1'b0;   pc_inc = 1'b0; pc_sel = 1'b0; ir_ld = 1'b0;
            mw_en   = 1'b0;   rw_en  = 1'b0; alu_op = 4'b0000;
            {ns_N, ns_Z, ns_C} = {ps_N, ps_Z, ps_C}; // flags remain the same
            status = 8'hf0;
            nstate = ILLEGAL_OP; // loop here forever
         end         
       endcase
endmodule
