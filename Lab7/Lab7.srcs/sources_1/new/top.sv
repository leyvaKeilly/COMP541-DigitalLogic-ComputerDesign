`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/26/2020 11:43:54 AM
// Design Name: 
// Module Name: top
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


module top #(
    parameter NumSpr = 4,                   // Number of sprites to encode in Screen Memory
    parameter SABits = 12,                  // Number of bits for screen_address
    parameter NumLoc = 1200                 // Number of locations in Screen Memory
)(
    input wire clock,   
    output wire [3:0] red, green, blue,
    output wire hsync, vsync
    );
    
    wire [$clog2(NumSpr)-1:0] char_code;
    wire [SABits - 1:0] screen_addr;
    
    vgadisplaydriver vga(clock, char_code, red, green, blue, hsync, vsync, screen_addr);    
    screenmem #(NumLoc, $clog2(NumSpr)) smem(screen_addr, char_code);
  
endmodule
