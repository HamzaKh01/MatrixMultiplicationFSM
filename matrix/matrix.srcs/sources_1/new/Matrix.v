`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.07.2022 17:09:36
// Design Name: 
// Module Name: Matrix
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



//It calculates the product of A*B, where A and B are two matrices each of order 10-by-10, Initially A and B both are all 1's means every location is 1
//Matrix A is stored in MemA, MatrixB is stored in MemB, To change Matrix A or MatrixB just change the memoryA and B respectively
//Note memory have 100 positions that are 0 to 99,where 0 to 9 represents first row 10 to 19 represents second row and so on
//i_reset is synchronous to the clk
//i_start is the signal to start FSM
//return to first state after computing 
//o_done is hign for one cycle
//invalid is high if result exceeds 32 bits
//num1,num2,num3 are thee data_out from memA,memB,memC on the corresponding addresses of addrA,addrB and addrC respectively
//WE1,WE2,WE are the write enables of memA,memB,memC
//memA and memB are 1RW and memC is 1R1W
//tempreg holds the result of output matrix of one location and then stored at the corresponding address of addrC
//Datapath and state diagram is in report


module Matrixmultiplication (i_clk,i_reset,i_start,num1,num2,num3,WE,WE1,WE2,o_done,invalid,addrA,addrB,addrC,tempreg);

  input i_clk;
  input i_reset;
  input i_start;
  input [31:0] num1,num2,num3;
  output reg WE,WE1,WE2,o_done,invalid;
  output reg [6:0] addrA,addrB,addrC;
  output reg [31:0]tempreg;
    
  reg [6:0] row,column;
  wire [6:0] rowplus10,rowIn,addrAplus1,addrAIn,addrBplus10,addrBIn,addrCplus1,addrCIn,columnplus1,columnIn,invalidIn,wire1,wire3,wire4,wire5;
  wire [31:0] tempregPlusProd,tempregIn,wire2,product;
  reg sel1,sel2,sel3,sel4,sel5,sel6,sel7,sel8,sel9,sel10,sel11,sel12,run;
  wire C_lt100,B_lt100,Ceq10,overflowcheck,doneMultiplication,over;  
  wire [31:0] num1,num2,num3;
   
   //Instatantiate multiplication FSM
   multiplication m1(.i_clk(i_clk),.i_reset(i_reset),.i_start(run),.number1(num1),.number2(num2),.o_done1(doneMultiplication),.overflow(over),.product(product)); 
   
  
  //Datapath
  //MUXES

  assign rowIn     = sel1?  rowplus10:row;
  assign wire2     = sel2?  32'd0:tempregPlusProd;
  assign tempregIn = sel3?  wire2:tempreg;
  assign wire1     = sel4?  addrAplus1:row;
  assign addrAIn   = sel5?  wire1:addrA;
  assign addrBIn   = sel6?  wire4:addrB;
  assign addrCIn   = sel7?  addrCplus1:addrC;
  assign wire3     = sel8?  7'd0:columnplus1;
  assign columnIn  = sel9?  wire3:column;
  assign wire4     = sel10? column:addrBplus10;
  assign invalidIn =sel11?wire5:invalid;
  assign wire5 =sel12?1'b1:1'b0;

  //COMPARATORS 

  assign C_lt100 = (addrC<100)  ? 1:0;
  assign B_lt100 = (addrB<100)  ? 1:0;
  assign Ceq10   = (column==10) ? 1:0;
  assign overflowcheck = tempregPlusProd>=tempreg?0:1;
  
  //ADDER
  
  assign rowplus10 = row + 10;
  assign addrAplus1 = addrA + 1;
  assign tempregPlusProd = tempreg + product;
  assign addrBplus10 = addrB + 10;
  assign addrCplus1 = addrC + 1;
  assign columnplus1 = column + 1;

  
  always@(posedge i_clk)begin   //Register 

    if(i_reset)
      row<=7'd0;
    else
      row<= rowIn;
  end

  always@(posedge i_clk)begin  //Register

    if(i_reset)
      addrA<=7'd0;
    else
      addrA<= addrAIn;
  end

  always@(posedge i_clk)begin  //Register

    if(i_reset)
      addrC<=7'd0;
    else
      addrC<= addrCIn;
  end

  always@(posedge i_clk)begin  //Register

    if(i_reset)
      addrB<=7'd0;
    else
      addrB<= addrBIn;
  end

  always@(posedge i_clk)begin  //Register

    if(i_reset)
      tempreg<=32'h0000_0000;
    else
      tempreg<= tempregIn;
  end

  always@(posedge i_clk)begin   //Register

    if(i_reset)
      column<=7'd0;
    else
      column<= columnIn;
  end
  
 always@(posedge i_clk)begin   //Register

    if(i_reset)
     invalid<=1'b0;
    else
      invalid<= invalidIn;
  end
  


  //CONTROLLER
  
  reg [3:0] currentstate;
  reg [3:0] nextstate;

  always @(posedge i_clk)begin   //State register
      
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
        sel5=0;
        sel6=0;
        sel7=0;
        sel8=0;
        sel9=0;
        sel10=0;
        sel11=1;
        sel12=0;
        run=0;
        WE=0;
        WE1=0;
        WE2=0;
        o_done=0;
        if(i_start)
          nextstate=4'b0001;
        else 
          nextstate=4'b0000;
      end
      
      4'b0001:begin   //1--------Ininitialization
      
        sel1=0;
        sel2=0;
        sel3=0;
        sel4=0;
        sel5=0;
        sel6=0;
        sel7=0;
        sel8=0;
        sel9=0;
        sel10=0;
        sel11=0;
        sel12=0;
        run=0;
        WE=0;
        WE1=0;
        WE2=0;
        o_done=0;
        nextstate=4'b0010;

      end
      
      
      4'b0010:begin //2------check---addrC<100

        sel1=0;
        sel2=0;
        sel3=0;
        sel4=0;
        sel5=0;
        sel6=1;
        sel7=0;
        sel8=0;
        sel9=0;
        sel10=1;
        sel11=0;
        sel12=0;
        run=0;
        WE=0;
        WE1=0;
        WE2=0;
        o_done=0;
        if(C_lt100)
          nextstate=4'b0011;
        else
          nextstate=4'b1100;

      end
       

      4'b0011:begin//3-----Check addrB<100
         
        sel1=0;
        sel2=0;
        sel3=0;
        sel4=0;
        sel5=0;
        sel6=0;
        sel7=0;
        sel8=0;
        sel9=0;
        sel10=0;
        sel11=0;
        sel12=0;
        run=0;
        WE=0;
        WE1=0;
        WE2=0;
        o_done=0;
        if(B_lt100)
          nextstate=4'b0100;
        else
          nextstate=4'b1000;

      end

      
      4'b0100:begin//4-----assert run to activate Multiplication FSM 

        sel1=0;
        sel2=0;
        sel3=0;
        sel4=0;
        sel5=0;
        sel6=0;
        sel7=0;
        sel8=0;
        sel9=0;
        sel10=0;
        sel11=0;
        sel12=0;
        run=1;
        WE=0;
        WE1=0;
        WE2=0;
        o_done=0;
        nextstate=4'b0101;

      end 
      
      4'b0101:begin  //5 ----Wait untill done comes from Multiplication Fsm to obatin product
      sel1=0;
      sel2=0;
      sel3=0;
      sel4=0;
      sel5=0;
      sel6=0;
      sel7=0;
      sel8=0;
      sel9=0;
      sel10=1;
      sel11=0;
      sel12=0;
      run=0;
      WE=0;
      WE1=0;
      WE2=0;
      o_done=0;
      if(over)
          nextstate=4'b1101;
      else if(doneMultiplication)
          nextstate=4'b0110;
       else
          nextstate=4'b0101;

      end
       4'b0110:begin  //6 ----tempreg=tempreg+product
        sel1=0;
        sel2=0;
        sel3=1;
        sel4=0;
         sel5=0;
         sel6=0;
         sel7=0;
         sel8=0;
        sel9=0;
        sel10=1;
        sel11=0;
        sel12=0;
        run=0;
        WE=0;
        WE1=0;
        WE2=0;
        o_done=0;
        if(overflowcheck)
            nextstate=4'b1101;
        else        
            nextstate=4'b0111;
       
        end
      
      4'b0111:begin  //7---Increment---addrA++,addrB=addrB+10
        sel1=0;
        sel2=0;
        sel3=0;
        sel4=1;
        sel5=1;
        sel6=1;
        sel7=0;
        sel8=0;
        sel9=0;
        sel10=0;
        sel11=0;
        sel12=0;
        run=0;
        WE=0;
        WE1=0;
        WE2=0;
        o_done=0;
        nextstate=4'b0011;

      end

      4'b1000:begin  //8---Increment---column++,MemC[addrC]=tempreg
         sel1=0;
         sel2=0;
         sel3=0;
         sel4=0;
         sel5=0;
         sel6=0;
        sel7=0;
        sel8=0;
        sel9=1;
        sel10=0;
        sel11=0;
        sel12=0;
        run=0;
        WE=1;
        WE=0;
        WE2=0;
        o_done=0;
        nextstate=4'b1001;
      end

      4'b1001:begin  //9---Increment---addrA++,addrB=addrB+10
        sel1=0;
        sel2=0;
        sel3=0;
        sel4=0;
        sel5=0;
        sel6=0;
        sel7=0;
        sel8=0;
        sel9=0;
        sel10=0;
        sel11=0;
        sel12=0;
        run=0;
        WE=1;
        WE1=0;
        WE2=0;
        o_done=0;
        if(Ceq10)
            nextstate=4'b1010;
        else
            nextstate=4'b1011;

      end

      4'b1010:begin  //10------column=0,row=row+10
        sel1=1;
        sel2=0;
        sel3=0;
        sel4=0;
        sel5=0;
        sel6=0;
        sel7=0;
        sel8=1;
        sel9=1;
        sel10=0;
        sel11=0;
        sel12=0;
        run=0;
        WE=0;
        WE1=0;
        WE2=0;
        o_done=0;
        nextstate=4'b1011;
      end

      4'b1011:begin  //11------tempreg=0,addrA=row,addrC++
        sel1=0;
        sel2=1;
        sel3=1;
        sel4=0;
        sel5=1;
        sel6=0;
        sel7=1;
        sel8=0;
        sel9=0;
        sel10=0;
        sel11=0;
        sel12=0;
        run=0;
        WE=0;
        WE1=0;
        WE2=0;
        o_done=0;
        nextstate=4'b0010;
      end

      4'b1100:begin  //12---Done 
        sel1=0;
        sel2=0;
        sel3=0;
        sel4=0;
        sel5=0;
        sel6=0;
        sel7=0;
        sel8=0;
        sel9=0;
        sel10=0;
        sel11=0;
        sel12=0;
        o_done=1;
        run=0;
        WE=0;
        WE1=0;
        WE2=0;
        nextstate=4'b1100;
      end        
      
      4'b1101:begin  //13-------error 
        sel1=0;
        sel2=0;
        sel3=0;
        sel4=0;
        sel5=0;
        sel6=0;
        sel7=0;
        sel8=0;
        sel9=0;
        sel10=0;
        sel11=1;
        sel12=1;
        run=0;
        WE=0;
        WE1=0;
        WE2=0;
        o_done=0;
        nextstate=4'b1100;
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
             sel10=0;
             sel11=0;
             sel12=0;
             run=0;
             WE=0;
             WE1=0;
             WE2=0;
             o_done=0;
             nextstate=4'b0000;
      
      end   
            
    endcase
  end
endmodule