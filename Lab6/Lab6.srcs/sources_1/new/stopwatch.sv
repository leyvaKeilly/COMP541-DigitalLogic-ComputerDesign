
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/19/2020 04:36:39 PM
// Design Name: 
// Module Name: stopwatch
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

module stopwatch(
    input wire clock,
    input wire BTNC, BTNU, BTND,
    output wire [7:0] digitselect,
    output wire [7:0] segments
    );
    
    wire cleanCenter, cleanUp, cleanDown;  
    debouncer #(20) dCentral(BTNC, clock, cleanCenter);
    debouncer #(20) dUp(BTNU, clock, cleanUp);
    debouncer #(20) dDown(BTND, clock, cleanDown); 
    
    wire countUp, paused;    
    fsm_Keilly (clock, cleanUp, cleanDown, cleanCenter, countUp, paused);
    
    wire [31:0] value;    
    updowncounter updowncount(clock, countUp, paused, value);
    
    display8digit d8d(value, clock, segments, digitselect);
    
    
endmodule
