//--------------------------------------------------------------------------
// Design Name: Sign Extend
// File Name: sign_extend.sv
// Description: Implementation of a sign extend module.
// Version History
// * July 1, 2025 (sebastian ardelean): Finished the implementation 
// -------------------------------------------------------------------------
`timescale 1ns/1ps
module signe (
              input logic [7:0]  in,
              output logic [8:0] out
              );
   assign out = {in[7],in};
   

endmodule // lshift
