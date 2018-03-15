`timescale 1 ns/1 ps
`define assert_eq(signal, value) \
if (signal !== value) begin \
   $display("ASSERTION FAILED in %m: signal != value"); \
   $finish; \
end
module counter_tb;
   reg [7:0] data_t;
   wire [7:0]  out_t;
   reg 	      clk_t,reset_t,up_down_t,load_t,enable_t;
   counter c0(
	      .out(out_t),
	      .up_down(up_down_t),
	      .clk(clk_t),
	      .data(data_t),
	      .load(load_t),
	      .enable(enable_t),
	      .reset(reset_t)
	      );
  
  always  #1 clk_t=!clk_t;
   
   initial begin
      clk_t=0;
      $dumpfile("counter.vcd");
      $dumpvars;
      
      //Test 1: cout up
      reset_t=1;
      
      #5 data_t='h0F;
      #5 up_down_t=1;
       `assert_eq(out_t,0);
      #5 enable_t=1;
      #1 `assert_eq(out_t,1);
      #2 `assert_eq(out_t,2);
      #2 `assert_eq(out_t,3);
      #2 `assert_eq(out_t,4);
      #2 `assert_eq(out_t,5);
      #2 `assert_eq(out_t,6);
      #2 `assert_eq(out_t,7);
      #2 `assert_eq(out_t,8);
      #2 `assert_eq(out_t,9);
      #2 `assert_eq(out_t,'h0A);
      #2 `assert_eq(out_t,'h0B);
      #2 `assert_eq(out_t,'h0C);
      #2 `assert_eq(out_t,'h0D);
      #2 `assert_eq(out_t,'h0E);
      #2 `assert_eq(out_t,'h0F);
      enable_t=0;
      
      //Test 2
       reset_t=1;
      #5 data_t='h0F;
      #5 load_t=1;
      #5 up_down_t=0;
      `assert_eq(out_t,'h0F);
      #5 enable_t=1;
      #2 `assert_eq(out_t,'h0E);
      #2 `assert_eq(out_t,'h0D);
      #2 `assert_eq(out_t,'h0C);
      #2 `assert_eq(out_t,'h0B);
      #2 `assert_eq(out_t,'h0A);
      #2 `assert_eq(out_t,9);
      #2 `assert_eq(out_t,8);
      #2 `assert_eq(out_t,7);
      #2 `assert_eq(out_t,6);
      #2 `assert_eq(out_t,5);
      #2 `assert_eq(out_t,4);
      #2 `assert_eq(out_t,3);
      #2 `assert_eq(out_t,2);
      #2 `assert_eq(out_t,1);
      #2 `assert_eq(out_t,0);
      $finish;
      
   end
   initial begin
      $display("\t\ttime,\tdata,\tclk,\tup_down,\treset,\tload,\tenable,\tout");
      $monitor("%d,\t%b,\t%b,\t%b,\t%b,\t%b,\t%b,\t%b",
	       $time,data_t,clk_t,up_down_t,reset_t,load_t,enable_t,out_t);
      
   end
   
   




endmodule
