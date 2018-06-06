`include "src/fsm_states.v"
module boothr4
	( 
		M,
		Q,
		clk,
		start,
		reset,
		outbus,
		busy
	
	);
	
	input 		[7:0] 	M;
	input 		[7:0] 	Q;
	input 			clk;
	input 			start;
	input			reset;
	output reg 	[7:0]	outbus;
	output			busy;
	
	
	
	reg 		[1:0] 	counter;
	
	reg 		[2:0] 	current_state;
	reg		[2:0]	next_state;
	
	reg 		[17:0] 	AQ;
	
	reg 		[8:0] 	M1;
	reg 		[8:0] 	M2;
	reg 		[8:0] 	sum;
	
	always @(start,counter,current_state)
	begin
		case (current_state)
			`WAITING_START: begin
				if (start) begin
					next_state<=`INITIALIZING;
				end	
			end
			`INITIALIZING: begin
				next_state<=`ADD_SHIFT;
			end
			`ADD_SHIFT: begin
				if(counter==2'b11) begin
					next_state<=`OUTBUS_A;
				end
			end
			`OUTBUS_A: begin
				next_state<=`OUTBUS_Q;
			end
			`OUTBUS_Q:begin
				next_state<=`DONE;
			end
			`DONE:;
			default: next_state<=`INITIALIZING;
		endcase
	end		
			
	always @(posedge clk or posedge reset)
	begin
		if(reset) begin
			current_state<=`WAITING_START;
		end
		else begin
			current_state<=next_state;
		end
	end
	
	//used to calculate M1 and M2
	always @(AQ,M)
	begin
		M1<={M[7],M};//sign extend
		M2<=M1<<1;
		case (AQ[2:0])
			3'b001,3'b010: begin
				sum<=AQ[17:9]+M1;
			end
			3'b011: begin
				sum<=AQ[17:9]+M2;
			end
			3'b100:begin
				sum<=AQ[17:9]-M2;
			end
			3'b101,3'b110: begin
				sum<=AQ[17:9]-M1;
			end
			default: sum<=AQ[17:9];
			
		endcase
	
	end
	
	always @(posedge clk) begin
		case (current_state)
			`WAITING_START: ;
			`INITIALIZING: begin
				//initialize A with zeroes
				AQ[17:9]<=9'b0;
				//get Q from inbus;
				AQ[8:1]<=Q;
				//initialize counter
				counter<=2'b00;
				//initialize Q[-1]
				AQ[0]<=1'b0;
			end
			`ADD_SHIFT: begin
				//actually shift AQ register;
				AQ<={sum[8],sum[8],sum,AQ[8:2]};
				counter<=counter+2'b01;
			end
			`OUTBUS_A: begin
				outbus<=AQ[16:9];
			end
			`OUTBUS_Q: begin
				outbus<=AQ[8:1];
			end
			`DONE: ;
		endcase
	end
	
	
	assign busy = (current_state != `DONE && current_state!=`WAITING_START) ? 1'b1:1'b0;
endmodule
