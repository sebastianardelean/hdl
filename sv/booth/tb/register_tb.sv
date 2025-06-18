`timescale 1ns/1ps
module register_tb;

    // Parameters
    parameter WIDTH = 8;

    // Testbench signals
    logic clk;
    logic rst_n;
    logic shift_en;
   logic  shift_in;
    logic load_en;
    logic [WIDTH-1:0] data_in;
    logic [WIDTH-1:0] data_out;

    // DUT instantiation
    register #(.WIDTH(WIDTH)) dut (
				   .clk(clk),
				   .rst_n(rst_n),
				   .load_en(load_en),
			   	   .shift_en(shift_en),
				   .shift_in(shift_in),
				   .d(data_in),
				   .q(data_out));
   
   


   initial
     begin
	$dumpfile("register_tb.vcd");
	$dumpvars;
     end
	
   
    // Clock generation: 10ns period
    always #5 clk = ~clk;

    // Test sequence
    initial begin
        // Initialize
        clk = 0;
        rst_n = 0;
        shift_en = 0;
        load_en = 0;
        data_in = 0;
       shift_in = 0;
       
        // Apply reset
        #10;
        rst_n = 1;

        // Load a value
        #10;
        load_en = 1;
        data_in = 8'b10101010;
        #10;
        load_en = 0;

        // Shift right 3 times
        repeat (3) begin
            shift_en = 1;
            #10;
        end
        shift_en = 0;

        // Hold
        #20;

        $finish;
    end

    // Monitor output
    initial begin
        $display("Time\tclk\trst_n\tload_en\tshift_en\tdata_in\t\tdata_out");
        $monitor("%0t\t%b\t%b\t%b\t%b\t\t%b\t%b", 
            $time, clk, rst_n, load_en, shift_en, data_in, data_out);
    end

endmodule
