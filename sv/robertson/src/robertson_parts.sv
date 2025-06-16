//---------------------------------------------------------------------------
// Design Name: Booth Multiplication Algorithm 
// File Name: booth_parts.sv
// Description: Implementation of the Booth Multiplication Algorithm
// Version History
// * June 9, 2025 (sebastian ardelean): Finished the implementation 
// --------------------------------------------------------------------------
module dff (
	    input logic		     clk,
	    input logic		     rst_n,
	    input logic d,
	    output logic q
    );

   always_ff @(posedge clk or negedge rst_n) begin
      if (!rst_n)
	q <= 1'b0;
      else
	q <= d;
   end
endmodule


module mux2 #(parameter WIDTH = 8)
             (input  logic [WIDTH-1:0] d0, d1, 
              input  logic             s, 
              output logic [WIDTH-1:0] y);

  assign y = s ? d1 : d0; 
endmodule

module and3 (input logic  a,
	     input logic  b,
	     input logic  c,
	     output logic y
	     );
   assign y = (a & b & c);   
endmodule // and

module and2 (input logic  a,
             input logic  b,
             output logic y
              );
   assign y = (a & b);
   
endmodule //and2

module or2 (input logic a,
             input logic b,
             output logic y
             );
   assign y = (a | b);
   
endmodule //or2


module xorn #(parameter WIDTH=8) 
   (input logic [WIDTH-1:0]  a,
    input logic		     b,
    output logic [WIDTH-1:0] y);
   
   assign y = a ^ {WIDTH{b}};
   
endmodule

module adder #(parameter WIDTH = 8) (
		    input logic cin,
		    input logic signed [WIDTH-1:0] a,
		    input logic signed [WIDTH-1:0] b,
		    output logic signed [WIDTH-1:0] sum
		    );
   always_comb begin
      sum = a + b + cin;
   end
endmodule
      
module tristate_buffer_bus #(parameter WIDTH = 8)
   (
    input logic [WIDTH-1:0] data_in,
    input logic enable,
    output tri [WIDTH-1:0] data_out
    );
   assign data_out = (enable)?data_in : 'z;
   
endmodule




module register #(parameter WIDTH = 8)
   (
    input logic		     clk,
    input logic		     rst_n,
    input logic              load_en,
    input logic		     shift_en,
    input logic		     shift_in,
    input logic [WIDTH-1:0]  d,
    output logic [WIDTH-1:0] q
    );

   logic [WIDTH-1:0] shift_mux_out;

   logic [WIDTH-1:0] load_mux_out;
   
   
   genvar	     i;
   
   generate
      for (i = 0; i < WIDTH; i++) begin : gen_reg

	 logic shift_src;
       
	 if (i == WIDTH-1)
	   assign shift_src = shift_in;
	 else
	   assign shift_src = q[i+1];
	 

	 mux2 #(1) mux_shift(
			.d0(q[i]),
			.d1(shift_src),
			.s(shift_en),
			.y(shift_mux_out[i]));
	 mux2 #(1) mux_load (
			.d0(shift_mux_out[i]),
			.d1(d[i]),
			.s(load_en),
			.y(load_mux_out[i]));
	 
	 
	 
	 dff ff_inst (
                      .clk(clk),
                      .rst_n(rst_n),
                      .d(load_mux_out[i]),
                      .q(q[i])
		      );
      end
    endgenerate

endmodule


module counter_3bits (
		      input logic clk,
		      input logic rst_n,
		      input logic en,
		      output logic [2:0] count
		      );
   always_ff @(posedge clk or negedge rst_n) begin
      if (!rst_n)
	count <= 3'b000;
      else if (en)
	count <= count + 1;

   end
endmodule
  


module cu (
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
endmodule
  
