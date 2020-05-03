//////////////////////////////////////////////////////////////////////////////////
//
// Montek Singh
// 1/31/2020
//
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps
`default_nettype none
`include "display640x480.vh"

module vgadisplaydriver #(
   parameter NumSpr = 4,                   // Number of sprites to encode in Screen Memory
   parameter SABits = 12,                  // Number of bits for screen_address
   parameter NumLoc = 1200,                // Number of locations in Screen Memory
   parameter NumCol = 40,                  //Number of columns in 2D array
   parameter NumRow = 30,                  //Number of rows in 2D array
   parameter bmem_size = 1024,             //Number of locations in Bitmap Memory
   parameter RGBSize = 12,                 //Size of RGB value in bits 
   parameter bmem_init = "bitmap_memory.mem"    // Name of file with initial values
)(
    input wire clk,
    input wire [3:0] charcode,   
    output wire [11:0] screen_addr,
    output wire [3:0] red, green, blue,
    output wire hsync, vsync
    );
   //Former outputs
  // wire [3:0] red, green, blue;
   
   
   wire [`xbits-1:0] x;
   wire [`ybits-1:0] y;
   wire activevideo;

   vgatimer myvgatimer(clk, hsync, vsync, activevideo, x, y);   
  
   wire [$clog2(NumCol)-1:0] col;
   wire [$clog2(NumRow)-1:0] row;
   
   assign col = x >> 4;
   assign row = y >> 4;
   
   assign screen_addr = (row << 5) + (row << 3) + col;   
   
   wire [3:0] x_offset, y_offset;
   assign x_offset = x[3:0];
   assign y_offset = y[3:0];
   
   wire [$clog2(bmem_size)-1:0] bitmap_addr;
   assign bitmap_addr = {charcode, y_offset, x_offset};
   
   wire [11:0] bmem_color;   
   rom_module #(bmem_size, RGBSize, bmem_init) bitmap_mem (bitmap_addr, bmem_color);
   
   assign red   = (activevideo == 1) ? bmem_color[11:8] : 4'b0;  //if activevideo is on, put some color, otherwise paint black on screen
   assign green = (activevideo == 1) ? bmem_color[7:4] : 4'b0;
   assign blue  = (activevideo == 1) ? bmem_color[3:0] : 4'b0;

endmodule
