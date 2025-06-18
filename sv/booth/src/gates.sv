//---------------------------------------------------------------------------
// Design Name: Booth Multiplication Algorithm 
// File Name: gates.sv
// Description: Implementation of the Booth Multiplication Algorithm
// Version History
// * June 9, 2025 (sebastian ardelean): Finished the implementation 
// --------------------------------------------------------------------------
`include "defs.svh"

module and3 ( input logic  a,
	       input logic  b,
	       input logic c,
	       output logic y
	     );
   assign y = (a & b & c);   
endmodule // and

module xorn #(parameter WIDTH=8) 
   (input logic [WIDTH-1:0]  a,
    input logic		     b,
    output logic [WIDTH-1:0] y);
   
   assign y = a ^ {WIDTH{b}};
   
endmodule //gates
