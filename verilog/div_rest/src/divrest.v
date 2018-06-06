`include "src/fsm_states.v"
module divrest
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
	
	
	
  reg 		[2:0] 	counter;
	
	reg 		[2:0] 	current_state;
	reg		[2:0]	next_state;
	
  	reg 		[16:0] 	AQ;
	
	reg 		[8:0] 	M1;
	
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
				next_state<=`SUBTRACT;
			end
			`SUBTRACT: begin
              if(counter==3'b111) begin
					next_state<=`OUTBUS_Q;
				end
			end
			`OUTBUS_Q: begin
				next_state<=`OUTBUS_A;
			end
			`OUTBUS_A:begin
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
	

	always @(posedge clk) begin
		case (current_state)
			`WAITING_START: ;
			`INITIALIZING: begin
				//initialize A with zeroes
              	AQ[16:8]<=9'b0;
				//get Q from inbus;
              	AQ[7:0]<=Q;
				//initialize counter
				counter<=3'b000;
				//initialize Q[-1]
				M1<={M[7],M};
              	
			end
			`SUBTRACT: begin
				//actually shift AQ register;
             
				//AQ<=AQ<<1;
              	AQ<={AQ[15:1],1'b0};
	            AQ<=AQ[16:8]-M1;
              	if(AQ[16]==0) begin
                  AQ[0]=1'b1;
                end
              	else begin
                  AQ[0]=1'b0;
                  AQ<=AQ[16:8]+M1;
                end
              $display(" Count %d A %b\t Q %b\n M %b",counter,AQ[16:7],AQ[7:0],M1);
				counter<=counter+3'b001;
			end
			`OUTBUS_A: begin
              	outbus<=AQ[15:8];
			end
			`OUTBUS_Q: begin
              outbus<=AQ[7:0];
			end
			`DONE: ;
		endcase
	end
	
	
	assign busy = (current_state != `DONE && current_state!=`WAITING_START) ? 1'b1:1'b0;
endmodule