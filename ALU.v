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


module ALU(
    input [2:0] ALUctrl,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] ALUresult,
    output Zero//zero
    );
    wire [31:0] yadd,ysub,yand,yor,ynor,yxor;
    reg V;//signed,½èÎ»
    assign yadd=a+b;
    assign ysub=a-b;
    assign yand=a&b;
    assign yor=a|b;
    assign ynor=~(a|b);
    assign yxor=a^b;
    assign Zero=(ALUresult==0? 1:0);
    
    always @ (*)
    begin
        V=0;
        case (ALUctrl)
            3'b000: ALUresult=yadd;
            3'b001: ALUresult=ysub;
            3'b010: ALUresult=yand;
            3'b011: ALUresult=yor;
            3'b100: ALUresult=yxor;
            3'b101: ALUresult=ynor;
            3'b110:
            begin
                if (a[31]==b[31] && a[31]!=ysub[31]) ALUresult = 1;//slt
                else ALUresult = 0;
            end
        endcase
    end
endmodule