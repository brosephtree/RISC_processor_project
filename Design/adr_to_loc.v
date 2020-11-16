`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Joseph Nguyen
// Create Date: 02/05/2020 04:55:10 PM
// 
// Module Name: adr_to_loc
// 
// Description: Translates a 3-bit address into the corresponding enable signal.
// 
// 
//////////////////////////////////////////////////////////////////////////////////


module adr_to_loc(
    input [2:0] adr,
    output [7:0] loc
    );
    
    reg [7:0] location;
    
    always @ (*)
        case (adr)
            3'b000: location = 8'b00000001;
            3'b001: location = 8'b00000010;
            3'b010: location = 8'b00000100;
            3'b011: location = 8'b00001000;
            3'b100: location = 8'b00010000;
            3'b101: location = 8'b00100000;
            3'b110: location = 8'b01000000;
            3'b111: location = 8'b10000000;
            default: location = 8'b00000001;
        endcase
    
    assign loc = location;
    
endmodule
