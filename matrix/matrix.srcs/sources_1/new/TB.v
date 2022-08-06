`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.07.2022 17:05:53
// Design Name: 
// Module Name: TB
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


//Instantiate all memories

module TB(i_clk,i_reset,WE1,WE2,WE,addrA,addrB,addrC,tempreg,num1,num2,num3);

input i_clk,i_reset,WE1,WE2,WE;
input [6:0] addrA,addrB,addrC;
input [31:0] tempreg;
output [31:0]num1,num2,num3;

Data_Memory_A a1(.in_Data(tempreg),.A(addrA),.clk(i_clk),.WE(WE1),.rst(i_reset),.o_Data(num1));
Data_Memory_B a2(.in_Data(tempreg),.A(addrB),.clk(i_clk),.WE(WE2),.rst(i_reset),.o_Data(num2));
Data_Memory_C a3(.in_Data(tempreg),.readA(addrC),.writeA(addrC),.clk(i_clk),.WE(WE),.rst(i_reset),.o_Data(num3));

endmodule
