//---------------------------------------------------------------------------
// Design Name: Booth Multiplication Algorithm 
// File Name: mux.sv
// Description: Implementation of the Booth Multiplication Algorithm
// Version History
// * June 9, 2025 (sebastian ardelean): Finished the implementation 
// --------------------------------------------------------------------------
`include "defs.svh"

module mux2 #(parameter WIDTH = 8)
             (input  logic [WIDTH-1:0] d0, d1, 
              input  logic             s, 
              output logic [WIDTH-1:0] y);

  assign y = s ? d1 : d0; 
endmodule //mux2
