`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/07/2020 03:43:46 PM
// Design Name: 
// Module Name: counter4digit
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module counter8digit(
     input wire clock,
     output wire [7:0] digitselect,
     output wire [7:0] segments
     );
     
     wire [31:0] value;
     counter8 c(clock, value);
     display8digit d8d(value, clock, segments, digitselect);
    
endmodule
