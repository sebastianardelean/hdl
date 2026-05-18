`timescale 1ns/1ps

module cache_controller_tb;
   
   localparam BLOCK_SIZE = 256;
   
   
   
   localparam ADDRESS_WIDTH = 21;
   localparam INDEX_WIDTH = 10;
   localparam TAG_WIDTH = 8;
   localparam OFFSET_WIDTH = 3;
   localparam WORD_SIZE = 32;
   localparam NBLOCKS = 1024;
   
   
   
   logic      clock;
   logic      rst_n;
   
   logic [ADDRESS_WIDTH - 1:0] caddress;
   logic [WORD_SIZE - 1:0] cdin;
   logic [BLOCK_SIZE -1:0] mdin;
   logic                   rden;
   logic                   wren;
   logic                   hit;
   logic [WORD_SIZE - 1:0] cdout;
   logic [BLOCK_SIZE - 1:0] mdout;
   logic [TAG_WIDTH + INDEX_WIDTH - 1:0] maddress;
   logic                                 mrden;
   logic                                 mwren;
   


   
   initial begin
      $dumpfile("cache_controller_tb.vcd");
      $dumpvars;
      
   end

   // generate clock
   always #5 clock = ~clock;
   
     
   
   
   
   cache_controller DUT_CACHE(
                              .clock(clock),
                              .rst_n(rst_n),
                              .caddress(caddress),
                              .cdin(cdin),
                              .mdin(mdin),
                              .rden(rden),
                              .wren(wren),
                              .hit(hit),
                              .cdout(cdout),
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
        clock = 0;
        rst_n = 0;
        
        # 100;
        rst_n = 1;
        
        
        
        
        caddress <= 32'h00000004;
        cdin <= 0;
        rden <= 1;
        wren <= 0;
        
        # 100; // This should be a miss
        
        caddress <= 32'h10000004;
        cdin <= 0;
        rden <= 1;
        wren <= 0;
        
        # 100; // This should be a hit
        
        caddress <= 32'h00000005;
        cdin <= 32'hBADDBEEF;
        rden <= 1;
        wren <= 0;

        # 100; // This should be a hit
        
        caddress <= 32'h10000006;
        cdin <= 32'h00000000;
        rden <= 1;
        wren <= 0;
        
        # 100; // This should be a hit
        
        caddress <= 32'h00000007;
        cdin <= 32'hAAAAAAAA;
        rden <= 1;
        wren <= 0;
        
        #50;
          
        $finish;
        
     end
   

   initial
     begin
        $monitor("time=%4d | addr=%10d | hm=%b | q=%08x | way1=%08h |",
                 $time,
                 caddress,
                 hit,
                 cdout,
                 DUT_CACHE.cache_mem[1],       
                 );
  end
endmodule // cache_controller_tb




