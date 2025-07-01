`timescale 1ns/1ps
module lshift (
               input logic [7:0] in,
               output logic [8:0] out
               );
   assign out = {in,1'b0};
   

endmodule // lshift


