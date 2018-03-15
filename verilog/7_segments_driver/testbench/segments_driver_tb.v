`define assert(signal, value) \
if (signal !== value) begin \
   $display("ASSERTION FAILED in %m: signal != value"); \
   $finish; \
end

`define COMMON_CATHODE_CONTROL 1'b0
`define COMMON_ANODE_CONTROL 1'b1

module segments_driver_tb;
	reg		[3:0]	data_bus_t;
	wire	[8:0] 	segment_value_bus_t;
	wire 			overflow_indication_t;

	segments_driver #(.CONTROL_TYPE_V(`COMMON_CATHODE_CONTROL)) driver(
		.data_bus           (data_bus_t),
		.segment_value_bus  (segment_value_bus_t),
		.overflow_indication(overflow_indication_t)
		);



	initial begin
		$dumpfile("segments_driver.vcd");
      	$dumpvars;

      	//Test 0: data_bus=0
      	data_bus_t=4'b0000;
      	#50
      	`assert(segment_value_bus_t,8'b11111100);
      	`assert(overflow_indication_t,1'b0);

		//Test 1: data_bus=1
      	data_bus_t=4'b0001;
      	#50
      	`assert(segment_value_bus_t,8'b01100000);
      	`assert(overflow_indication_t,1'b0);

      	//Test 2: data_bus=2
      	data_bus_t=4'b0010;
      	#50
      	`assert(segment_value_bus_t,8'b11011010);
      	`assert(overflow_indication_t,1'b0);

      	//Test 3: data_bus=3
      	data_bus_t=4'b0011;
      	#50
      	`assert(segment_value_bus_t,8'b11110010);
      	`assert(overflow_indication_t,1'b0);

		//Test 4: data_bus=4
      	data_bus_t=4'b0100;
      	#50
      	`assert(segment_value_bus_t,8'b01100110);
      	`assert(overflow_indication_t,1'b0);

      	//Test 5: data_bus=5
      	data_bus_t=4'b0101;
      	#50
      	`assert(segment_value_bus_t,8'b10110110);
      	`assert(overflow_indication_t,1'b0);

      	//Test 6: data_bus=6
      	data_bus_t=4'b0110;
      	#50
      	`assert(segment_value_bus_t,8'b10111110);
      	`assert(overflow_indication_t,1'b0);

      	//Test 7: data_bus=7
      	data_bus_t=4'b0111;
      	#50
      	`assert(segment_value_bus_t,8'b11100000);
      	`assert(overflow_indication_t,1'b0);

      	//Test 8: data_bus=8
      	data_bus_t=4'b1000;
      	#50
      	`assert(segment_value_bus_t,8'b11111110);
      	`assert(overflow_indication_t,1'b0);

      	//Test 9: data_bus=9
      	data_bus_t=4'b1001;
      	#50
      	`assert(segment_value_bus_t,8'b11110110);
      	`assert(overflow_indication_t,1'b0);

      	//Test 10: data_bus=10
      	data_bus_t=4'b1010;
      	#50
      	`assert(segment_value_bus_t,8'b11111100);
      	`assert(overflow_indication_t,1'b1);

      	//Test 11: data_bus=11
      	data_bus_t=4'b1011;
      	#50
      	`assert(segment_value_bus_t,8'b01100000);
      	`assert(overflow_indication_t,1'b1);

      	//Test 12: data_bus=12
      	data_bus_t=4'b1100;
      	#50
      	`assert(segment_value_bus_t,8'b11011010);
      	`assert(overflow_indication_t,1'b1);

      	//Test 13: data_bus=13
      	data_bus_t=4'b1101;
      	#50
      	`assert(segment_value_bus_t,8'b11110010);
      	`assert(overflow_indication_t,1'b1);

      	//Test 14: data_bus=14
      	data_bus_t=4'b1110;
      	#50
      	`assert(segment_value_bus_t,8'b01100110);
      	`assert(overflow_indication_t,1'b1);

      	//Test 15: data_bus=15
      	data_bus_t=4'b1111;
      	#50
      	`assert(segment_value_bus_t,8'b10110110);
      	`assert(overflow_indication_t,1'b1);

       	$finish;
	end

	initial begin
      $display("\t\tTime,\tInput,\tOutput,\tOverflow Indication");
      $monitor("%d,\t%b,\t%h,\t%b",$time,data_bus_t,segment_value_bus_t,overflow_indication_t);
    end

endmodule