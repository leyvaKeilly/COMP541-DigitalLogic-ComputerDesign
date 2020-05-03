`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/26/2020 04:42:56 PM
// Design Name: 
// Module Name: CounterMod4
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

module CounterMod7(
    input wire clock,
    input wire reset,
    output logic [2:0] value
    );
    
    always_ff @(posedge clock) begin
        value <= reset ? 0 : (value == 6) ? 0 : (value + 1);
    end
    
endmodule
