`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Joseph Nguyen
// Create Date: 02/05/2020 04:53:10 PM
// 
// Module Name: alu
// 
// Description: Arithmetic Logic Unit with 13 possible logical computations on 2 
// 16-bit inputs.  Outputs a single 16-bit output along with negative, zero, and 
// carry flags.
// 
// 
//////////////////////////////////////////////////////////////////////////////////


module alu(r, s, alu_op, y, c, n, z);
    input[15:0] r, s;
    input[3:0] alu_op;
    output [15:0] y;
    output n, z, c;
    
    reg [15:0] y;
    reg n, z, c;
    
    always @(r or s or alu_op)
        begin
        case (alu_op)
            4'b0000: {c, y} = {1'b0, s};        //pass s
            4'b0001: {c, y} = {1'b0, r};        //pass r
            4'b0010: {c, y} = s + 1;            //increment s
            4'b0011: {c, y} = s - 1;            //decrement s
            4'b0100: {c, y} = r + s;            //add
            4'b0101: {c, y} = r - s;            //subtract
            4'b0110: begin                      //right shift s (logic)
                        c = s[0];
                        y = s >> 1;
                     end
            4'b0111: begin                      //left shift s (logic)
                        c = s[15];
                        y = s << 1;
                     end
            4'b1000: {c, y} = {1'b0, r & s};    //logic and
            4'b1001: {c, y} = {1'b0, r | s};    //logic or
            4'b1010: {c, y} = {1'b0, r ^ s};    //logic xor
            4'b1011: {c, y} = {1'b0, ~s};       //logic not s (1's comp)
            4'b1100: {c, y} = 0 - s;            //negate s (2's comp)
            default: {c, y} = {1'b0, s};        //pass s for default
        endcase
        
        //handle last 2 status flags
        n = y[15];
        if (y == 16'b0)     z = 1'b1;
        else                z = 1'b0;
        end
endmodule
