`include "defs.svh"

`timescale 1ns/1ps

`define TAG_FIELD 20:11
`define INDEX_FIELD 10:3
`define BLOCK_OFFSET_FIELD 2:0

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
    parameter WORD_SIZE = 32
)
   (
    input logic                                  clock,
    input logic [WIDTH - 1:0]                    address,  // address from CPU
    input logic [WORD_SIZE - 1:0]                din,      // data from CPU on write
    input logic [BLOCK_SIZE -1:0]                mdin,     // data from memory
    input logic                                  rden,     // 1 if load instruction (read enable)
    input logic                                  wren,     // 1 if store instruction (write enable)
    output logic                                 hit,      // 1 if hit, 0 if miss
    output logic [WORD_SIZE - 1:0]               dout,     // data out from cache to cpu
    output logic [BLOCK_SIZE - 1:0]              mdout,    // data out from cache to memory
    output logic [TAG_WIDTH + INDEX_WIDTH - 1:0] maddress, // memory address
    output logic                                 mrden,    // memory read enable
    output logic                                 mwren     // memory write enable
    
    );

   typedef enum logic [1:0] 
     {
      STATE_IDLE,
      STATE_MISS
      }state_t;
   
   state_t current_state = STATE_IDLE;
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



   logic                    _hit;
   logic                    _mwren;
   logic [BLOCK_SIZE - 1:0] _mdout;
   logic [WORD_SIZE - 1:0]  _dout;
   logic [TAG_WIDTH + INDEX_WIDTH - 1:0] _maddres;
   

   logic [1:0]              _lru;
   
   


   
   assign hit = _hit;
   assign mrden =
                 !((valid_w0[address[`INDEX_FIELD]] && (tag_w0[address[`INDEX_FIELD]] == address[`TAG_FIELD]))
                   || (valid_w1[address[`INDEX_FIELD]] && (tag_w1[address[`INDEX_FIELD]] == address[`TAG_FIELD]))
                   || (valid_w2[address[`INDEX_FIELD]] && (tag_w2[address[`INDEX_FIELD]] == address[`TAG_FIELD]))
                   || (valid_w3[address[`INDEX_FIELD]] && (tag_w3[address[`INDEX_FIELD]] == address[`TAG_FIELD])));
   
   assign mwren = _mwren;
   assign mdout = _mdout;
   assign dout = _dout;
   assign maddress = _maddres;
   
   
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
   // State machine
   // ----------------------------------------------------
   always_ff @(posedge clock) begin
      unique case (current_state)
        STATE_IDLE: begin
           //reset write enable to memory
           _mwren = 0;

           //set hit value
           _hit = ((valid_w0[address[`INDEX_FIELD]] && (tag_w0[address[`INDEX_FIELD]] == address[`TAG_FIELD]))
                   || (valid_w1[address[`INDEX_FIELD]] && (tag_w1[address[`INDEX_FIELD]] == address[`TAG_FIELD]))
                   || (valid_w2[address[`INDEX_FIELD]] && (tag_w2[address[`INDEX_FIELD]] == address[`TAG_FIELD]))
                   || (valid_w3[address[`INDEX_FIELD]] && (tag_w3[address[`INDEX_FIELD]] == address[`TAG_FIELD])));

           if (~rden && ~wren) current_state = STATE_IDLE;
           else if (valid_w0[address[`INDEX_FIELD]] 
                    && (tag_w0[address[`INDEX_FIELD]] == address[`TAG_FIELD])) 
             begin
                // we have a hit in bank 0
                if (rden) _dout = mem_data_w0[address[`INDEX_FIELD]][address[`BLOCK_OFFSET_FIELD]];
                else if (wren) 
                  begin
                     // we have a write hit
                     _dout = {WORD_SIZE{1'b0}};
                     mem_data_w0[address[`INDEX_FIELD]][address[`BLOCK_OFFSET_FIELD]] = din;
                     dirty_w0[address[`INDEX_FIELD]] = 1;
                  end
                // Update LRU
                _lru = lru_w0[address[`INDEX_FIELD]];
                lru_w0[address[`INDEX_FIELD]] = 0;                
                if (lru_w1[address[`INDEX_FIELD]] < _lru)
                  lru_w1[address[`INDEX_FIELD]] = lru_w1[address[`INDEX_FIELD]] + 1;
                if (lru_w2[address[`INDEX_FIELD]] < _lru)
                  lru_w2[address[`INDEX_FIELD]] = lru_w2[address[`INDEX_FIELD]] + 1;
                if (lru_w3[address[`INDEX_FIELD]] < _lru)
                  lru_w3[address[`INDEX_FIELD]] = lru_w3[address[`INDEX_FIELD]] + 1;
             end // if (valid_w0[address[`INDEX_FIELD]]...         
           else if (valid_w1[address[`INDEX_FIELD]]
                    && (tag_w1[address[`INDEX_FIELD]] == address[`TAG_FIELD])) 
             begin
                // we have a hit in bank 0
                if (rden)
                  _dout = mem_data_w1[address[`INDEX_FIELD]][address[`BLOCK_OFFSET_FIELD]];
                else if (wren) 
                  begin
                     // we have a write hit
                     _dout = {WORD_SIZE{1'b0}};
                     mem_data_w1[address[`INDEX_FIELD]][address[`BLOCK_OFFSET_FIELD]] = din;
                     dirty_w1[address[`INDEX_FIELD]] = 1;
                  end
                // Update LRU
                _lru = lru_w1[address[`INDEX_FIELD]];
                lru_w1[address[`INDEX_FIELD]] = 0;                
                if (lru_w0[address[`INDEX_FIELD]] < _lru)
                  lru_w0[address[`INDEX_FIELD]] = lru_w0[address[`INDEX_FIELD]] + 1;
                if (lru_w2[address[`INDEX_FIELD]] < _lru)
                  lru_w2[address[`INDEX_FIELD]] = lru_w2[address[`INDEX_FIELD]] + 1;
                if (lru_w3[address[`INDEX_FIELD]] < _lru)
                  lru_w3[address[`INDEX_FIELD]] = lru_w3[address[`INDEX_FIELD]] + 1;
             end // if (valid_w1[address[`INDEX_FIELD]]...
           else if (valid_w2[address[`INDEX_FIELD]]
                    && (tag_w2[address[`INDEX_FIELD]] == address[`TAG_FIELD])) 
             begin
                // we have a hit in bank 0
                if (rden)
                  _dout = mem_data_w2[address[`INDEX_FIELD]][address[`BLOCK_OFFSET_FIELD]];
                else if (wren) 
                  begin
                     // we have a write hit
                     _dout = {WORD_SIZE{1'b0}};
                     mem_data_w2[address[`INDEX_FIELD]][address[`BLOCK_OFFSET_FIELD]] = din;
                     dirty_w2[address[`INDEX_FIELD]] = 1;
                  end
                // Update LRU
                _lru = lru_w2[address[`INDEX_FIELD]];
                lru_w2[address[`INDEX_FIELD]] = 0;                
                if (lru_w0[address[`INDEX_FIELD]] < _lru)
                  lru_w0[address[`INDEX_FIELD]] = lru_w0[address[`INDEX_FIELD]] + 1;
                if (lru_w1[address[`INDEX_FIELD]] < _lru)
                  lru_w1[address[`INDEX_FIELD]] = lru_w1[address[`INDEX_FIELD]] + 1;
                if (lru_w3[address[`INDEX_FIELD]] < _lru)
                  lru_w3[address[`INDEX_FIELD]] = lru_w3[address[`INDEX_FIELD]] + 1;
             end // if (valid_w2[address[`INDEX_FIELD]]...
           else if (valid_w3[address[`INDEX_FIELD]]
                    && (tag_w3[address[`INDEX_FIELD]] == address[`TAG_FIELD])) 
             begin
                // we have a hit in bank 0
                if (rden)
                  _dout = mem_data_w3[address[`INDEX_FIELD]][address[`BLOCK_OFFSET_FIELD]];
                else if (wren) 
                  begin
                     // we have a write hit
                     _dout = {WORD_SIZE{1'b0}};
                     mem_data_w3[address[`INDEX_FIELD]][address[`BLOCK_OFFSET_FIELD]] = din;
                     dirty_w3[address[`INDEX_FIELD]] = 1;
                  end
                // Update LRU
                _lru = lru_w3[address[`INDEX_FIELD]];
                lru_w3[address[`INDEX_FIELD]] = 0;                
                if (lru_w0[address[`INDEX_FIELD]] < _lru)
                  lru_w0[address[`INDEX_FIELD]] = lru_w0[address[`INDEX_FIELD]] + 1;
                if (lru_w1[address[`INDEX_FIELD]] < _lru)
                  lru_w1[address[`INDEX_FIELD]] = lru_w1[address[`INDEX_FIELD]] + 1;
                if (lru_w2[address[`INDEX_FIELD]] < _lru)
                  lru_w2[address[`INDEX_FIELD]] = lru_w2[address[`INDEX_FIELD]] + 1;
             end // if (valid_w3[address[`INDEX_FIELD]]...
             else
               current_state = STATE_MISS;
           end
        STATE_MISS: begin
           if (~valid_w0[address[`INDEX_FIELD]])
             begin
                mem_data_w0[address[`INDEX_FIELD]] = mdin;
                tag_w0[address[`INDEX_FIELD]] = address[`TAG_FIELD];
                dirty_w0[address[`INDEX_FIELD]] = 0;
                valid_w0[address[`INDEX_FIELD]] = 1;
             end
           else if (~valid_w1[address[`INDEX_FIELD]])
             begin
                mem_data_w1[address[`INDEX_FIELD]] = mdin;
                tag_w1[address[`INDEX_FIELD]] = address[`TAG_FIELD];
                dirty_w1[address[`INDEX_FIELD]] = 0;
                valid_w1[address[`INDEX_FIELD]] = 1;
             end
           else if (~valid_w2[address[`INDEX_FIELD]])
             begin
                mem_data_w2[address[`INDEX_FIELD]] = mdin;
                tag_w2[address[`INDEX_FIELD]] = address[`TAG_FIELD];
                dirty_w2[address[`INDEX_FIELD]] = 0;
                valid_w2[address[`INDEX_FIELD]] = 1;
             end
           else if (~valid_w3[address[`INDEX_FIELD]])
             begin
                mem_data_w3[address[`INDEX_FIELD]] = mdin;
                tag_w3[address[`INDEX_FIELD]] = address[`TAG_FIELD];
                dirty_w3[address[`INDEX_FIELD]] = 0;
                valid_w3[address[`INDEX_FIELD]] = 1;
             end
           else if (lru_w0[address[`INDEX_FIELD]] == 3)
             begin
                if (dirty_w0[address[`INDEX_FIELD]] == 1)
                  begin
                     _maddres = {tag_w0[address[`INDEX_FIELD]],address[`INDEX_FIELD]};
                     _mwren = 1;
                     _mdout = mem_data_w0[address[`INDEX_FIELD]];
                  end
                mem_data_w0[address[`INDEX_FIELD]] = mdin;
                tag_w0[address[`INDEX_FIELD]] = address[`TAG_FIELD];
                dirty_w0[address[`INDEX_FIELD]] = 0;
                valid_w0[address[`INDEX_FIELD]] = 1;
             end // if (lru_w0[address[`INDEX_FIELD]] == 3)
           else if (lru_w1[address[`INDEX_FIELD]] == 3)
             begin
                if (dirty_w1[address[`INDEX_FIELD]] == 1)
                  begin
                     _maddres = {tag_w1[address[`INDEX_FIELD]],address[`INDEX_FIELD]};
                     _mwren = 1;
                     _mdout = mem_data_w1[address[`INDEX_FIELD]];
                  end
                mem_data_w1[address[`INDEX_FIELD]] = mdin;
                tag_w1[address[`INDEX_FIELD]] = address[`TAG_FIELD];
                dirty_w1[address[`INDEX_FIELD]] = 0;
                valid_w1[address[`INDEX_FIELD]] = 1;
             end // if (lru_w0[address[`INDEX_FIELD]] == 3)
           else if (lru_w2[address[`INDEX_FIELD]] == 3)
             begin
                if (dirty_w2[address[`INDEX_FIELD]] == 1)
                  begin
                     _maddres = {tag_w2[address[`INDEX_FIELD]],address[`INDEX_FIELD]};
                     _mwren = 1;
                     _mdout = mem_data_w2[address[`INDEX_FIELD]];
                  end
                mem_data_w2[address[`INDEX_FIELD]] = mdin;
                tag_w2[address[`INDEX_FIELD]] = address[`TAG_FIELD];
                dirty_w2[address[`INDEX_FIELD]] = 0;
                valid_w2[address[`INDEX_FIELD]] = 1;
             end // if (lru_w0[address[`INDEX_FIELD]] == 3)
           else if (lru_w3[address[`INDEX_FIELD]] == 3)
             begin
                if (dirty_w3[address[`INDEX_FIELD]] == 1)
                  begin
                     _maddres = {tag_w3[address[`INDEX_FIELD]],address[`INDEX_FIELD]};
                     _mwren = 1;
                     _mdout = mem_data_w3[address[`INDEX_FIELD]];
                  end
                mem_data_w3[address[`INDEX_FIELD]] = mdin;
                tag_w3[address[`INDEX_FIELD]] = address[`TAG_FIELD];
                dirty_w3[address[`INDEX_FIELD]] = 0;
                valid_w3[address[`INDEX_FIELD]] = 1;
             end // if (lru_w0[address[`INDEX_FIELD]] == 3)
           current_state = STATE_IDLE;
        end
      endcase // unique case (current_state)
   end // always_ff @ (posedge clock)
endmodule // cache_controller
