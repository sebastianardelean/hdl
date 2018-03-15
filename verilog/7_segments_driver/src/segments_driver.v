//----------------------------------------------
// Design Name: 7-segments display driver
// File Name: segments_driver.v
// Function: 7-segments display driver
// Developer: Mihai
//----------------------------------------------

`define COMMON_CATHODE_CONTROL 1'b0
`define COMMON_ANODE_CONTROL 1'b1

module segments_driver(
	data_bus,
	segment_value_bus,
	overflow_indication
	);
	
	input [3:0] data_bus;
	output reg [8:0] segment_value_bus;
	output reg overflow_indication;
	
	reg [8:0] segments_value;
	
	parameter CONTROL_TYPE_V=`COMMON_CATHODE_CONTROL;
	
	always @(data_bus) begin
		case (data_bus) 
			4'h0:segments_value=8'b11111100;
			4'h1:segments_value=8'b01100000;
			4'h2:segments_value=8'b11011010;
			4'h3:segments_value=8'b11110010;
			4'h4:segments_value=8'b01100110;
			4'h5:segments_value=8'b10110110;
			4'h6:segments_value=8'b10111110;
			4'h7:segments_value=8'b11100000;
			4'h8:segments_value=8'b11111110;
			4'h9:segments_value=8'b11110110;
			4'hA:segments_value=8'b11111100;
			4'hB:segments_value=8'b01100000;
			4'hC:segments_value=8'b11011010;
			4'hD:segments_value=8'b11110010;
			4'hE:segments_value=8'b01100110;
			4'hF:segments_value=8'b10110110;
		endcase
		if(data_bus<=9) begin
			overflow_indication<=1'b0;
		end
		else begin
			overflow_indication<=1'b1;
		end
		case (CONTROL_TYPE_V)
			`COMMON_CATHODE_CONTROL: begin
				segment_value_bus<=segments_value;					
			end
			`COMMON_ANODE_CONTROL: begin
				segment_value_bus<=~segments_value;
			end

		endcase

	end
endmodule // segments_driver