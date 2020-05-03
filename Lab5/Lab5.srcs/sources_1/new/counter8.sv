`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/31/2020 02:47:59 PM
// Design Name: 
// Module Name: counter1second
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

`timescale 1ns / 1ps
`default_nettype none

module counter8(
    input wire clock,
    output wire [31:0] value
    );
    
    logic [63:0] counter = 0;
    assign value = counter[53:22];
    
    always_ff @(posedge clock) begin
        counter <= (counter + 1);
    end    
    
endmodule
