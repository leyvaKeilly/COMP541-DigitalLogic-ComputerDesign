`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/22/2020 03:03:12 PM
// Design Name: 
// Module Name: comparator
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


module comparator #(parameter N=32)(
    input wire FlagN, FlagV, FlagC, bool0,
    output wire comparison
    );
    
    assign comparison = bool0 ? ~FlagC : FlagN ^ FlagV;
    
endmodule
