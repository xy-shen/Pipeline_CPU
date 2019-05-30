`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/23 16:02:13
// Design Name: 
// Module Name: Top
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


module Top(
    input clk_in1,//don't use when sim
//    input clk_500,//use when sim
    input rst,
    input cont,step,mem,inc,dec,
    output [7:0] an,
    output [6:0] seg,
    output [15:0] led
    );
//clock
    wire clk_500;//don't use when sim
    wire clk,clk_100M;
    clk_wiz_0 clk100M(.clk_in1(clk_in1),.clk_out1(clk_100M));//don't use when sim
    clk_500Hz clk500(clk_100M,clk_500);//don't use when sim
//DDU
    wire [7:0] DDURaddr;
    wire [31:0] DDUMdata,DDURdata,ddudata,PC_out;
    assign ddudata = (mem? DDUMdata:DDURdata);
    DDU ddu(.clk_500(clk_500),.rst(rst),.cont(cont),.step(step),.inc(inc),.dec(dec),.PCaddr(PC_out),
        .clk(clk),.DDURaddr(DDURaddr),.led(led));
    DDUsegdisplay dduseg(.clk_500(clk_500),.ddudata(ddudata),.an(an),.seg(seg));
//IF
    wire branch_or_pc_mem,Jump_mem;//MEM!
    wire [31:0] Branch_addr_mem,Jump_addr_mem;//MEM!
    wire [31:0] next_pc_if,inst_if;
    IF IF(.clk(clk),.rst(rst),.branch_or_pc(branch_or_pc_mem),.Jump(Jump_mem),
        .branch_addr(Branch_addr_mem),.jump_addr(Jump_addr_mem),
        .next_pc_if(next_pc_if),.inst_if(inst_if),.pc(PC_out));
//IF-ID
    wire [31:0] next_pc_id;
    wire [31:0] inst_id;
    flipflop#(.WIDTH(32))IF_ID1(.clk(clk),.rst(rst),.in(branch_or_pc_mem? 0:inst_if),.out(inst_id));
    flipflop#(.WIDTH(32))IF_ID2(.clk(clk),.rst(rst),.in(branch_or_pc_mem? 0:next_pc_if),.out(next_pc_id));
//ID
    wire MemtoReg_id,RegWrite_id,MemWrite_id,MemRead_id,RegDst_id,ALUSrcB_id,Jump_id,BEQ_id,BNE_id;
    wire [2:0] ALUCode_id;
    wire [4:0] RsAddr_id,RtAddr_id,RdAddr_id;
    wire [31:0] Imm_id,RsData_id,RtData_id; 
    wire RegWrite_wb;//WB!
    wire [4:0] RegWriteAddr_wb;//WB!
    wire [31:0] RegWriteData_wb;//WB！
    reg [31:0] reg_data_wb;//WB!
    
    assign RegWriteData_wb = reg_data_wb;
    ID ID(.clk(clk),.rst(rst),.inst_id(inst_id),
        .RegWrite_wb(RegWrite_wb),.RegWriteAddr_wb(RegWriteAddr_wb),
        .RegWriteData_wb(RegWriteData_wb),//送进来的数据要经过选择，在WB命名为reg_data_wb
        .RegWrite_id(RegWrite_id),.RegDst_id(RegDst_id),.MemtoReg_id(MemtoReg_id),
        .MemWrite_id(MemWrite_id),.MemRead_id(MemRead_id),.Jump_id(Jump_id),.BEQ_id(BEQ_id),.BNE_id(BNE_id),
        .ALUCode_id(ALUCode_id),.ALUSrcB_id(ALUSrcB_id),
        .Imm_id(Imm_id),.RsData_id(RsData_id),.RtData_id(RtData_id),.DDURaddr(DDURaddr[4:0]),
        .RsAddr_id(RsAddr_id),.RtAddr_id(RtAddr_id),.RdAddr_id(RdAddr_id),.DDUdata(DDURdata));
//ID-EX
    wire MemtoReg_ex,RegWrite_ex,MemWrite_ex,MemRead_ex,ALUSrcB_ex,RegDst_ex,Jump_ex,BEQ_ex,BNE_ex,Stall;
    wire [2:0] ALUCode_ex;
    wire [4:0] RsAddr_ex,RtAddr_ex,RdAddr_ex;
    wire [31:0] Imm_ex,RsData_ex,RtData_ex,next_pc_ex;
    flipflop#(.WIDTH(1))ID_EX1(.clk(clk),.rst(rst),.in((branch_or_pc_mem|Stall)? 0:RegWrite_id),.out(RegWrite_ex));
    flipflop#(.WIDTH(1))ID_EX2(.clk(clk),.rst(rst),.in(branch_or_pc_mem? 0:RegDst_id),.out(RegDst_ex));
    flipflop#(.WIDTH(1))ID_EX3(.clk(clk),.rst(rst),.in((branch_or_pc_mem|Stall)? 0:MemRead_id),.out(MemRead_ex));
    flipflop#(.WIDTH(1))ID_EX4(.clk(clk),.rst(rst),.in((branch_or_pc_mem|Stall)? 0:MemWrite_id),.out(MemWrite_ex));
    flipflop#(.WIDTH(1))ID_EX5(.clk(clk),.rst(rst),.in((branch_or_pc_mem|Stall)? 0:MemtoReg_id),.out(MemtoReg_ex));
    flipflop#(.WIDTH(1))ID_EX6(.clk(clk),.rst(rst),.in(branch_or_pc_mem? 0:ALUSrcB_id),.out(ALUSrcB_ex));
    flipflop#(.WIDTH(1))ID_EX7(.clk(clk),.rst(rst),.in((branch_or_pc_mem|Stall)? 0:Jump_id),.out(Jump_ex));
    flipflop#(.WIDTH(1))ID_EX8(.clk(clk),.rst(rst),.in((branch_or_pc_mem|Stall)? 0:BEQ_id),.out(BEQ_ex));
    flipflop#(.WIDTH(1))ID_EX9(.clk(clk),.rst(rst),.in((branch_or_pc_mem|Stall)? 0:BNE_id),.out(BNE_ex));
    flipflop#(.WIDTH(3))ID_EX10(.clk(clk),.rst(rst),.in(branch_or_pc_mem? 0:ALUCode_id),.out(ALUCode_ex));
    flipflop#(.WIDTH(5))ID_EX11(.clk(clk),.rst(rst),.in(branch_or_pc_mem? 0:RsAddr_id),.out(RsAddr_ex));
    flipflop#(.WIDTH(5))ID_EX12(.clk(clk),.rst(rst),.in(branch_or_pc_mem? 0:RtAddr_id),.out(RtAddr_ex));
    flipflop#(.WIDTH(5))ID_EX13(.clk(clk),.rst(rst),.in(branch_or_pc_mem? 0:RdAddr_id),.out(RdAddr_ex)); 
    flipflop#(.WIDTH(32))ID_EX14(.clk(clk),.rst(rst),.in(branch_or_pc_mem? 0:next_pc_id),.out(next_pc_ex));
    flipflop#(.WIDTH(32))ID_EX15(.clk(clk),.rst(rst),.in(branch_or_pc_mem? 0:RsData_id),.out(RsData_ex));
    flipflop#(.WIDTH(32))ID_EX16(.clk(clk),.rst(rst),.in(branch_or_pc_mem? 0:RtData_id),.out(RtData_ex));
    flipflop#(.WIDTH(32))ID_EX17(.clk(clk),.rst(rst),.in(branch_or_pc_mem? 0:Imm_id),.out(Imm_ex));
//EX
    wire alu_zero_ex;
    wire [1:0] ForwardA,ForwardB;
    wire [4:0] RegWriteAddr_ex;
    wire [31:0] Branch_addr_ex,Jump_addr_ex,alu_res_ex, alu_res_mem;
    EX EX(.clk(clk),.ForwardA(ForwardA),.ForwardB(ForwardB),
        .next_pc_ex(next_pc_ex),.ALUCode_ex(ALUCode_ex),.ALUSrcB_ex(ALUSrcB_ex),.RegDst_ex(RegDst_ex),
        .Imm_ex(Imm_ex),.RsData_ex(RsData_ex),.RtData_ex(RtData_ex),.alu_res_mem(alu_res_mem),.reg_data_wb(reg_data_wb),
        .RtAddr_ex(RtAddr_ex),.RdAddr_ex(RdAddr_ex),.Branch_addr_ex(Branch_addr_ex),.Jump_addr_ex(Jump_addr_ex),
        .alu_zero_ex(alu_zero_ex),.alu_res_ex(alu_res_ex),.RegWriteAddr_ex(RegWriteAddr_ex));
/*EX-MEM级间寄存器*/
    wire RegWrite_mem,MemRead_mem,MemWrite_mem,MemtoReg_mem,BEQ_mem,BNE_mem,alu_zero_mem;
    wire [4:0] RegWriteAddr_mem;
    wire [31:0] RtData_mem;
    flipflop#(.WIDTH(1))EX_MEM1(.clk(clk),.rst(rst),.in(branch_or_pc_mem? 0:RegWrite_ex),.out(RegWrite_mem));
    flipflop#(.WIDTH(1))EX_MEM2(.clk(clk),.rst(rst),.in(branch_or_pc_mem? 0:MemRead_ex),.out(MemRead_mem));
    flipflop#(.WIDTH(1))EX_MEM3(.clk(clk),.rst(rst),.in(branch_or_pc_mem? 0:MemWrite_ex),.out(MemWrite_mem));
    flipflop#(.WIDTH(1))EX_MEM4(.clk(clk),.rst(rst),.in(branch_or_pc_mem? 0:MemtoReg_ex),.out(MemtoReg_mem));
    flipflop#(.WIDTH(1))EX_MEM5(.clk(clk),.rst(rst),.in(branch_or_pc_mem? 0:BEQ_ex),.out(BEQ_mem));
    flipflop#(.WIDTH(1))EX_MEM6(.clk(clk),.rst(rst),.in(branch_or_pc_mem? 0:BNE_ex),.out(BNE_mem));
    flipflop#(.WIDTH(1))EX_MEM7(.clk(clk),.rst(rst),.in(branch_or_pc_mem? 0:alu_zero_ex),.out(alu_zero_mem));
    flipflop#(.WIDTH(1))EX_MEM8(.clk(clk),.rst(rst),.in(branch_or_pc_mem? 0:Jump_ex),.out(Jump_mem));
    flipflop#(.WIDTH(5))EX_MEM9(.clk(clk),.rst(rst),.in(branch_or_pc_mem? 0:RegWriteAddr_ex),.out(RegWriteAddr_mem));
    flipflop#(.WIDTH(32))EX_MEM10(.clk(clk),.rst(rst),.in(branch_or_pc_mem? 0:Branch_addr_ex),.out(Branch_addr_mem));//decalred in IF
    flipflop#(.WIDTH(32))EX_MEM11(.clk(clk),.rst(rst),.in(branch_or_pc_mem? 0:Jump_addr_ex),.out(Jump_addr_mem));//decalred in IF
    flipflop#(.WIDTH(32))EX_MEM12(.clk(clk),.rst(rst),.in(branch_or_pc_mem? 0:alu_res_ex),.out(alu_res_mem));
    flipflop#(.WIDTH(32))EX_MEM13(.clk(clk),.rst(rst),.in(branch_or_pc_mem? 0:RtData_ex),.out(RtData_mem));
//MEM
    wire [31:0] Dout_mem;
    MEM MEM(.clk(clk),.MemRead_mem(MemRead_mem),.MemWrite_mem(MemWrite_mem),
        .BEQ_mem(BEQ_mem),.BNE_mem(BNE_mem),.alu_zero_mem(alu_zero_mem),
        .alu_res_mem(alu_res_mem),.RtData_mem(RtData_mem),.reg_data_wb(reg_data_wb),.DDURaddr(DDURaddr),
        .branch_or_pc_mem(branch_or_pc_mem),.Dout_mem(Dout_mem),.DDUMdata(DDUMdata));
//MEM-WB
    wire MemtoReg_wb;
    wire [4:0] RdAddr_wb;
    wire [31:0] Dout_wb,alu_res_wb;
    flipflop#(.WIDTH(1))MEM_WB1(.clk(clk),.rst(rst),.in(RegWrite_mem),.out(RegWrite_wb));
    flipflop#(.WIDTH(1))MEM_WB2(.clk(clk),.rst(rst),.in(MemtoReg_mem),.out(MemtoReg_wb));
    flipflop#(.WIDTH(5))MEM_WB3(.clk(clk),.rst(rst),.in(RegWriteAddr_mem),.out(RegWriteAddr_wb));
    flipflop#(.WIDTH(32))MEM_WB4(.clk(clk),.rst(rst),.in(Dout_mem),.out(Dout_wb));
    flipflop#(.WIDTH(32))MEM_WB5(.clk(clk),.rst(rst),.in(alu_res_mem),.out(alu_res_wb));
//WB
    always @ (*)
    begin
        case(MemtoReg_wb)
            1'b0:reg_data_wb = alu_res_wb;//来自ALU
            1'b1:reg_data_wb = Dout_wb;//来自RAM
        endcase
    end
//Hazard: forward and stall
    Hazard hazard(.ID_EX_rs(RsAddr_ex),.ID_EX_rt(RtAddr_ex),
        .EX_MEM_rd(RegWriteAddr_mem),.MEM_WB_rd(RegWriteAddr_wb),.IF_ID_rs(inst_id[25:21]),.IF_ID_rt(inst_id[20:16]),
        .RegWrite_mem(RegWrite_mem),.RegWrite_wb(RegWrite_wb),.MemRead_ex(MemRead_ex),
        .Stall(Stall),.ForwardA(ForwardA),.ForwardB(ForwardB));
endmodule