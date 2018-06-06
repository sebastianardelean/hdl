//----------------------------------------------
// Design Name: Common Cathode 7-segments display driver
// File Name: dlatch.v
// Function: D-type Latch
// Developer: Mihai
//----------------------------------------------

module dlatch(
    d,
    q,
    nq,
    ena,
    nena
    );
    
    input       d;
    input       ena;
    input       nena;
    output  reg q;
    output  reg nq;

    always @(d,ena,nena) begin: d_latch_procedure
        if(ena) begin
            q<=d;
            nq<=~d;
        end // if( le='1')
        else begin
        end

    end // d_latch_procedure

    



endmodule // dlatch
