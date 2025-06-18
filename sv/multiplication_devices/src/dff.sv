//--------------------------------------------------------------------------
// Design Name: Booth Multiplication Algorithm 
// File Name: dff.sv
// Description: Implementation of the Booth Multiplication Algorithm
// Version History
// * June 9, 2025 (sebastian ardelean): Finished the implementation 
// -------------------------------------------------------------------------
`timescale 1ns/1ps
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
endmodule //dff
