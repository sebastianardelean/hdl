//--------------------------------------------------------------------------
// Design Name: Booth Radix 4 Multiplication Algorithm 
// File Name: cu_booth4.sv
// Description: Implementation of the Booth Multiplication Algorithm
// Version History
// * June 9, 2025 (sebastian ardelean): Finished the implementation 
// -------------------------------------------------------------------------

`timescale 1ns/1ps
module cu_booth4 (
                  input logic clk,
                  input logic start,
                  input logic rst_n,
                  input logic count,
                  input logic q0,
                  input logic q1,
                  input logic qm,
                  output logic stop,
                  output logic [8:0] c
                  );
   typedef enum logic [3:0] {
                             IDLE,
                             LOAD_M,
                             LOAD_Q,
                             SCAN,
                             RSHIFT_1,
                             RSHIFT_2,
                             CHECK_COUNT,
                             OUTPUT_A,
                             OUTPUT_Q,
                             STOP
                             }state_t;
   state_t state, next;

   always_ff @(posedge clk) begin
      if (!rst_n)
        state <= IDLE;
      else
        state <= next;
   end // always_ff

   always_comb begin
      next = state;
      stop = 0;
      c = 9'b0;
      case (state)
        IDLE:begin
           if (start)
             next = LOAD_M;
           
        end
        LOAD_M:begin
           c[0] = 1;
           next = LOAD_Q;
           
        end
        LOAD_Q:begin
           c[1] = 1;
           next = SCAN;
           
        end
        SCAN:begin
           case ({q1,q0,qm})
             3'b001,3'b010:begin
                c[2] = 1;
                
             end
             3'b101,3'b110:begin
                c[2] = 1;
                c[3] = 1;
                
             end
             3'b011:begin
                c[2] = 1;
                c[4] = 1;
                
             end
             3'b100:begin
                c[2] = 1;
                c[3] = 1;
                c[4] = 1;
                
             end
           endcase // case ({q1,q0,qm})
           next = RSHIFT_1;
             
        end
        RSHIFT_1:begin
           c[5] = 1;
           next = RSHIFT_2;
           
        end
        RSHIFT_2:begin
           c[5] = 1;
           next = CHECK_COUNT;
           
        end
        CHECK_COUNT:begin
           if (count)
             next = OUTPUT_A;
           else begin
              c[6] =1;
              next = SCAN;
           end
           
        end
        OUTPUT_A:begin
           c[7] = 1;
           c[8] = 0;
           next = OUTPUT_Q;
           
        end
        OUTPUT_Q:begin
           c[7] = 0;
           c[8] = 1;
           next = STOP;
           
        end
        STOP:begin
           stop = 1;
           next = IDLE;
           
        end
      endcase // case (state)
   end // always_comb
   
      
   
endmodule // cu_booth4
