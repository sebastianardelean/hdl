`timescale 1ns/1ps

module register_tb;

   // Parameters
   localparam WIDTH = 8;

   // DUT I/O
   logic clk;
   logic rst_n;
   logic load_en;
   logic shift_en;
   logic sr, sl;
   logic shift_dir; // 0 = left, 1 = right
   logic [WIDTH-1:0] d;
   logic [WIDTH-1:0] q;

   // Clock generator
   always #5 clk = ~clk;

   // Instantiate DUT
   register #(WIDTH) dut (
      .clk(clk),
      .rst_n(rst_n),
      .load_en(load_en),
      .shift_en(shift_en),
      .sr(sr),
      .sl(sl),
      .shift_dir(shift_dir),
      .d(d),
      .q(q)
   );

   initial
     begin
        $dumpfile("register_tb.vcd");
        $dumpvars;
     end
   
   // Test sequence
   initial begin
      $display("=== Starting register test ===");

      // Init
      clk = 0;
      rst_n = 0;
      load_en = 0;
      shift_en = 0;
      sr = 0;
      sl = 0;
      shift_dir = 0;
      d = 8'b0;

      // Reset
      #10;
      rst_n = 1;
      #10;

      // Load value
      d = 8'b10101010;
      load_en = 1;
      #10;
      load_en = 0;
      #10;

      $display("Loaded value: %b", q);

      // Shift left
      shift_dir = 0;
      sl = 0; // serial input from left
      shift_en = 1;
      #10;
      shift_en = 0;
      #10;

      $display("After left shift: %b", q);

      // Shift right
      shift_dir = 1;
      sr = 1; // serial input from right
      shift_en = 1;
      #10;
      shift_en = 0;
      #10;

      $display("After right shift: %b", q);

      // Final value
      $display("Final register content: %b", q);

      $finish;
   end

endmodule
