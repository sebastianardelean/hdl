//--------------------------------------------------------------------------
// Design Name: Control unit Restoring division
// File Name: cu_div_restoring.sv
// Description: Implementation of the CU for restoring divider
// Version History
// * July 2, 2025 (sebastian ardelean): Finished the implementation 
// -------------------------------------------------------------------------

`timescale 1ns/1ps
module cu_div_nonrestoring (
                         input logic        clk,
                         input logic        start,
                         input logic        rst_n,
                         input logic        count,
                         input logic        s,
                         output logic       q_0,
                         output logic       stop,
                         output logic [9:0] c
                         );
   typedef enum logic [3:0] {
                             IDLE,
                             LOAD_A,
                             LOAD_Q,
                             LOAD_M,
                             LSHIFTA,
                             SUBTRACT,
                             ADD,
                             TEST_S,
                             TEST_COUNT,
                             CORRECTION,
                             OUTPUT_A,
                             OUTPUT_Q,
                             STOP
                             } state_t;

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
      c = 10'b0;
      case (state)
        IDLE: begin
           if (start)
             next = LOAD_A;
        end
        LOAD_A: begin
           c[0] = 1;
           next = LOAD_Q;
        end
        LOAD_Q: begin
           c[1] = 1;
           next = LOAD_M;
        end
        LOAD_M: begin
           c[2] = 1;
           next = LSHIFTA;
        end
        LSHIFTA: begin
           if (s == 1'b0)
              next = SUBTRACT;
           else
             next = ADD;              
           c[3] = 1;
        end
        SUBTRACT: begin
           c[4] = 1;
           c[5] = 1;
           next = TEST_S;
        end
        ADD: begin
           c[4] = 1;
           next = TEST_S;
        end
        TEST_S: begin
           if (s == 1'b0)
             q_0 = 1;
           else begin
              q_0 = 0;
           end
           c[9] = 1;
           next = TEST_COUNT;
        end
        TEST_COUNT: begin
           if (count)
             next = CORRECTION;
           else begin
              c[6] = 1;
              next = LSHIFTA;
           end
        end
        CORRECTION: begin
           if (s == 1'b1)
             c[4] = 1;
           next = OUTPUT_A;
        end
        OUTPUT_A: begin
           c[7] = 1;
           c[8] = 0;
           next = OUTPUT_Q;
        end
        OUTPUT_Q: begin
           c[7] = 0;
           c[8] = 1;
           next = STOP;
        end
        STOP: begin
           stop = 1;
           next = IDLE;
        end
      endcase // case (state)
      
      
   end // always_comb
   
   
   
endmodule // cu_div_restoring

                       
