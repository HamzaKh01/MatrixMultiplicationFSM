`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.07.2022 17:08:48
// Design Name: 
// Module Name: MemC
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


module Data_Memory_C (
    input [31:0] in_Data,
    input [6:0] readA,writeA,
    input clk,WE,rst,
    output reg [31:0] o_Data
);
    reg [31:0] Data_Mem [99:0];
    integer i;
    always @(*) begin
        o_Data <= Data_Mem[readA];
    end
    always @(posedge clk) begin
        if (rst) begin
            for(i=0;i<100;i=i+1)
                Data_Mem[i] <= i+1;
        end else if (WE) begin
            Data_Mem[writeA] <= in_Data;
        end
    end
endmodule