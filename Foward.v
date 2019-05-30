`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/28 21:59:19
// Design Name: 
// Module Name: Foward
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


module Hazard(
    input [4:0] ID_EX_rs,ID_EX_rt,EX_MEM_rd,MEM_WB_rd,IF_ID_rs,IF_ID_rt,
    input RegWrite_mem,RegWrite_wb,MemRead_ex,
    output reg Stall,
    output reg [1:0] ForwardA,ForwardB
    );
    always @ (*)
    begin
        Stall = 0;
        ForwardA = 2'b00;
        ForwardB = 2'b00;
        if (RegWrite_mem & EX_MEM_rd!=0 & EX_MEM_rd==ID_EX_rs)
            ForwardA = 2'b10;
        else if (RegWrite_wb & MEM_WB_rd!=0 & MEM_WB_rd==ID_EX_rs)
            ForwardA = 2'b01;
        if (RegWrite_mem & EX_MEM_rd!=0 & EX_MEM_rd==ID_EX_rt)
            ForwardB = 2'b10;
        else if (RegWrite_wb & MEM_WB_rd!=0 & MEM_WB_rd==ID_EX_rt)
            ForwardB = 2'b01;
        if (MemRead_ex & (ID_EX_rt==IF_ID_rs | ID_EX_rt==IF_ID_rt))
            Stall = 1;
    end
endmodule
