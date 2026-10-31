//------------------------------------------------------------------
// Arquivo   : rom_01.v
//------------------------------------------------------------------
// Descricao: Retorna o resultado de uma operação entre dois números
//------------------------------------------------------------------
// op = 00 -> A + B
// op = 01 -> A - B
// op = 10 -> A * B
// op = 11 -> A / B           
//------------------------------------------------------------------

module operadorOp (
    input [1:0] op,
    input [6:0] A,
    input [6:0] B,
    output reg [7:0] OUT
);

always @(*) begin
    case (op)
        2'b00:    OUT = A + B;
        2'b01:    OUT = A - B;
        2'b10:    OUT = A * B;
        2'b11:    OUT = A / B;
        default: OUT = 0;
    endcase
end

endmodule