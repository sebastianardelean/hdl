//--------------------------------------------------------------------------
// Design Name: Booth Multiplication Algorithm 
// File Name: buffer.sv
// Description: Implementation of the Booth Multiplication Algorithm
// Version History
// * June 9, 2025 (sebastian ardelean): Finished the implementation 
// -------------------------------------------------------------------------
`timescale 1ns/1ps
module tristate_buffer_bus #(parameter WIDTH = 8)
   (
    input logic [WIDTH-1:0] data_in,
    input logic enable,
    output tri [WIDTH-1:0] data_out
    );
   assign data_out = (enable)?data_in : 'z;
   
endmodule //tristate_buffer_bus
