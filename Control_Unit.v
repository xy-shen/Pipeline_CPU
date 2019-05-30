`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/23 16:49:43
// Design Name: 
// Module Name: Control_Unit
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


module Control_Unit(
    input [31:0] inst,
    output RegWrite,RegDst,MemRead,MemWrite,Jump,BEQ,BNE,
    output reg [2:0] ALUCode,
    output ALUSrc_B,
    output MemtoReg//1:mem
    );
    wire[5:0] op;
    wire[5:0] func;
    wire[4:0] rt;
    assign op=inst[31:26];
    assign func=inst[5:0];
    
//R type
    parameter R_type_op=6'b000000,
        ADD_func=6'b100000,
        SUB_func=6'b100010,
        AND_func=6'b100100,
        OR_func=6'b100101,
        XOR_func=6'b100110,
        NOR_func=6'b100111,
        SLT_func=6'b101010;
    wire ADD,AND,NOR,OR,SUB,XOR,SLT,R_type;
    assign ADD = (op==R_type_op)&&(func==ADD_func);
    assign SUB = (op==R_type_op)&&(func==SUB_func);
    assign AND = (op==R_type_op)&&(func==AND_func);
    assign OR = (op==R_type_op)&&(func==OR_func);
    assign XOR = (op==R_type_op)&&(func==XOR_func);
    assign NOR = (op==R_type_op)&&(func==NOR_func);
    assign SLT = (op==R_type_op)&&(func==SLT_func);
    assign R_type = (op==R_type_op);//ADD|AND|NOR|OR|SUB|XOR|SLT; 
//Branch
    parameter BEQ_op=6'b000100;
    parameter BNE_op=6'b000101;
    assign BEQ = (op==BEQ_op);
    assign BNE = (op==BNE_op);
// I type
    parameter ADDI_op=6'b001000,
        ANDI_op=6'b001100,
        ORI_op=6'b001101,
        XORI_op=6'b001110,
        SLTI_op=6'b001010;
    wire ADDI,ANDI,XORI,ORI,SLTI,I_type;
    assign ADDI = (op== ADDI_op);
    assign ANDI = (op==ANDI_op);
    assign ORI = (op==ORI_op);
    assign XORI = (op==XORI_op);
    assign SLTI = (op==SLTI_op);
    assign I_type = ADDI|ANDI|XORI|ORI; 
// SW,LW
    parameter SW_op=6'b101011;
    parameter LW_op=6'b100011;
    wire SW,LW;
    assign SW = (op==SW_op);
    assign LW = (op==LW_op);
// J type
    parameter J_op=6'b000010;
    wire J;
    assign J = (op==J_op);
// Control Singal
    assign RegWrite = LW|R_type|I_type;
    assign RegDst = R_type;//RegDst=1:choose rd (for R type)
    assign MemWrite = SW;
    assign MemRead = LW;
    assign MemtoReg = LW;
    assign ALUSrc_B = LW|SW|I_type;
    assign Jump=J;
// ALU control
    parameter alu_add=3'b000,
        alu_sub=3'b001,
        alu_and=3'b010,
        alu_or=3'b011,
        alu_xor=3'b100,
        alu_nor=3'b101,
        alu_slt='b110;
    
    always @ (*)
    begin
        if(op==R_type_op)
        begin
            case(func)
                ADD_func: ALUCode<=alu_add;
                SUB_func: ALUCode<=alu_sub;
                AND_func: ALUCode<=alu_and;
                OR_func: ALUCode<=alu_or;
                XOR_func: ALUCode<=alu_xor;
                NOR_func: ALUCode<=alu_nor;
                SLT_func: ALUCode<=alu_slt;
                default: ALUCode<=alu_add;
            endcase
        end
        else
        begin
            case(op)
                BEQ_op: ALUCode<=alu_sub;
                BNE_op: ALUCode<=alu_sub;
                ADDI_op: ALUCode<=alu_add;
                ANDI_op: ALUCode<=alu_and;
                ORI_op: ALUCode<=alu_or;
                XORI_op: ALUCode<=alu_xor;
                SLTI_op: ALUCode<=alu_slt;
                SW_op: ALUCode<=alu_add;
                LW_op: ALUCode<=alu_add;
                J_op: ALUCode<=alu_add;
                default: ALUCode<=alu_add;
            endcase
        end
    end
endmodule