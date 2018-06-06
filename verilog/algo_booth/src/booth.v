//----------------------------------------------
// Design Name: Booth behavioral description 
// File Name: booth.v
// Function: Multiply Algorithm
// Coder: Mihai
//----------------------------------------------

//Possible states for enable signal
`define INITIALIZE 3'b001//initialization-> set A=0x00,Q(-1)=0b0,count=0b0000;

`define LOAD_Q 3'b010//get Q from INBUS

`define LOAD_M 3'b011//get M from INBUS

`define RUN 3'b100//start running

`define STORE_A 3'b101//set A on OUTBUS

`define STORE_Q 3'b110//set Q on OUTBUS

module booth(
           inbus, //input bus
           outbus,//output bus
           enable//control
           );
   
   //-----Output Ports-----
   output reg [7:0] outbus;
   
   //-----Input Ports------
   input [7:0] 	    inbus;
   input [2:0] 	    enable;
   
   //-----Registers--------   
   reg [7:0] 	    A_reg;
   reg [7:0] 	    M_reg;
   reg [7:0] 	    Q_reg;
   reg 		    Q_1;
   reg [3:0] 	    count;
   
   //-----Wires------------   
   wire [7:0] 	    sum;
   wire [7:0] 	    difference;

   //sensitive to enable and count signals
   always @(enable,count) begin
      case(enable)//just a switch to change states
    `INITIALIZE:
      begin
         A_reg<=8'b0;//initialize A_Reg with 0
         Q_1<=1'b0;
         count<=4'b0;
      end
    `LOAD_Q:
      Q_reg<=inbus;//load Q from inbus
    `LOAD_M:
      M_reg<=inbus;//load M from inbus
    `RUN:
      if(count<8) 
        begin
           case ({Q_reg[0],Q_1})
	 2'b01:{A_reg,Q_reg,Q_1}<={sum[7],sum,Q_reg};
	 2'b10:{A_reg,Q_reg,Q_1}<={difference[7],difference,Q_reg};
	 default:{A_reg,Q_reg,Q_1}<={A_reg[7],A_reg,Q_reg};
           endcase // case ({Q_reg[0],Q_1}}...
           count<=count+1'b1;  
        end
    `STORE_A:
      outbus<=A_reg;
    `STORE_Q:
      outbus<=Q_reg;
      endcase // case (enable)
      
   end // always @ (enable)
   assign sum=A_reg+M_reg;
   assign difference=A_reg-M_reg;
endmodule // booth

