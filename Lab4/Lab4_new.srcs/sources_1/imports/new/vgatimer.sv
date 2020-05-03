`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/04/2020 05:01:23 PM
// Design Name: 
// Module Name: vgatimer
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
`include "display640x480.vh"

module vgatimer(
    input wire clk,
    output wire hsync, vsync, activevideo,
    output wire [`xbits-1:0] x,
    output wire [`ybits-1:0] y
    );
    //These lines below allow you to count every 2nd clock tick and 4th closck tick
    //This is because, depending on the display mode, we may need to count at 50 MHz or 25 MHz.
    
    logic [1:0] clk_count=0;
    always_ff @(posedge clk)
        clk_count <= clk_count + 2'b 01;
        
    wire Every2ndTick = (clk_count[0] == 1'b 1);
    wire Every4thTick = (clk_count[1:0] == 2'b 11);
    
    //This part instantiates an xy-counter using the appropiate clock tick counter
    //xycounter #(`wholeLine, `WholeFrame) xy(clk, Every2ndTick, x, y); // Count at 50 MHz
    
    xycounter #(`WholeLine, `WholeFrame) xy(clk, Every4thTick, x, y); //Count at 25 MHz
    
    //Generate the monitor sync signals
    assign hsync = ((x >= `hSyncStart) & (x <= `hSyncEnd)) ?  0 : 1;
    assign vsync = ((y >= `vSyncStart) & (y <= `vSyncEnd)) ?  0 : 1;
    assign activevideo =  ((x < `hVisible) & (y < `vVisible)) ? 1 : 0;
    
endmodule
