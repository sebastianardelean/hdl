//----------------------------------------------
// Design Name: Adder
// File Name: register.sv
// Function: 
// Version | Changes | Author
//----------------------------------------------

module adder_8bit (	  
			  input logic		    cin,
			  input logic signed [7:0]  a,
			  input logic signed [7:0]  b,
			  output logic signed [7:0] sum
    );

   always_comb begin
      sum = a + b + cin;
   end
endmodule
