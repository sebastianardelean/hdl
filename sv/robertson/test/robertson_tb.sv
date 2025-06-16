`timescale 1ns/1ps
// Testbench for robertson_top
module robertson_tb;

   logic clk;
   logic rst_n;
   logic start;
   logic [7:0] inbus;
   logic [7:0] outbus;
   logic       done;
   
   // Instantiate the DUT
   robertson_top dut (
		  .clk(clk),
		  .rst_n(rst_n),
		  .enable(start),
		  .inbus(inbus),
		  .done(done),
		  .outbus(outbus)
		  );
   
   
   initial
     begin
	$dumpfile("robertson.vcd");
	$dumpvars;
     end
   
   
   // Clock generation
   always #5 clk = ~clk;

   initial forever begin
      #1;
      $display("time=%0t, c[6]=%b, c[7]=%b", $time, dut.c[6], dut.c[7]);
   end
   
   // Stimulus
   initial begin
      $display("Starting Robertson Multiplier Testbench...");
      
      clk = 0;
      rst_n = 0;
      start = 0;
      inbus = 8'd0;
      
      // Reset pulse
      #10;
      rst_n = 1;
      $display("Reset pulse...");
      
      // Load M (multiplicand)
      start = 1;     // start signal goes high
      inbus = -8'd69; // example: -3
      #10;
      start = 0;
     
      #10;
      

      


      $display("Finished loading M...");


      inbus = -8'd45;  // example: 5
      $display("Finished loading Q...");
      
      // Wait until done
      wait (done);
      
      // Read result in two cycles
      #40;
      
      

      $display("Test complete.");
      $finish;
   end
endmodule
