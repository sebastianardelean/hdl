//----------------------------------------------
// Design Name: Common Cathode 7-segments display driver
// File Name: drv_7seg.v
// Function: Driver used for lamp test
// Developer: Mihai
//----------------------------------------------
module drv_7seg(
    lt,
    inbus,
    outbus
    );

    input               lt;
    input       [7:0]   inbus;
    output  reg [7:0]   outbus;

    always @(lt,inbus) begin : drv_7seg
        if(lt) begin
            outbus<=inbus;
        end else begin
            outbus<=8'b11111111; 
        end
    end

endmodule // drv_7seg