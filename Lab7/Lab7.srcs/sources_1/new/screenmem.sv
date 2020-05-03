`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/26/2020 11:48:36 AM
// Design Name: 
// Module Name: screenmem
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


module screenmem #(
   parameter Nloc = 16,                      // Number of memory locations
   parameter Dbits = 4,                      // Number of bits in data
   parameter initfile = "screen_memory.mem"          // Name of file with initial values
)(
   input wire [$clog2(Nloc)-1 : 0] addr,     // Address for specifying memory location
                                             //   num of bits in addr is ceiling(log2(number of locations))
   output wire [Dbits-1 : 0] dout            // Data read from memory (asynchronously, i.e., continuously)
   );

   logic [Dbits-1 : 0] mem [Nloc-1 : 0];     // The actual storage where data resides
   initial $readmemh(initfile, mem, 0, Nloc-1); // Initialize memory contents from a file

   assign dout = mem[addr]; 
    
endmodule
