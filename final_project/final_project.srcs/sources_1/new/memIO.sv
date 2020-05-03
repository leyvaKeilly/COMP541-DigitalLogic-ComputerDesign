`timescale 1ns / 1ps



module memIO #(
    parameter Dbits=32,                                 // word size for the processor
    parameter Nreg=32,                                  // number of registers
    parameter smem_size=128,                            
    parameter smem_init="wherever_code_is.mem",         // correct filename inherited from parent/tester
    parameter dmem_size=64,                             // dmem size, must be >= # words in .data of program + size of stack
    parameter dmem_init="wherever_data_is.mem"      
)(
    input wire clk,
    input wire cpu_wr,
    input wire [31:0] cpu_addr,
    input wire [31:0] cpu_writedata,
    input wire [31:0] accel_val,
    input wire [31:0] keyb_char,
    input wire [10:0] vga_addr,
    
    output wire [31:0] cpu_readdata,
    output logic [31:0] lights,
    output logic [31:0] period,
    output wire [3:0] vga_readdata
    );
    wire dmem_wr, smem_wr, lights_wr, sound_wr;
    wire [31:0] dmem_readdata;
    wire [31:0] smem_readdata;   
    
    assign dmem_wr = ((cpu_wr == 1) & (cpu_addr[17:16] == 2'b01)) ? 1 : 0;
    assign smem_wr = ((cpu_wr == 1) & (cpu_addr[17:16] == 2'b10)) ? 1 : 0;
    assign sound_wr = ((cpu_wr == 1) & (cpu_addr[17:16] == 2'b11) & (cpu_addr[3:2] == 2'b10)) ? 1 : 0;
    assign lights_wr = ((cpu_wr == 1) & (cpu_addr[17:16] == 2'b11) & (cpu_addr[3:2] == 2'b11)) ? 1 : 0;
    
    assign cpu_readdata = ((cpu_addr[17:16] == 2'b11) & (cpu_addr[3:2] == 2'b01)) ? accel_val
                        : ((cpu_addr[17:16] == 2'b11) & (cpu_addr[3:2] == 2'b00)) ? keyb_char
                        : (cpu_addr[17:16] == 2'b10) ? smem_readdata
                        : (cpu_addr[17:16] == 2'b01) ? dmem_readdata
                        : 32'b0;
    
    //Lights
    always_ff @(posedge clk)
    begin
        if(lights_wr)
            lights <= cpu_writedata;
    end
    
    //Sound
    always_ff @(posedge clk)
    begin
        if(sound_wr)
            period <= cpu_writedata;
    end
    
    //Screen_mem 2-port RAM
    ram_module_2port #(.Nloc(smem_size), .Dbits(Dbits), .initfile(smem_init)) smem(clk, smem_wr, cpu_addr[31:2], cpu_writedata, vga_addr, smem_readdata, vga_readdata);  
                // dropped two LSBs from address to data mem to convert byte address to word address
    //data_mem RAM
    ram_module #(.Nloc(dmem_size), .Dbits(Dbits), .initfile(dmem_init)) dmem(clk, dmem_wr, cpu_addr[31:2], cpu_writedata, dmem_readdata);  
                // dropped two LSBs from address to data mem to convert byte address to word address
endmodule
