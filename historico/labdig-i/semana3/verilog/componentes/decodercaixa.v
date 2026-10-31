module decoderCaixa (
    input [1:0] contaCaixa,
    output [3:0] Ds
);

always @(*) begin
    case(contaCaixa)
        2'b00: Ds = 4'b1110;
        2'b01: Ds = 4'b1101;
        2'b10: Ds = 4'b1011;
        2'b11: Ds = 4'b0111;
    endcase
end

endmodule