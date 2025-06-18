//--------------------------------------------------------------------------
// Design Name: Robertson CU (sequence counter)
// File Name: cu.sv
// Description: Implementation of the Robertson CU
// Version History
// * June 9, 2025 (sebastian ardelean): Finished the implementation 
// -------------------------------------------------------------------------
module cu (
           input logic start,
           input logic q0,
           input logic count,
           output logic [7:0] c,
           output logic stop
           );
   
endmodule // cu



module rs_ff (
              input logic  clk,
              input logic rst_n, // Active low, reset
              input logic  r,
              input logic  s,
              output logic q,
              output logic qn
              );
   always_ff @(posedge clk or negedge rst_n) begin
      if (!rst_n)
        q <= 0;
      else begin
         case ({r,s})
           2'b00:;//HOLD
           2'b01: q <= 1; //SET
           2'b10: q <= 0; //RESET
           2'b11: q <= 1'bx; //INVALID
         endcase // case ({r,s})
         
      end // else: !if(!rst_n)
   end // always_ff @ (posedge clk or negedge rst_n)
   assign qn = ~q;
   
endmodule // rs_ff

module mod2_counter (
                     input logic clk,
                     input logic rst_n,
                     output logic [1:0] q
                     );

   always_ff @(posedge clk or negedge rst_n) begin
      if (!rst_n)
        q <= 2'b00;
      else
        q <= (q == 2'b00)? 2'b01 : 2'b00;     
   end
   
endmodule // mod2_counter
