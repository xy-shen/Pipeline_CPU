`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/02 10:25:42
// Design Name: 
// Module Name: ALU
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

module IF(
    input clk,rst,
    input branch_or_pc,Jump,
    input [31:0] branch_addr,jump_addr,
    output [31:0] next_pc_if,inst_if,
    output reg [31:0] pc
    );
//PCSource
    reg [31:0] pc_in;
    always@(*)
    begin
        if (branch_or_pc)
            pc_in <= branch_addr;
        else if (Jump)
            pc_in <= jump_addr;
        else pc_in <= next_pc_if;
    end
//PC register
    always @ (posedge clk)
    begin
        if (rst) pc <= 32'b0;
        else pc <= pc_in;
    end
//count next pc
    adder_32bits adder32_bits_if(.a(pc),.b(32'b00000000000000000000000000000100),.c(next_pc_if));
//instruction rom
    dist_mem_gen_0 InstructionROM(.clk(clk),.a(pc[9:2]),.spo(inst_if),.we(0),.d(0));
endmodule