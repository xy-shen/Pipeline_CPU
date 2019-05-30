`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/23 17:03:12
// Design Name: 
// Module Name: MEM
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


module MEM(
    input clk,
    input MemRead_mem,MemWrite_mem,BEQ_mem,BNE_mem,alu_zero_mem,
    input [31:0] alu_res_mem,RtData_mem,reg_data_wb,
    input [7:0] DDURaddr,
    output branch_or_pc_mem,
    output [31:0] Dout_mem,DDUMdata
    );
    wire [7:0] WriteAddr;
    assign WriteAddr = alu_res_mem[9:2];
    assign branch_or_pc_mem = BEQ_mem&alu_zero_mem | BNE_mem&~alu_zero_mem;
    
    dist_mem_gen_1 DataRAM(.clk(clk),
        .we(~MemRead_mem & MemWrite_mem),
        .a(WriteAddr),.d(RtData_mem),.spo(Dout_mem),
        .dpra(DDURaddr),.dpo(DDUMdata));
        
endmodule