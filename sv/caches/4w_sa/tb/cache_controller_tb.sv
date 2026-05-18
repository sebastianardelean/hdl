`timescale 1ns/1ps

module cache_controller_tb;
   
   localparam SIZE = 32 * 1024 * 8;
   localparam KWAYS = 4;
   localparam NSETS = 256;
   localparam BLOCK_SIZE = 256;
   localparam WIDTH = 21;
   localparam INDEX_WIDTH = 8;
   localparam TAG_WIDTH = 10;
   localparam OFFSET_WIDTH = 3;
   localparam WORD_SIZE = 32;
   
   
   logic      clock;
   logic [WIDTH - 1:0] address;
   logic [WORD_SIZE - 1:0] din;
   logic [BLOCK_SIZE -1:0] mdin;
   logic                   rden;
   logic                   wren;
   logic                   hit;
   logic [WORD_SIZE - 1:0] dout;
   logic [BLOCK_SIZE - 1:0] mdout;
   logic [TAG_WIDTH + INDEX_WIDTH - 1:0] maddress;
   logic                                 mrden;
   logic                                 mwren;
   


   
   initial begin
      $dumpfile("cache_controller_tb.vcd");
      $dumpvars;
      
   end

   // generate clock
   always
     begin
        clock = 1'b1;
        #5;
        clock = 1'b0;
        #5;
     end
   
   
   
   cache_controller DUT_CACHE(
                              .clock(clock),
                              .address(address),
                              .din(din),
                              .mdin(mdin),
                              .rden(rden),
                              .wren(wren),
                              .hit(hit),
                              .dout(dout),
                              .mdout(mdout),
                              .maddress(maddress),
                              .mrden(mrden),
                              .mwren(mwren)
                              );
   memory #(.FILE("mem_data.txt")) DUT_MEM 
     (                
                      .clock(clock),
                      .din(mdout),
                      .address(maddress),
                      .rden(mrden),
                      .wren(mwren),
                      .dout(mdin)
                      );

   always
     begin
        # 100;
        
        address <= 32'h00000004;
        din <= 0;
        rden <= 1;
        wren <= 0;
        
        # 100; // This should be a miss
        
        address <= 32'h10000004;
        din <= 0;
        rden <= 1;
        wren <= 0;
        
        # 100; // This should be a hit
        
        address <= 32'h00000005;
        din <= 32'hBADDBEEF;
        rden <= 1;
        wren <= 0;

        # 100; // This should be a hit
        
        address <= 32'h10000006;
        din <= 32'h00000000;
        rden <= 1;
        wren <= 0;
        
        # 100; // This should be a hit
        
        address <= 32'h00000007;
        din <= 32'hAAAAAAAA;
        rden <= 1;
        wren <= 0;
        
        #50;
          
        $finish;
        
     end
   

   initial
     begin
        $monitor("time=%4d | addr=%10d | hm=%b | q=%08x | way1=%08h | way2=%08h | way3=%08h | way4=%08h | lru1=%d | lru2=%d | lru3=%d | lru4=%d |",
                 $time,
                 address,
                 hit,
                 dout,
                 DUT_CACHE.mem_data_w0[1],
                 DUT_CACHE.mem_data_w1[1],
                 DUT_CACHE.mem_data_w2[1],
                 DUT_CACHE.mem_data_w3[1],
                 DUT_CACHE.lru_w0[1],
                 DUT_CACHE.lru_w1[1],
                 DUT_CACHE.lru_w2[1],
                 DUT_CACHE.lru_w3[1]
                 );
  end
endmodule // cache_controller_tb




