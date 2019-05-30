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


module RegisterFiles(
    input clk,L_S,
    input [4:0] R_addr_A,R_addr_B,Wt_addr,DDURaddr,
    input [31:0] wt_data,
    output [31:0] rdata_A,rdata_B,DDUdata
    );
    reg [31:0] register [0:31];
    integer i;
    
    assign rdata_A = register[R_addr_A];
    assign rdata_B = register[R_addr_B];
    assign DDUdata = register[DDURaddr];
    
    always @ (negedge clk)
    begin
        register[0] <= 0;
        if ((Wt_addr!=0)&&(L_S==1))
            register[Wt_addr] <= wt_data;
    end
endmodule