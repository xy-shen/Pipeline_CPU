`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/28 21:12:22
// Design Name: 
// Module Name: pipline_CPU_tb
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


module pipline_CPU_tb(
    );
    reg clk_500, rst,cont,step,mem,inc,dec,run;//DDU
    wire [31:0] reg_data,mem_data;
    wire [7:0] an;
    wire [6:0] seg;
    wire [15:0] led;
    Top DUT(clk_500,rst,cont,step,mem,inc,dec,an,seg,led);
    initial
    begin
        clk_500 = 0;
        rst = 1;
        cont = 1;
        #8
        rst = 0;
    end
    always#5 clk_500 = ~clk_500;
endmodule
