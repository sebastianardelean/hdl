`timescale 1ns/1ps
module cu_tb;

  // Clock and reset
  logic clk;
  logic rst_n;

  // Inputs to DUT
  logic start;
  logic count;
  logic q0;
  logic qm;

  // Outputs from DUT
  logic stop;
  logic [7:0] c;

  // Instantiate the DUT
  cu dut (
    .clk(clk),
    .start(start),
    .rst_n(rst_n),
    .count(count),
    .q0(q0),
    .qm(qm),
    .stop(stop),
    .c(c)
  );

   initial
     begin
	$dumpfile("cu.vcd");
	$dumpvars(0, dut);
     end
   
  // Clock generation: 10ns period
  always #5 clk = ~clk;

  // Task to apply a reset pulse
  task reset();
    rst_n = 0;
    #10;
    rst_n = 1;
    #10;
  endtask

  initial begin
    // Initialize signals
    clk = 0;
    rst_n = 1;
    start = 0;
    count = 0;
    q0 = 0;
    qm = 0;

    // Apply reset
    reset();

    // Start sequence
    start = 1;
    #10;
    start = 0;

    // Wait through LOAD_M and LOAD_Q
    #40;

    // Set q0 and qm for SCAN logic: case 01 (add)
    q0 = 1;
    qm = 0;
    #10;

    // Wait through SCAN and SHIFT
    #30;

    // Set count = 0 to loop back to SCAN via CHECK
    count = 0;
    #20;

    // Next scan: 10 (subtract)
    q0 = 0;
    qm = 1;
    #30;

    // Prepare for CHECK state again
    count = 1;  // Will go to OUTPUT_A
    #20;

    // Let OUTPUT_A and OUTPUT_Q happen
    #30;

    // STOP state
    #10;

    // Done
    $display("Test complete. Final c: %b, stop: %b", c, stop);
    $finish;
  end

endmodule
