`include "testbench/test_inc.v"
module dec_7seg_tb;

      reg   [3:0] datain;
      reg         bl;
      wire  [7:0] dataout;

      dec_7seg dec (
            .datain (datain),
            .dataout(dataout),
            .bl     (bl)
            );

      initial begin :test_proc
            $dumpfile("decoder_tb.vcd");
            $dumpvars;
            bl=1'b1;
            datain<=4'b0000;
            #25
            `assert(dataout,8'b11111100);

            datain<=4'b0001;
            #25
            `assert(dataout,8'b01100000);

            datain<=4'b0010;
            #25
            `assert(dataout,8'b11011010);

            datain<=4'b0011;
            #25
            `assert(dataout,8'b11110010);

            datain<=4'b0100;
            #25
            `assert(dataout,8'b01100110);

            datain<=4'b0101;
            #25
            `assert(dataout,8'b10110110);

            datain<=4'b0110;
            #25
            `assert(dataout,8'b10111110);

            datain<=4'b0111;
            #25
            `assert(dataout,8'b11100000);

            datain<=4'b1000;
            #25
            `assert(dataout,8'b11111110);

            datain<=4'b1001;
            #25
            `assert(dataout,8'b11110110);

            datain<=4'b1010;
            #25
            `assert(dataout,8'b00000000);

            #25 
            bl<=1'b0;
            datain<=4'b1001;
            #25
            `assert(dataout,8'b00000000);

      end // test_proc


      initial begin :dump_proc
            $display("\t\tTime,\tInput,\tOutput");
            $monitor("%d,\t%b,\t%b",$time,datain,dataout);
      end // dump_proc

endmodule // decoder_tb