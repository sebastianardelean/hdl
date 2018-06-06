`include "testbench/test_inc.v"
module driver_7_segments_tb;

	reg       [3:0]   inbus;      //input data
    reg               le;             //latch-enable
    reg               lt;             //lamp-test->displays 8
    reg               bl;             //blanking-> blank
    wire reg  [7:0]   outbus;

    driver_7_segments driver(
    	.inbus (inbus),
    	.le    (le),
    	.lt    (lt),
    	.bl    (bl),
    	.outbus(outbus)
    	);

    initial begin
        $dumpfile("segments_driver_tb.vcd");
        $dumpvars;

        //Lamp Test
        le<=1'b0;//latch is transparent
        bl<=1'b1;//blanking is disabled
        inbus<=4'b0000;//0 on inbus
        lt<=1'b0;//lamp test enabled
        #25
        `assert(outbus,8'b11111111);

        #50
        //Blanking Test
        le<=1'b0;//latch is transparent
        bl<=1'b0;//blanking is enabled
		inbus<=4'b0000;//0 on inbus
        lt<=1'b1;//lamp test disabled
        #25
        `assert(outbus,8'b00000000);        

        #50
        //test all values
        le<=1'b0;//latch is transparent
        bl<=1'b1;//blanking is disabled
        lt<=1'b1; //lamp test is disabled
        
        #25
        inbus<=4'b0000;
        #25
        `assert(outbus,8'b11111100);
		
		#25
        inbus<=4'b0001;
        #25
        `assert(outbus,8'b01100000);

		#25
        inbus<=4'b0010;
        #25
        `assert(outbus,8'b11011010);

        #25
        inbus<=4'b0011;
        #25
        `assert(outbus,8'b11110010);

        #25
        inbus<=4'b0100;
        #25
        `assert(outbus,8'b01100110);

        #25
        inbus<=4'b0101;
        #25
        `assert(outbus,8'b10110110);

        #25
        inbus<=4'b0110;
        #25
        `assert(outbus,8'b10111110);

        #25
        inbus<=4'b0111;
        #25
        `assert(outbus,8'b11100000);

        #25
        inbus<=4'b1000;
        #25
        `assert(outbus,8'b11111110);

        #25
        inbus<=4'b1001;
        #25
        `assert(outbus,8'b11110110);


    end // initial


    initial begin :dump_proc
            $display("\t\tTime\tINBUS\t/LE\t/LT\t/BL\tOUTBUS");
            $monitor("%d\t%b\t%b\t%b\t%b\t%b",$time,inbus,le,lt,bl,outbus);
    end // dump_proc
endmodule // segments_driver_tb