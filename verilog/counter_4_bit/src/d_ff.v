//----------------------------------------------
// Design Name: D Flip Flop 
// File Name: d_ff.v
// Function: D Flip Flop
// Developer: Mihai
//----------------------------------------------
module d_ff(data,clk,reset,q,qn);
	
	input data,clk,reset;
	output reg q;
	output reg qn;
	
	
	always @(posedge clk)
		if(reset) begin
			q<=1'b0;
			qn<=1'b1;
		end else begin
			q<=data;
			qn<=~data;
		end
endmodule
