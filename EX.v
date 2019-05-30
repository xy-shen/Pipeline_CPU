`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/23 16:59:48
// Design Name: 
// Module Name: EX
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


module EX(
    input clk,
    input [1:0] ForwardA,ForwardB,
    input [31:0] next_pc_ex,
    input [2:0] ALUCode_ex,
    input ALUSrcB_ex,RegDst_ex,
    input [31:0] Imm_ex,RsData_ex,RtData_ex,alu_res_mem,reg_data_wb,
    input [4:0] RtAddr_ex,RdAddr_ex,
    output [31:0] Branch_addr_ex,Jump_addr_ex,
    output alu_zero_ex,
    output [31:0] alu_res_ex,
    output reg [4:0] RegWriteAddr_ex
    );
    //branch address
    adder_32bits adder_branch_ex(.a(next_pc_ex),.b(Imm_ex<<2),.c(Branch_addr_ex));
    adder_32bits adder_jump_ex(.a(next_pc_ex-4),.b(Imm_ex<<2),.c(Jump_addr_ex));
    //ALUSrc
    reg [31:0] alu_A,alu_B;
    always @ (*)
    begin
        case (ForwardA)
            2'b00:alu_A=RsData_ex;
            2'b01:alu_A=reg_data_wb;
            2'b10:alu_A=alu_res_mem;
        endcase
        case (ForwardB)
            2'b00:alu_B=(ALUSrcB_ex? Imm_ex:RtData_ex);
            2'b01:alu_B=reg_data_wb;
            2'b10:alu_B=alu_res_mem;
        endcase
    end
    //ALU
    ALU ALU(.ALUctrl(ALUCode_ex),.a(alu_A),.b(alu_B),.ALUresult(alu_res_ex),.Zero(alu_zero_ex));
    //RegDst
    always @ (*)
    begin
        case(RegDst_ex)
            1'b0:RegWriteAddr_ex<=RtAddr_ex;//rt
            1'b1:RegWriteAddr_ex<=RdAddr_ex;//rd
        endcase
    end
endmodule