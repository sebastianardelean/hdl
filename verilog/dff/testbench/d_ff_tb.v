`define assert(signal, value) \
if (signal !== value) begin \
   $display("ASSERTION FAILED in %m: signal != value"); \
   $finish; \
end
module d_ff_tb;
   wire q_t;
   reg data_t,clk_t,reset_t;
   d_ff dff0(.data(data_t),
	     .clk(clk_t),
	     .reset(reset_t),
	     .q(q_t));
   always begin
      #1 clk_t=!clk_t;
   end
   initial begin
      clk_t=0;
      $dumpfile("dff.vcd");
      $dumpvars;
      
      //Test 1: reset=1, d!=0=>q=0
      reset_t=1;
      data_t=1;
      #5
      	`assert(q_t,0);
      
      //Test 2: reset=0,d=1=>q=1
      reset_t=0;
      data_t=1;

      #5
      `assert(q_t,1);

      //Test 3 reset=0,d=1=>q=1
      reset_t=0;
      data_t=1;
      #5
	`assert(q_t,1);
      
      $finish;
      
   end
   initial begin
      $display("\t\ttime,\tdata,\tclk,\treset,\tq");
      $monitor("%d,\t%b,\t%b,\t%b,\t%b",$time,data_t,clk_t,reset_t,q_t);
      
   end
   
   




endmodule
