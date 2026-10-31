//------------------------------------------------------------------
// Arquivo   : contador_64.v
// ld e clr são ativos em nível ALTO
//------------------------------------------------------------------

module contador_64 ( clock, clr, ld, en, D, Q, rco );
    input clock, clr, ld, en;
    input [5:0] D;
    output reg [5:0] Q;
    output reg rco;


    initial begin
        Q = 6'b000_000;
    end
    
    always @ (posedge clock)
        if (clr)               Q <= 6'b000_000;
        else if (ld)           Q <= D;
        else if (en)           Q <= Q + 1'b1;
        else                   Q <= Q;
 
    always @ (Q )
        if (Q == 6'd63)   rco = 1;
        else              rco = 0;
endmodule