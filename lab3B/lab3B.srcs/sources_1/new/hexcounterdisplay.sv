`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/31/2020 02:48:25 PM
// Design Name: 
// Module Name: hexcounterdisplay
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


module hexcounterdisplay(
    input wire clock,
    output wire [7:0] digitselect,
    output wire [7:0] segments
    );
    
    wire [3:0] value;
    
    assign digitselect = ~(8'b0000_0001);
    
    counter1second c1c(clock, value);
    hexto7seg hx(value, segments);    
    
endmodule
