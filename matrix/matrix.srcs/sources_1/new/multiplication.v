`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.07.2022 13:30:55
// Design Name: 
// Module Name: multiplication
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

//It calculates the product of two numbers that is number1 and number2 provided and displays result in product when o_done1 is high and it is high for one cycle,overflow flag is asserted when product exceeds 32 bits
//i_reset is synchronous to the clk
//i_start is the signal to start FSM
//return to first state after computing product
//datapath and state graph is attached in the report

module multiplication (i_clk,i_reset,i_start,number1,number2,o_done1,overflow,product);
  
  input i_clk;
  input i_reset;
  input i_start;
  input [31:0]number1,number2;
  output reg o_done1;
  output reg overflow;
  output reg [31:0]product;
  
  reg  [31:0] num1,num2;
  wire [31:0] wire1,wire2,wire3,wire4,wire5,wire6,wire7,wire8,wire9,prod_in,overflowIn,wire10;
  reg  sel1,sel2,sel3,sel4,sel5,sel6,sel7,sel8,sel9;
  wire gt_flag,num1_nteq_z,num2_nteq_z,lt1,lt2;
   
  
  //Datapath
  
  //MUXES
  
  assign wire3 = sel1? number1:wire5;
  assign wire4 = sel2? number2:wire6;
  assign wire1 = sel3? wire3:num1;
  assign wire2 = sel4? wire4:num2;
  assign prod_in = sel5? wire9:product;
  assign wire7 =sel6?num2:num1;
  assign wire9 =sel7?32'd0:wire8;
  assign overflowIn =sel8?wire10:overflow;
  assign wire10 =sel9?1'b1:1'b0;

  //COMPARATORS 

  assign gt_flag     = (num1>num2)?    1:0;
  assign num1_nteq_z = (num1 != 0)?    1:0;
  assign num2_nteq_z = (num2 != 0)?    1:0;
  assign lt1         = (product<num1)? 1:0;
  assign lt2         = (product<num2)? 1:0;

  
  //ADDER
  
  assign wire8 = product+wire7;
  
  //SUBTRACTOR
  
  assign wire5 = num1-32'd1;
  assign wire6 = num2-32'd1;


  always@(posedge i_clk)begin    //Register for num1

    if(i_reset)
      num1<=32'h0000_0000;
    else
      num1<= wire1;
      
  end

  always@(posedge i_clk)begin    //Register for num2

    if(i_reset)
      num2<=32'h0000_0000;
    else
      num2<= wire2;
      
  end

  always@(posedge i_clk)begin  //Register for product

    if(i_reset)
      product<=32'h0000_0000;
    else
      product<= prod_in;
      
  end
  
   always@(posedge i_clk)begin  //Register for product

    if(i_reset)
      overflow<=1'b0;
    else
      overflow<= overflowIn;
      
  end

  //CONTROLLER

  reg [3:0] currentstate;
  reg [3:0] nextstate;

  always @(posedge i_clk)begin   //state register
      
      if(i_reset)begin
          currentstate <= 4'd0;
      end
      else begin
          currentstate <= nextstate;
      end
  end

  always@(*)begin
    
    case(currentstate) 
      
      4'b0000:begin  //0--------start
        
        sel1=0;
        sel2=0;
        sel3=0;
        sel4=0;
        sel5=1;
        sel6=0;
        sel7=1;
        sel8=1;
        sel9=0;
        o_done1=0;
        if(i_start)
          nextstate=4'b0001;
        else 
          nextstate=4'b0000;
      end
      
      4'b0001:begin   //1--------Load num1 and num2
      
        sel1=1;
        sel2=1;
        sel3=1;
        sel4=1;
        sel5=0;
        sel6=0;
        sel7=0;
        sel8=0;
        sel9=0;
        o_done1=0;
        nextstate=4'b0010;

      end
      
      
      4'b0010:begin //2------Compare num1 > num2

        sel1=0;
        sel2=0;
        sel3=0;
        sel4=0;
        sel5=0;
        sel6=0;
        sel7=0;
        sel8=0;
        sel9=0;
        o_done1=0;
        if(gt_flag)
          nextstate=4'b0011;
        else
          nextstate=4'b0101;

      end
       

      4'b0011:begin//3-----Check num2 != 0
 
        sel1=0;
        sel2=0;
        sel3=0;
        sel4=0;
        sel5=0;
        sel6=0;
        sel7=0;
        sel8=0;
        sel9=0;
        o_done1=0;
        if(num2_nteq_z)
          nextstate=4'b0100;
        else
          nextstate=4'b0111;

      end

      
      4'b0100:begin//4-----Product =product+num1; num2--
        sel1=0;
        sel2=0;
        sel3=0;
        sel4=1;
        sel5=1;
        sel6=0;
        sel7=0;
        sel8=0;
        sel9=0;
        o_done1=0;
        nextstate<=4'b1000;

      end 
      
      4'b0101:begin  //5 Check num1 != 0
        sel1=0;
        sel2=0;
        sel3=0;
        sel4=0;
        sel5=0;
        sel6=0;
        sel7=0;
        sel8=0;
        sel9=0;
        o_done1=0;
        if(num1_nteq_z)
          nextstate=4'b0110;
        else
          nextstate=4'b0111;

      end
       4'b0110:begin  //6 Product =product+num2; num1--
        sel1=0;
        sel2=0;
        sel3=1;
        sel4=0;
        sel5=1;
        sel6=1;
        sel7=0;
        sel8=0;
        sel9=0;
        o_done1=0;
        nextstate=4'b1001;
       
        end
      
      4'b0111:begin  //7---done
        sel1=0;
        sel2=0;
        sel3=0;
        sel4=0;
        sel5=0;
        sel6=0;
        sel7=0;
        sel8=0;
        sel9=0;
        o_done1=1;
        nextstate=4'b0000;


      end
      
      4'b1000:begin  //8---check overflow num1
        sel1=0;
        sel2=0;
        sel3=0;
        sel4=0;
        sel5=0;
        sel6=0;
        sel7=0;
        o_done1=0;
        if(lt1)begin
           sel8=1;
           sel9=1;
           nextstate=4'b0111;
      end
      else begin
          nextstate=4'b0011;
          sel8=0;
          sel9=0;
      end
      end
      
      4'b1001:begin  //9---check overflow num2
        sel1=0;
        sel2=0;
        sel3=0;
        sel4=0;
        sel5=0;
        sel6=0;
        sel7=0;
        o_done1=0;
        if(lt2)begin
            sel8=1;
            sel9=1;
            nextstate=4'b0111;
        end
        else begin
          nextstate=4'b0101;
          sel8=0;
          sel9=0;
      end
      end
      
      default:begin
       
       sel1=0;
       sel2=0;
       sel3=0;
       sel4=0;
       sel5=0;
       sel6=0;
       sel7=0;
       sel8=0;
       sel9=0;
       o_done1=0;
       nextstate=4'b0000;
      end
             
    endcase
  end
endmodule
