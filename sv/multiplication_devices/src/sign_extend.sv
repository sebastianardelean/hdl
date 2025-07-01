`timescale 1ns/1ps
module signe (
              input logic [7:0]  in,
              output logic [8:0] out
              );
   assign out = {in[7],in};
   

endmodule // lshift
