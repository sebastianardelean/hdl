//----------------------------------------------
// Design Name: 4-bits Asynchronous Up Counter
// File Name: four_bit_auc.v
// Function: Asynchronous Up Counter on 4 bits
// Developer: Mihai
//----------------------------------------------
module four_bit_auc(
	clk,
	reset,
	q
	);
	input clk;
	input reset;
	output [3:0] q;
	
	wire ff0_feedback_loop;
	wire ff1_feedback_loop;
	wire ff2_feedback_loop;
	wire ff3_feedback_loop;

	d_ff ff0(.clk  (clk),
		.reset(reset),
		.q    (q[0]),
		.data (ff0_feedback_loop),
		.qn   (ff0_feedback_loop)
		);

	d_ff ff1(.clk  (ff0_feedback_loop),
		.reset(reset),
		.q    (q[1]),
		.data (ff1_feedback_loop),
		.qn   (ff1_feedback_loop)
		);

	d_ff ff2(.clk  (ff1_feedback_loop),
		.reset(reset),
		.q(q[2]),
		.data (ff2_feedback_loop),
		.qn   (ff2_feedback_loop)
		);

	d_ff ff3(.clk  (ff2_feedback_loop),
		.reset(reset),
		.q    (q[3]),
		.data (ff3_feedback_loop),
		.qn   (ff3_feedback_loop)
		);


endmodule // four_bit_aug