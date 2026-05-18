`include "defs.svh"

`timescale 1ns/1ps

module cache_controller
  #(
    parameter BLOCK_SIZE = 256,
    parameter ADDRESS_WIDTH = 21,
    parameter INDEX_WIDTH = 10,
    parameter TAG_WIDTH = 8,
    parameter OFFSET_WIDTH = 3,
    parameter WORD_SIZE = 32,
    parameter NBLOCKS = 1024
)
   (
    input logic                                  clock,
    input logic                                  rst_n,
    input logic [ADDRESS_WIDTH - 1:0]            caddress, // address from CPU
    input logic [WORD_SIZE - 1:0]                cdin,     // data from CPU on write
    input logic [BLOCK_SIZE -1:0]                mdin,     // data from memory
    input logic                                  rden,     // 1 if load instruction (read enable)
    input logic                                  wren,     // 1 if store instruction (write enable)
    output logic                                 hit,      // 1 if hit, 0 if miss
    output logic [WORD_SIZE - 1:0]               cdout,    // data out from cache to cpu
    output logic [BLOCK_SIZE - 1:0]              mdout,    // data out from cache to memory
    output logic [TAG_WIDTH + INDEX_WIDTH - 1:0] maddress, // memory address
    output logic                                 mrden,    // memory read enable
    output logic                                 mwren     // memory write enable
    );


   typedef enum logic [2:0] 
     {
      STATE_IDLE,
      STATE_READ_HIT,
      STATE_READ_MISS,
      STATE_ALLOCATE,
      STATE_REPLACE,
      STATE_WRITE_HIT,
      STATE_WRITE_MISS
      } state_t;

   state_t current_state, next_state;
   

   localparam TAG_MSB = 20;
   localparam TAG_LSB = 13;
   localparam INDEX_MSB = 12;
   localparam INDEX_LSB = 3;
   localparam BLOCK_OFFSET_MSB = 2;
   localparam BLOCK_OFFSET_LSB = 0;
   
               





   
   logic cache_valid[0:NBLOCKS - 1];
   logic cache_dirty[0:NBLOCKS - 1];
   logic [TAG_WIDTH - 1:0] cache_tag[0:NBLOCKS - 1];
   logic [BLOCK_SIZE - 1:0] cache_mem[0:NBLOCKS - 1];
   

   // ------------------------------------------------
   // Internal parameters
   // ------------------------------------------------
   

   logic                    _hit;
   logic                    _mwren;
   logic [BLOCK_SIZE - 1:0] _mdout;
   logic [WORD_SIZE - 1:0]  _cdout;
   logic [TAG_WIDTH + INDEX_WIDTH - 1:0] _maddress;
   

   assign hit = _hit;

   assign mrden =
                 ((cache_valid[caddress[INDEX_MSB:INDEX_LSB]] == 0) && (cache_tag[caddress[INDEX_MSB:INDEX_LSB]] != caddress[TAG_MSB:TAG_LSB]));

   assign mwren = _mwren;
   assign mdout = _mdout;
   assign maddress = _maddress;

   integer k;
   initial begin
      for (k = 0; k <= NBLOCKS; k = k + 1) begin
         cache_valid[k] = 0;
         cache_dirty[k] = 0;
      end
   end

   always_ff @(posedge clock) begin
      if (!rst_n) begin
         current_state <= STATE_IDLE;
         for (k = 0; k <= NBLOCKS; k = k + 1) begin
            cache_valid[k] = 0;
            cache_dirty[k] = 0;
         end
      end
      else begin
        current_state <= next_state;
      end
   end

   // ------------------------------------------------
   // Hit check
   // ------------------------------------------------           
   always_comb begin 
     _hit = (cache_valid[caddress[INDEX_MSB:INDEX_LSB]] && (cache_tag[caddress[INDEX_MSB:INDEX_LSB]] == caddress[TAG_MSB:TAG_LSB]));
   end
   
   always_comb begin
      unique case (current_state)
        STATE_IDLE: begin
           if (rden) begin
              if (_hit)
                next_state = STATE_READ_HIT;
              else
                next_state = STATE_READ_MISS;
           end
           if (wren) begin
              if (_hit)
                next_state = STATE_WRITE_HIT;
              else
                next_state = STATE_WRITE_MISS;
           end
        end
        STATE_READ_HIT: begin
           _mwren = 0;
           _cdout = cache_mem[caddress[INDEX_MSB:INDEX_LSB]][caddress[BLOCK_OFFSET_MSB:BLOCK_OFFSET_LSB]];
           next_state = STATE_IDLE;
        end
        STATE_READ_MISS: begin
           if (cache_dirty[caddress[INDEX_MSB:INDEX_LSB]])
             next_state = STATE_REPLACE;
           else 
             next_state = STATE_ALLOCATE;           
        end
        STATE_ALLOCATE: begin
           _mwren = 0;
           _maddress = {caddress[TAG_MSB:TAG_LSB],caddress[INDEX_MSB:INDEX_LSB]};
           cache_mem[caddress[INDEX_MSB:INDEX_LSB]] = mdin;
           cache_tag[caddress[INDEX_MSB:INDEX_LSB]] = caddress[TAG_MSB:TAG_LSB];
           cache_valid[caddress[INDEX_MSB:INDEX_LSB]] = 1;
           cache_dirty[caddress[INDEX_MSB:INDEX_LSB]] = 0;
           if (rden)
             next_state = STATE_READ_HIT;
           else if (wren)
             next_state = STATE_WRITE_HIT;
        end
        STATE_REPLACE: begin
           _mwren = 1;
           _maddress = {cache_tag[caddress[INDEX_MSB:INDEX_LSB]],caddress[INDEX_MSB:INDEX_LSB]};
           _mdout = cache_mem[caddress[INDEX_MSB:INDEX_LSB]];
           next_state = STATE_ALLOCATE;   
        end
        STATE_WRITE_HIT: begin
           _cdout = {WORD_SIZE{1'b0}};
           cache_mem[caddress[INDEX_MSB:INDEX_LSB]][caddress[BLOCK_OFFSET_MSB:BLOCK_OFFSET_LSB]] = cdin;
           cache_dirty[caddress[INDEX_MSB:INDEX_LSB]] = 1;
           next_state = STATE_IDLE;
        end
        STATE_WRITE_MISS: begin
           if (cache_dirty[caddress[INDEX_MSB:INDEX_LSB]])
             next_state = STATE_REPLACE;
           else
             next_state = STATE_ALLOCATE;
           
        end     
      endcase // case (current_state)
      
   end // always_comb
      
 endmodule // cache_controller
