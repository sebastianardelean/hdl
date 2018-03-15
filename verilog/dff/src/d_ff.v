module d_ff(data,clk,reset,q);
	
	input data,clk,reset;
	output q;
	reg q;
	
	always @(posedge clk)
		if(reset) begin
			q<=1'b0;
		end else begin
			q<=data;
		end
endmodule
