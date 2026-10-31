module reg2bits (
    input wire clk,
    input wire enable,
    input wire [1:0] in_data,
    output reg [1:0] out_data
);

    always @(posedge clk) begin
        if (enable)
            out_data <= in_data;
    end

endmodule