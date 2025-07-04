`timescale 1ns/1ps
module div_non_restoring_tb;

   logic clk;
   logic rst_n;
   logic start;
   logic [7:0] inbus;
   logic [7:0] outbus;
   logic       done;
   
   // Instantiate the DUT

   div_nonrestoring dut (
		  .clk(clk),
		  .rst_n(rst_n),
		  .enable(start),
		  .inbus(inbus),
		  .done(done),
		  .outbus(outbus)
		  );
   
   
   initial
     begin
	$dumpfile("div_non_restoring_tb.vcd");
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
      $display("Starting Booth Multiplier Testbench...");
      
      clk = 0;
      rst_n = 0;
      start = 0;
      inbus = 8'd0;
      
      // Reset pulse
      #10;
      rst_n = 1;
      $display("Reset pulse...");
      
      // Load A (multiplicand)
      start = 1;     // start signal goes high
      inbus = 8'd0; // example: 0
      #10;
      start = 0;
     
      #10;
      

      


      $display("Finished loading A...");
      

      inbus = 8'd127;  // example: Q
      $display("Finished loading Q...");
      #10;
      inbus = 8'd25;
      $display("Finished loading M...");
      
      
      // Wait until done
      wait (done);
      
      // Read result in two cycles
      #40;
      
      

      $display("Test complete.");
      $finish;
   end
endmodule
