`include "testbench/test_inc.v"
module drv_7seg_tb;
    reg           lt;
      reg   [7:0] inbus;
      wire  [7:0] outbus;

      
      drv_7seg drv (
            .lt    (lt),
            .inbus (inbus),
            .outbus(outbus)

            );


      initial begin :test_proc
            $dumpfile("drv_7seg_tb.vcd");
            $dumpvars;

            inbus<=8'b11111100;
            lt<=1'b0;
            #25
            `assert(outbus,8'b11111111);
            #25
            lt<=1'b1;
            #25
            `assert(outbus,8'b11111100);

            inbus<=8'b01100000;
            lt<=1'b0;
            #25
            `assert(outbus,8'b11111111);
            #25
            lt<=1'b1;
            #25
            `assert(outbus,8'b01100000);

            inbus<=8'b11011010;
            lt<=1'b0;
            #25
            `assert(outbus,8'b11111111);
            #25
            lt<=1'b1;
            #25
            `assert(outbus,8'b11011010);

            inbus<=8'b11110010;
            lt<=1'b0;
            #25
            `assert(outbus,8'b11111111);
            #25
            lt<=1'b1;
            #25
            `assert(outbus,8'b11110010);

            inbus<=8'b01100110;
            lt<=1'b0;
            #25
            `assert(outbus,8'b11111111);
            #25
            lt<=1'b1;
            #25
            `assert(outbus,8'b01100110);

            inbus<=8'b10110110;
            lt<=1'b0;
            #25
            `assert(outbus,8'b11111111);
            #25
            lt<=1'b1;
            #25
            `assert(outbus,8'b10110110);

            inbus<=8'b10111110;
            lt<=1'b0;
            #25
            `assert(outbus,8'b11111111);
            #25
            lt<=1'b1;
            #25
            `assert(outbus,8'b10111110);

            inbus<=8'b11100000;
            lt<=1'b0;
            #25
            `assert(outbus,8'b11111111);
            #25
            lt<=1'b1;
            #25
            `assert(outbus,8'b11100000);

            inbus<=8'b11111110;
            lt<=1'b0;
            #25
            `assert(outbus,8'b11111111);
            #25
            lt<=1'b1;
            #25
            `assert(outbus,8'b11111110);

            inbus<=8'b11110110;
            lt<=1'b0;
            #25
            `assert(outbus,8'b11111111);
            #25
            lt<=1'b1;
            #25
            `assert(outbus,8'b11110110);



      end // test_proc


      initial begin :dump_proc
            $display("\t\tTime,\tLT\tInput,\tOutput");
            $monitor("%d,\t%b\t%b,\t%b",$time,lt,inbus,outbus);
      end // dump_proc

endmodule // decoder_tb