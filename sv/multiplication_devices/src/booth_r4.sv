//--------------------------------------------------------------------------
// Design Name: Booth Radix 4 Multiplication Algorithm 
// File Name: booth_r4.sv
// Description: Implementation of the Booth Multiplication Algorithm
// Version History
// * June 30, 2025 (sebastian ardelean): Finished the implementation 
// -------------------------------------------------------------------------
`timescale 1ns/1ps
module booth4 (
               input logic clk,
               input logic enable,
               input logic rst_n,
               input logic signed [7:0] inbus,
               output logic done,
               output logic [7:0] outbus
               );

   //control signals
   logic [8:0] c;
   logic       stop;
   
   tri [7:0]   output_buffer;

   logic signed [8:0] A_reg, M_reg8,M_reg_se,M_reg_sl;
   logic signed [7:0] M_reg;
   
   logic signed [7:0] Q_reg;
   logic              Qm;
   logic signed [7:0] M_in;
   logic signed [7:0] Q_in;

   logic [1:0]        counter_out;
   logic              count_and_out;

   //Other signals
   logic signed [8:0] adder_out;
   logic [8:0]        xor_out;

   logic signed [7:0] A_outbus;
   logic signed [7:0] Q_outbus;
   
               
   //tristate input

   tristate_buffer_bus #(8) M_buffer_in (
                                         .data_in(inbus),
                                         .enable(c[0]),
                                         .data_out(M_in)
                                         );
   tristate_buffer_bus #(8) Q_buffer_in (
                                         .data_in(inbus),
                                         .enable(c[1]),
                                         .data_out(Q_in)
                                         );

   cu_booth4 ctrl_unit(
                       .clk(clk),
                       .start(enable),
                       .rst_n(rst_n),
                       .count(count_and_out),
                       .q0(Q_reg[0]),
                       .q1(Q_reg[1]),
                       .qm(Qm),
                       .stop(stop),
                       .c(c)
                  );

   counter_nbits #(.WIDTH(2)) counter (
                                       .clk(clk),
                                       .rst_n(rst_n),
                                       .en(c[6]),
                                       .count(counter_out)
                                       );
   and2_gate and_counter (
                     .a(counter_out[0]),
                     .b(counter_out[1]),
                     .y(count_and_out)
                     );

   register #(.WIDTH(9)) reg_A (
                                .clk(clk),
                                .rst_n(rst_n),
                                .load_en(c[2]),
                                .shift_en(c[5]),
                                .shift_in(A_reg[8]),
                                .d(adder_out),
                                .q(A_reg)
                                );

   register #(.WIDTH(8)) reg_Q (
                                .clk(clk),
                                .rst_n(rst_n),
                                .load_en(c[1]),
                                .shift_en(c[5]),
                                .shift_in(A_reg[0]),
                                .d(Q_in),
                                .q(Q_reg)
                                );

   register #(.WIDTH(1)) reg_Qm (
                                 .clk(clk),
                                 .rst_n(rst_n),
                                 .load_en(c[0]),
                                 .shift_en(c[5]),
                                 .shift_in(Q_reg[0]),
                                 .d(1'b0),
                                 .q(Qm)
                                 );
   
   
   register #(.WIDTH(8)) reg_M (
                                .clk(clk),
                                .rst_n(rst_n),
                                .load_en(c[0]),
                                .shift_en(1'b0),
                                .shift_in(1'b0),
                                .d(M_in),
                                .q(M_reg)
                                );
   
   lshift reg_M_ls (.in(M_reg),
                    .out(M_reg_sl)
                    );

   signe reg_M_se (.in(M_reg),
                   .out(M_reg_se)
                   );
   

   mux2 #(9) mux_M (
                    .d0(M_reg_se),
                    .d1(M_reg_sl),
                    .s(c[4]),
                    .y(M_reg8)
                    );
     
   xorn_gate #(9) xor_instance (
                           .a(M_reg8),
                           .b(c[3]),
                           .y(xor_out)
                        );

   adder #(9) adder_instance (
                              .cin(c[3]),
                              .a(A_reg),
                              .b(xor_out),
                              .sum(adder_out)
                              );
   
   
   
   //tristate output
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
   
   

   
   assign done = stop;
   
   assign outbus = output_buffer;
endmodule // booth4

