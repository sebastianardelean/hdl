//----------------------------------------------
// Design Name: 8 bit up/down counter with load
// File Name: counter.v
// Function: Up/Down counter
// Coder: Mihai
//----------------------------------------------

module counter(
	       out,//counter output
	       up_down,//up_down control
	       clk,//clock input
	       data,//data to load
	       load,//load data
	       enable,//enable counting
	       reset//reset input
	       );
   //-----Output Ports-----
   output[7:0] out;
   //-----Input Ports-----
   input [7:0] data;
   input      up_down,clk,reset,load,enable;
   reg [7:0]  out;
   reg [7:0] data_buf;
   
   
   always @(posedge clk) begin
      if(reset) begin
	 out<=8'b0;
      end
      if (load) begin
	 out<=data;
      end  
      if(enable) begin
	 if(up_down && out<data) begin //if updown=1, count up
	    out<=out+1;
	 end 
	 if(~up_down && out>0) begin //updown=0, count down
	    out<=out-1;
	 end
      end
   end
endmodule
