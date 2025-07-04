//--------------------------------------------------------------------------
// Design Name: Restoring division
// File Name: div_restoring.sv
// Description: Implementation of a restoring divider
// Version History
// * July 2, 2025 (sebastian ardelean): Finished the implementation 
// -------------------------------------------------------------------------

`timescale 1ns/1ps
module div_restoring (
                      input logic        clk,
                      input logic        rst_n,
                      input logic        enable,
                      input logic [7:0]  inbus,
                      output logic       done,
                      output logic [7:0] outbus
                      );
   logic [9:0] c;

   tri [7:0]   output_buffer;

   logic signed [7:0] A_in, M_in, Q_in;

   logic signed [8:0] A_reg, M_reg9;

   logic signed [7:0] Q_reg, M_reg;

   logic signed [8:0] adder_out, A_reg_in;
   logic signed [8:0] xor_out;

   logic              Q_0;
   
   

   logic [2:0]        counter_out;
   logic              count_and_out;
   
   
   tristate_buffer_bus #(8) A_buffer_in (
                                         .data_in(inbus),
                                         .enable(c[0]),
                                         .data_out(A_in)
                                         );

   tristate_buffer_bus #(8) Q_buffer_in (
                                         .data_in(inbus),
                                         .enable(c[1]),
                                         .data_out(Q_in)
                                         );

   tristate_buffer_bus #(8) M_buffer_in (
                                         .data_in(inbus),
                                         .enable(c[2]),
                                         .data_out(M_in)
                                         );
   cu_div_restoring ctrl_unit (
                               .clk(clk),
                               .start(enable),
                               .rst_n(rst_n),
                               .count(count_and_out),
                               .s(A_reg[8]),
                               .q_0(Q_0),
                               .stop(done),
                               .c(c)
                               );
   counter_nbits #(3) counter (
                               .clk(clk),
                               .rst_n(rst_n),
                               .en(c[6]),
                               .count(counter_out)
                               );

   and3_gate and_counter (
                          .a(counter_out[0]),
                          .b(counter_out[1]),
                          .c(counter_out[2]),
                          .y(count_and_out)
                          );

   register #(9) reg_A (
                        .clk(clk),
                        .rst_n(rst_n),
                        .load_en(c[0]|c[4]),
                        .shift_en(c[3]),
                        .sr(1'b0),
                        .sl(Q_reg[7]),
                        .shift_dir(1'b0),
                        .d(A_reg_in),
                        .q(A_reg)
                        );

   register #(8) reg_Q (
                        .clk(clk),
                        .rst_n(rst_n),
                        .load_en(c[1]),
                        .shift_en(c[9]),
                        .sr(1'b0),
                        .sl(Q_0),
                        .shift_dir(1'b0),
                        .d(Q_in),
                        .q(Q_reg)
                        );
   
   
   
   register #(8) reg_M (
                        .clk(clk),
                        .rst_n(rst_n),
                        .load_en(c[2]),
                        .shift_en(1'b0),
                        .sr(1'b0),
                        .sl(1'b0),
                        .shift_dir(1'b0),
                        .d(M_in),
                        .q(M_reg)
                        );
   mux2 #(9) mux_A (
                    .d0({A_in[7],A_in}),
                    .d1(adder_out),
                    .s(c[4]),
                    .y(A_reg_in)
                    );

   signe reg_M_se (
                   .in(M_reg),
                   .out(M_reg9)
                   );
   
   
   xorn_gate #(9) xor_instance (
                                .a(M_reg9),
                                .b(c[5]),
                                .y(xor_out)
                                );
   
   adder #(9) adder_instance(
                             .cin(c[5]),
                             .a(A_reg),
                             .b(xor_out),
                             .sum(adder_out)
                             );

   
   tristate_buffer_bus #(8) A_buffer_out (
                                          .data_in(A_reg[7:0]),
                                          .enable(c[7]),
                                          .data_out(output_buffer)
                                          );
   
   tristate_buffer_bus #(8) Q_buffer_out (
                                          .data_in(Q_reg),
                                          .enable(c[8]),
                                          .data_out(output_buffer)
                                          );
   
   
   assign outbus = output_buffer;
   
   
endmodule // div_restoring
