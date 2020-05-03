`timescale 1ns / 1ps
`default_nettype none



module datapath #(
   parameter Nreg = 32,                      // Number of registers 
   parameter Dbits = 32                     // Number of bits in data (regs, ALU)
)(
   input wire clk,
   input wire reset,
   input wire enable,   
   input wire [31:0] instr,
   input wire [1:0] pcsel,
   input wire [1:0] wasel, 
   input wire sext,
   input wire bsel,
   input wire [1:0] wdsel, 
   input wire [4:0] alufn,
   input wire werf, 
   input wire [1:0] asel,
   input wire [31:0] mem_readdata,
   
   output  wire Z,       
   output wire [31:0] mem_addr,       //=> alu-reslt
   output wire [31:0] mem_writedata,  //=>read data 2
   output logic [31:0] pc  = 32'h00400000 
);
               
wire [4:0]  reg_writeaddr;
wire [31:0] reg_writedata, pcPlus4, newPC, BT, aluA, aluB, ReadData1, ReadData2, alu_result;

assign mem_writedata = ReadData2;
assign mem_addr = alu_result;

//WASEL multiplexer
assign reg_writeaddr = (wasel == 2'b00) ? instr[15:11]       //Rd register
                     : (wasel == 2'b01) ? instr[20:16]       //Rt register
                     : (wasel == 2'b10) ? 5'b11111           //register 31
                     : 5'b0x;   

//WDSEL multiplexer
assign reg_writedata = (wdsel == 2'b00) ? pcPlus4         
                     : (wdsel == 2'b01) ? alu_result
                     : (wdsel == 2'b10) ? mem_readdata
                     : 32'b0x;

//pc + 4
assign pcPlus4 = pc + 4;

// PCSEL multiplexer
assign newPC = (pcsel == 2'b00) ? pcPlus4                         //next instruction
             : (pcsel == 2'b01) ? BT                              //branch BEQ or BNE
             : (pcsel == 2'b10) ? {pc[31:28],instr[25:0],2'b00}      //jump J or JAL
             : (pcsel == 2'b11) ? ReadData1                       //jump JR; JT = readData1
             : 32'b0x;
 
//pc            
always_ff @(posedge clk)
    if(reset)
        pc <= 32'h00400000;
    else if (enable)
        pc <= newPC;

//Sign Extension
wire [15:0] imm = instr[15:0];
wire [31:0] signImm = (sext & imm[15]) ? ({{16{1'b1}},imm}):{{16{1'b0}},imm};

//BT adder
assign BT = pcPlus4 + (signImm << 2);       //signImmediate * 4

//ASEL multiplexer
assign aluA = (asel == 0) ? ReadData1         //Value from ReadData1
            : (asel == 1) ? instr[10:6]       //Shamt inst[10:6]
            : (asel == 2) ? 5'b10000         //LUI function -- shift by "16"
            : 32'b0x;

//BSEL multiplexer
assign aluB = bsel ? signImm : ReadData2;      //bsel == 1: immediate, otherwise ReadData2
                          
    
  register_file #(Nreg, Dbits) rf(clk, werf, instr[25:21], instr[20:16], reg_writeaddr, reg_writedata, ReadData1, ReadData2); 
    
  ALU #(Dbits) myALU(aluA, aluB, alufn, alu_result, Z); 
   
endmodule
