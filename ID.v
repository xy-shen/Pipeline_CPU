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


module ID(
    input clk,rst,
    input[31:0] inst_id,//instruction from IF
    //from WB
    input RegWrite_wb,
    input [4:0] RegWriteAddr_wb,DDURaddr,
    input [31:0] RegWriteData_wb,
    //outputs
    output RegWrite_id,RegDst_id,MemRead_id,MemWrite_id,ALUSrcB_id,MemtoReg_id,Jump_id,BEQ_id,BNE_id,
    output [2:0] ALUCode_id,
    output [31:0] Imm_id,RsData_id,RtData_id,DDUdata,
    output [4:0] RsAddr_id,RtAddr_id,RdAddr_id//rs,rt,rd
    );

    assign RsAddr_id = inst_id[25:21];//rs
    assign RtAddr_id = inst_id[20:16];//rt
    assign RdAddr_id = inst_id[15:11];//rd
    assign Imm_id = {{16{1'b0}},inst_id[15:0]};//sign extend

    Control_Unit CtrlUnit(.inst(inst_id),.RegWrite(RegWrite_id),.RegDst(RegDst_id),
    .MemRead(MemRead_id),.MemWrite(MemWrite_id),.Jump(Jump_id),.BEQ(BEQ_id),.BNE(BNE_id),
    .ALUCode(ALUCode_id),.ALUSrc_B(ALUSrcB_id),.MemtoReg(MemtoReg_id));

    RegisterFiles RegisterFiles(
    .clk(clk),.L_S(RegWrite_wb),.R_addr_A(RsAddr_id),
    .R_addr_B(RtAddr_id),.Wt_addr(RegWriteAddr_wb),.wt_data(RegWriteData_wb),.DDURaddr(DDURaddr),
    //outputs
    .rdata_A(RsData_id),.rdata_B(RtData_id),.DDUdata(DDUdata));
    
endmodule