`define assert(signal, value) \
if (signal !== value) begin \
   $display("ASSERTION FAILED in %m: signal != value"); \
   $finish; \
end
module freq_div_tb;
   wire f_t;
   
   reg clk_t,reset_t;
   
   freq_div div(.frequency(f_t),.clk(clk_t),.reset(reset_t));
   
   always begin
      #1 clk_t=!clk_t;
   end
   initial begin
      clk_t=0;
      $dumpfile("freq_div.vcd");
      $dumpvars;
      
      //Test 1: reset=1, d!=0=>q=0
      reset_t=1'b1;
      
      #5 reset_t=1'b0;
      	//`assert(f_t,1);
      #1000 reset_t=1'b1;
      
	
      
      $finish;
      
   end
   initial begin
      $display("\t\ttime,\tclk,\treset,\tf");
      $monitor("%d,\t%b,\t%b,\t%b",$time,clk_t,reset_t,f_t);
      
   end
   
   




endmodule
