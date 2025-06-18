//---------------------------------------------------------------------------
// Design Name: Booth Multiplication Algorithm 
// File Name: register.sv
// Description: Implementation of the Booth Multiplication Algorithm
// Version History
// * June 9, 2025 (sebastian ardelean): Finished the implementation 
// --------------------------------------------------------------------------
`include "defs.svh"
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

endmodule //register

  


