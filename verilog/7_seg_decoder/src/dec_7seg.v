//----------------------------------------------
// Design Name: Common Cathode 7-segments display driver
// File Name: dec_7seg.v
// Function: BCD-to-7 segments decoder ( 0-9)
// Developer: Mihai
//----------------------------------------------

module dec_7seg(
    datain,
    bl,
    dataout
    );

    input   [3:0]   datain; 
    input           bl;
    output  [7:0]   dataout;
    




    assign dataout[7]=(bl==1'b0)?8'b00000000:(datain[3]&(~datain[2])&(~datain[1]))|
                ((~datain[3])&(datain[1]|(((~datain[2])&(~datain[0]))|(datain[2]&datain[0]))));


    assign dataout[6]=(bl==1'b0)?8'b00000000:((~(datain[3]&datain[1]))&(~datain[2]))|
                        ((~datain[3])&((datain[1]&datain[0])|((~datain[1])&(~datain[0]))));


    assign dataout[5]=(bl==1'b0)?8'b00000000:((~datain[2])&(~datain[1]))|
                        ((~datain[3])&(datain[2]|datain[0]));

    
    assign dataout[4]=(bl==1'b0)?8'b00000000:
                ((~datain[3])&(~datain[2])&(datain[1]|(~datain[0])))|
                ((~datain[3])&((datain[1]&(~datain[0]))|(datain[2]&datain[0]&(~datain[1]))))|
                (datain[3]&(~datain[2])&(~datain[1]));


    
    assign dataout[3]=(bl==1'b0)?8'b00000000:
                (~datain[0])&(((~datain[2])&(~datain[1]))|((~datain[3])&datain[1]));


    assign dataout[2]=(bl==1'b0)?8'b00000000:
        ((~datain[3])&((datain[2]&(~(datain[1]&datain[0])))|((~datain[1])&(~datain[0]))))|
        (datain[3]&(~datain[2])&(~datain[1]));

    assign dataout[1]=(bl==1'b0)?8'b00000000:
            ((~datain[3])&((datain[1]&(~(datain[2]&datain[0])))|(datain[2]&(~datain[1]))))|
            (datain[3]&(~datain[2])&(~datain[1]));


    assign dataout[0]=1'b0;//dot



endmodule // decoder