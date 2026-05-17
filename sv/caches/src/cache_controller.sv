`include "defs.svh"

`timescale 1ns/1ps
module cache_controller
  #(
    //cache parameters
    parameter SIZE = 32 * 1024 * 8,
    parameter KWAYS = 4,
    parameter NSETS = 256,
    parameter BLOCK_SIZE = 256,
    parameter WIDTH = 21,
    parameter INDEX_WIDTH = 8,
    parameter TAG_WIDTH = 10,
    parameter OFFSET_WIDTH = 3,
    parameter WORD_SIZE = 32,
)
   (
    input logic                     clock,
    input logic [WIDTH - 1:0]       address,  // address from CPU
    input logic [WORD_SIZE - 1:0]   din,      // data from CPU on write
    input logic [BLOCK_SIZE -1:0]   mdin,     // data from memory
    input logic                     rden,     // 1 if load instruction (read enable)
    input logic                     wren,     // 1 if store instruction (write enable)
    output logic                    hit,      // 1 if hit, 0 if miss
    output logic [WORD_SIZE - 1:0]  dout,     // data out from cache to cpu
    output logic [BLOCK_SIZE - 1:0] mdout,    // data out from cache to memory
    output logic [WIDTH - 1:0]      maddress, // memory address
    output logic                    mrden,    // memory read enable
    output logic                    mwren,    // memory write enable
    
    );


   
   // WAY 0
   logic  valid_w0 [0:NSETS - 1];
   logic  dirty_w0 [0:NSETS -1];
   logic [1:0] lru_w0 [0:NSETS - 1];
   logic [TAG_WIDTH - 1:0] tag_w0 [0:NSETS - 1];
   logic [BLOCK_SIZE - 1:0] mem_data_w0 [0:NSETS - 1];
   
   // WAY 1
   logic  valid_w1 [0:NSETS - 1];
   logic  dirty_w1 [0:NSETS -1];
   logic [1:0]  lru_w1 [0:NSETS - 1];
   logic [TAG_WIDTH - 1:0] tag_w1 [0:NSETS - 1];
   logic [BLOCK_SIZE - 1:0] mem_data_w1 [0:NSETS - 1];

   // WAY 2
   logic  valid_w2 [0:NSETS - 1];
   logic  dirty_w2 [0:NSETS -1];
   logic [1:0] lru_w2 [0:NSETS - 1];
   logic [TAG_WIDTH - 1:0] tag_w2 [0:NSETS - 1];
   logic [BLOCK_SIZE - 1:0] mem_data_w2 [0:NSETS - 1];

   // WAY 3
   logic  valid_w3 [0:NSETS - 1];
   logic  dirty_w3 [0:NSETS -1];
   logic [1:0] lru_w3 [0:NSETS - 1];
   logic [TAG_WIDTH - 1:0] tag_w3 [0:NSETS - 1];
   logic [BLOCK_SIZE - 1:0] mem_data_w3 [0:NSETS - 1];


   integer                  k;
   
   initial begin
      for (k = 0; k < NSETS; k = k + 1) begin
         valid_w0[k] = 0;
         valid_w1[k] = 0;
         valid_w2[k] = 0;
         valid_w3[k] = 0;
         
         dirty_w0[k] = 0;
         dirty_w1[k] = 0;
         dirty_w2[k] = 0;
         dirty_w3[k] = 0;

         lru_w0[k] = 2'b00;
         lru_w1[k] = 2'b00;
         lru_w2[k] = 2'b00;
         lru_w3[k] = 2'b00;
      end // for (k = 0; k < NSETS; k = k + 1)
   end // initial begin


   // ----------------------------------------------------
   // HIT detection
   // ----------------------------------------------------
   logic hit_w0;
   logic hit_w1;
   logic hit_w2;
   logic hit_w3;
   always_comb begin
      hit_w0 = 
               (valid_w0[address[`INDEX_FIELD]] && (tag_w0[address[`INDEX_FIELD]] == address[`TAG_FIELD]));
      hit_w1 = 
               (valid_w1[address[`INDEX_FIELD]] && (tag_w1[address[`INDEX_FIELD]] == address[`TAG_FIELD]));
      hit_w2 = 
               (valid_w2[address[`INDEX_FIELD]] && (tag_w2[address[`INDEX_FIELD]] == address[`TAG_FIELD]));
      hit_w3 = 
               (valid_w3[address[`INDEX_FIELD]] && (tag_w3[address[`INDEX_FIELD]] == address[`TAG_FIELD]));
      
   end

   assign hit = hit_w0 | hit_w1 | hit_w2 | hit_w3;
   

   
   // ----------------------------------------------------
   // Cache Read
   // ----------------------------------------------------
   always_ff @(posedge clock) begin
      if (rden) begin
         logic [BLOCK_SIZE - 1:0] selected_bank;
         
         if (hit_w0)
           selected_bank = mem_data_w0[`INDEX_FIELD];
         else if (hit_w1)
           selected_bank = mem_data_w1[`INDEX_FIELD];
         else if (hit_w2)
           selected_bank = mem_data_w2[`INDEX_FIELD];
         else if (hit_w3)
           selected_bank = mem_data_w3[`INDEX_FIELD];

         dout = selected_bank[address[`OFFSET_FIELD]];

      end // if (rden)
      



   


      
      
     


                

           
   
         
         

   

endmodule 
