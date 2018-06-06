//----------------------------------------------
// Design Name: Common Cathode 7-segments display driver
// File Name: driver_7_segments.v
// Function: 7-segments display driver
// Developer: Mihai
//----------------------------------------------



module driver_7_segments(
    inbus,
    le,
    lt,
    bl,
    outbus,

    );
    
    input       [3:0]   inbus;      //input data
    input               le;             //latch-enable
    input               lt;             //lamp-test->displays 8
    input               bl;             //blanking-> blank
    output reg  [7:0]   outbus;


    wire [3:0]  latch_output;
    wire [7:0]  decoder_output;

    dlatch latch0(
        .d  (inbus[0]),
        .ena (~le),
        .nena(le),
        .q  (latch_output[0]),
        .nq ()
        );
    
    dlatch latch1(
        .d  (inbus[1]),
        .ena (~le),
        .nena(le),
        .q  (latch_output[1]),
        .nq ()
        );
    
    dlatch latch2(
        .d  (inbus[2]),
        .ena (~le),
        .nena(le),
        .q  (latch_output[2]),
        .nq ()
        );

    dlatch latch3(
        .d  (inbus[3]),
        .ena (~le),
        .nena(le),
        .q  (latch_output[3]),
        .nq ()
        );
    dec_7seg decoder_7_segments(
        .datain (latch_output),
        .bl     (bl),
        .dataout(decoder_output)
        );
    
    drv_7seg driver_7_segments(
        .inbus (decoder_output),
        .lt    (lt),
        .outbus(outbus)
        );

    
    
endmodule // segments_driver