//--------------------------------------------------------------------------
// Design Name: Multiplexer
// File Name: mux.sv
// Description: Implementation of the multiplexer
// Version History
// * May 17, 2026 (sebastian ardelean): Finished the implementation 
// -------------------------------------------------------------------------
`timescale 1ns/1ps

module mux4_1 #(parameter WIDTH = 8)
   (input logic [WIDTH-1:0]  d0, d1, d2,d3
    input logic [1:0]        s, 
    output logic [WIDTH-1:0] y);
   always_comb begin
      unique case (s)
        2'b00: y = d0;
        2'b01: y = d1;
        2'b10: y = d2;
        2'b11: y = d3;
      endcase // unique case (s)
   end

endmodule // mux4_1


module mux8_1 #(parameter WIDTH = 8)
   (input logic [WIDTH-1:0]  d0, d1, d2, d3, d4, d5, d6, d7,
    input logic [2:0]        s, 
    output logic [WIDTH-1:0] y);
   always_comb begin
      unique case (s)
        3'b000: y = d0;
        3'b001: y = d1;
        3'b010: y = d2;
        3'b011: y = d3;
        3'b100: y = d4;
        3'b101: y = d5;
        3'b110: y = d6;
        3'b111: y = d7;

      endcase // unique case (s)
   end

endmodule // mux8_1
