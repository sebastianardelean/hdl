//--------------------------------------------------------------------------
// Design Name: Robertson Multiplication Algorithm 
// File Name: robertson.sv
// Description: Implementation of the Robertson Multiplication Algorithm
// Version History
// * June 9, 2025 (sebastian ardelean): Finished the implementation 
// -------------------------------------------------------------------------
`timescale 1ns/1ps
module robertson (
	      input logic	       clk,
	      input logic	       enable,
	      input logic	       rst_n,
	      input logic signed [7:0] inbus,
	      output logic	       done,
	      output logic [7:0]      outbus
	      
	      );
   //control signals
   logic [7:0] c;
   logic       stop;
   
   tri [7:0]  output_buffer;
    
   // Register Outputs
   logic signed [7:0] A_reg_out, M_reg_out, Q_reg_out;
   logic              F_reg_out;
   
   // Register Inputs
   logic	      F_reg_in;
   logic signed [7:0] M_reg_in;
   logic signed [7:0] Q_reg_in;
   // Count
   logic [2:0] count_out;
   logic       count_and_out;

   // Other intermediate signals
   logic signed [7:0] adder_out;
   logic [7:0]	      xor_out;

   logic              and_out;
   logic              or_out;
   
   
   
   cu_robertson ctrl_unit (
		 .clk(clk),
		 .start(enable),
		 .rst_n(rst_n),
		 .count(count_and_out),
		 .q0(Q_reg_out[0]),
		 .stop(stop),
		 .c(c)
		 );
   
   assign done = stop;
  
   counter_nbits #(.WIDTH(3)) counter (
			  .clk(clk),
			  .rst_n(rst_n),
			  .en(c[4]),
			  .count(count_out)
			  );

   and3_gate and_counter (
		       .a(count_out[0]),
		       .b(count_out[1]),
		       .c(count_out[2]),
		       .y(count_and_out)
		       );
   
   
   register #(.WIDTH(8)) reg_A (
				.clk(clk),
				.rst_n(rst_n),
				.load_en(c[2]),
				.shift_en(c[3]),
				.shift_in(F_reg_out),
				.d(adder_out),
				.q(A_reg_out)
				);
   
   
   register #(.WIDTH(8)) reg_Q (
			    .clk(clk),
			    .rst_n(rst_n),
			    .load_en(c[1]),
			    .shift_en(c[3]),
			    .shift_in(A_reg_out[0]),
			    .d(Q_reg_in),
			    .q(Q_reg_out)
			    );

   
   register #(.WIDTH(1)) reg_F (
                                .clk(clk),
                                .rst_n(rst_n),
                                .load_en(c[0]),
                                .shift_en(c[2]),
                                .shift_in(or_out),
                                .d(1'b0),
                                .q(F_reg_out)
                                );
   

   register #(.WIDTH(8)) reg_M (
				.clk(clk),
				.rst_n(rst_n),
				.load_en(c[0]),
				.shift_en(1'b0),
				.shift_in(1'b0),
				.d(M_reg_in),
				.q(M_reg_out)
				);
   and2_gate and2_gate (
                   .a(M_reg_out[7]),
                   .b(Q_reg_out[0]),
                   .y(and_out)
                   );

   or2_gate or2_gate (  
                 .a(and_out),
                 .b(F_reg_out),
                 .y(or_out)
                 );
   

   xorn_gate #(8) xor_instance (
			   .a(M_reg_out),
			   .b(c[5]),
			   .y(xor_out)
			   );

   adder #(8) adder_instance (
			      .cin(c[5]),
			      .a(A_reg_out),
			      .b(xor_out),
			      .sum(adder_out)
			      );

   // Tri-state buffers

   tristate_buffer_bus #(8) M_in (
				   .data_in(inbus),
				   .enable(c[0]),
				   .data_out(M_reg_in)
				   );

   tristate_buffer_bus #(8) Q_in (
				   .data_in(inbus),
				   .enable(c[1]),
				   .data_out(Q_reg_in)
				   );
   tristate_buffer_bus #(8) A_out (
				   .data_in(A_reg_out),
				   .enable(c[6]),
				   .data_out(output_buffer)
				   );

   tristate_buffer_bus #(8) Q_out (
				   .data_in(Q_reg_out),
				   .enable(c[7]),
				   .data_out(output_buffer)
				   );

   assign outbus = output_buffer;
   
   

  
endmodule // robertson
