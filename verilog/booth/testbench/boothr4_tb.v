`timescale 1 ns/1 ps
`define assert_eq(signal, value) \
if (signal !== value) begin \
   $display("ASSERTION FAILED in %m: signal != value"); \
   $finish; \
     end

module boothr4_tb;
	reg clk;
	reg reset;
	reg start;
        wire busy;
  reg [7:0] M;
  reg [7:0] Q;

  wire  [7:0] outbus;

	boothr4 mod(
		.clk(clk),.reset(reset),.start(start),.busy(busy),
      .M(M),.Q(Q),.outbus(outbus)
	);
	always begin
	#5 clk=!clk;
	end
	
	initial begin
      $dumpfile("boothr4.vcd"); $dumpvars;
	clk<=0;
      #25 reset<=1;
      #25 reset<=0;
      #10 start<=1;
	  #5 M<=8'b00010001;
      #5 Q<=8'b00000011;
	
      #1000
	$finish;

	end

endmodule

