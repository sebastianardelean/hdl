//--------------------------------------------------------------------------
// Design Name: Booth Multiplication Algorithm 
// File Name: cu_robertson.sv
// Description: Implementation of the Booth Multiplication Algorithm
// Version History
// * June 9, 2025 (sebastian ardelean): Finished the implementation 
// -------------------------------------------------------------------------
`timescale 1ns/1ps
module cu_robertson (
	   input logic	clk,
	   input logic	start,
	   input logic	rst_n,
	   input logic	count,
	   
	   input logic	q0,
   
	   output logic	stop,
	   output logic [7:0] c
	   );
   typedef enum logic [4:0] {
			     IDLE,
			     LOAD_M,
			     LOAD_Q,
			     SCAN,
                             RIGHTSHIFT,
			     TEST_COUNT,
                             TEST_Q,
			     OUTPUT_A,
			     OUTPUT_Q,
			     STOP
			     } state_t;
   state_t state, next;

   always_ff @(posedge clk or negedge rst_n) begin
      if (!rst_n)
	state <= IDLE;
      else
	state <= next;
   end
      
   
   always_comb begin
      next = state;
      stop = 0;
      c = 8'b0;
      case (state)
	IDLE: begin
	   if (start)
	     next = LOAD_M;
	end
	LOAD_M: begin
	   c[0] = 1;
	   next = LOAD_Q;
	end
	LOAD_Q: begin
	   c[1] = 1;
	   next = SCAN;
	end
	SCAN: begin
	   if (q0 == 1'b1) begin
              c[2] = 1;                           
           end
           next = RIGHTSHIFT;
	end
	RIGHTSHIFT: begin
	   c[3] = 1;
	   next = TEST_COUNT;	   
      	end
	TEST_COUNT: begin
	   if (count)
	     next = TEST_Q;
	   else begin
              c[4] = 1;
              next = SCAN;             
           end
	end
        TEST_Q: begin
           if (q0 == 1'b1) begin
              c[2] = 1;
              c[5] = 1;
              next = OUTPUT_A;
           end
           next = OUTPUT_A;
        end
	OUTPUT_A:begin
	   c[6] = 1;
	   c[7] = 0;
	   next = OUTPUT_Q;
	end
	OUTPUT_Q:begin
	   c[6] = 0;
	   c[7] = 1;
	   next = STOP;
	end 
	STOP: begin
	   stop = 1;  
	   next = IDLE;
	end
	
      endcase //case
   end //always_comb
endmodule //cu_robertson
