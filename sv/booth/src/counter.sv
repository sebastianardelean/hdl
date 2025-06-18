//---------------------------------------------------------------------------
// Design Name: Booth Multiplication Algorithm 
// File Name: counter.sv
// Description: Implementation of the Booth Multiplication Algorithm
// Version History
// * June 9, 2025 (sebastian ardelean): Finished the implementation 
// --------------------------------------------------------------------------

`include "defs.svh"
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
endmodule //counter_3bits
