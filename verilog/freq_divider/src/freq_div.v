//----------------------------------------------
// Design Name: Divide by 2 Counter
// File Name: frequencydivider.v
// Function: Frequency divider by 2
// Developer: Mihai
//----------------------------------------------
module freq_div(
	clk, frequency,reset);
	input clk;
	input reset;
	output frequency;

	wire feedback_loop;

	d_ff d_flipflop(.data(feedback_loop),.clk(clk),.reset(reset),.q(frequency),.qn(feedback_loop));
endmodule // frequencydivider	