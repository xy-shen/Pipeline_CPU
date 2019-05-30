`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/24 09:08:43
// Design Name: 
// Module Name: DDU
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


module DDU(
    input clk_500,rst,
    input cont,step,inc,dec,
    input [31:0] PCaddr,
    output clk,
    output reg [7:0] DDURaddr,
    output [15:0] led
    );
    integer cntinc,cntdec;
    
    assign clk = (cont? clk_500:step);
    assign {led[7:0]} = DDURaddr;
    assign {led[15:8]} = {PCaddr[7:0]};
    
    always @ (posedge clk_500)
    begin
        cntinc <= 0;
        cntdec <= 0;
        if (rst)
            DDURaddr <= 0;
        else if (inc)
        begin
            cntinc <= cntinc + 1;
            if (cntinc==10) DDURaddr <= DDURaddr+1;
        end
        else if (dec)
        begin
            cntdec <= cntdec + 1;
            if (cntdec==10) DDURaddr <= DDURaddr-1;
        end
    end
endmodule