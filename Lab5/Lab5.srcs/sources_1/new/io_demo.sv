//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/12/2020 01:26:47 PM
// Design Name: 
// Module Name: io_demo
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

module io_demo(
    input wire clock, //100MHz clock
    
    //Sound
    output wire audPWM,
    output wire audEn,
    
    //Accel
    output wire aclSCK,
    output wire aclMOSI,
    input wire aclMISO,
    output wire aclSS,
    
    //Display
    output wire [7:0] segments,
    output wire [7:0] digitselect,
    
    output wire [15:0] LED,
    
    //Keyboard
    input wire ps2_data,
	input wire ps2_clk
   ); 

	wire [31:0] keyb_char;
 
	keyboard keyb(clock, ps2_clk, ps2_data, keyb_char);
   
	display8digit disp(keyb_char, clock, segments, digitselect);
	
	wire [3:0] note_to_play;
	wire [31:0] notes_periods[0:8] = {382219, 340530, 303370, 286344, 255102, 227273, 202478, 191113, 0};
	
	assign note_to_play [3:0] =  (  			
					   keyb_char == 32'h1C ? 4'b0000  
				     : keyb_char == 32'h1B ? 4'b0001
				     : keyb_char == 32'h23 ? 4'b0010
				     : keyb_char == 32'h1D ? 4'b0011
				     : keyb_char == 32'h3B ? 4'b0100
				     : keyb_char == 32'h42 ? 4'b0101
				     : keyb_char == 32'h4B ? 4'b0110
				     : keyb_char == 32'h43 ? 4'b0111
				     : 4'b1000
				     );	 
	
	wire [31:0] period = notes_periods[note_to_play];
	assign audEn = 1;    
				     
    montek_sound_Nexys4 snd(
       clock,             // 100 MHz clock
       period,          // sound period in tens of nanoseconds
                        // period = 1 means 10 ns (i.e., 100 MHz)      
       audPWM); 
       
    //Accelerometer data
    wire [8:0] accelX, accelY;      // The accelX and accelY values are 9-bit values, ranging from 9'h 000 to 9'h 1FF
    wire [11:0] accelTmp;           // 12-bit value for temperature
    
    accelerometer accel(clock, aclSCK, aclMOSI, aclMISO, aclSS, accelX, accelY, accelTmp);
    
    assign LED[15:0] =  (
        (accelY >= 12'h000 && accelY <= 12'h01F) ? 16'b0000000000000001
      : (accelY > 12'h01F && accelY <= 12'h03F) ? 16'b0000000000000010
      : (accelY > 12'h03F && accelY <= 12'h05F) ? 16'b0000000000000100
      : (accelY > 12'h05F && accelY <= 12'h07F) ? 16'b0000000000001000
      : (accelY > 12'h07F && accelY <= 12'h09F) ? 16'b0000000000010000
      : (accelY > 12'h09F && accelY <= 12'h0BF) ? 16'b0000000000100000
      : (accelY > 12'h0BF && accelY <= 12'h0DF) ? 16'b0000000001000000
      : (accelY > 12'h0DF && accelY <= 12'h0FF) ? 16'b0000000010000000
      : (accelY > 12'h0FF && accelY <= 12'h11F) ? 16'b0000000100000000
      : (accelY > 12'h11F && accelY <= 12'h13F) ? 16'b0000001000000000
      : (accelY > 12'h13F && accelY <= 12'h15F) ? 16'b0000010000000000
      : (accelY > 12'h15F && accelY <= 12'h17F) ? 16'b0000100000000000
      : (accelY > 12'h17F && accelY <= 12'h19F) ? 16'b0001000000000000
      : (accelY > 12'h19F && accelY <= 12'h1BF) ? 16'b0010000000000000
      : (accelY > 12'h1BF && accelY <= 12'h1DF) ? 16'b0100000000000000
      : (accelY > 12'h1DF && accelY <= 12'h1FF) ? 16'b1000000000000000
      : 16'b1111111111111111
    );
    
endmodule
