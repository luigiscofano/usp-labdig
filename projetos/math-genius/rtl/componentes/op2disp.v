module op2disp(
    input [2:0] op,
    output reg [6:0] dispOp
);
always @(*) begin
    case (op)
        3'b000: dispOp =   7'b0001000;  // A
        3'b001: dispOp =   7'b1111110;  // -
        3'b010: dispOp =   7'b1100010;  // mult
        3'b011: dispOp =   7'b0100001;  // D
        3'b100: dispOp =   7'b0111110;  // =
        default:dispOp =   7'b0000110;  // E;
    endcase
end


endmodule