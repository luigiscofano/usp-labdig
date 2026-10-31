module inputControl (
    input clock,
    input addU,
    input subU,
    input addD,
    input subD,
    input addC,
    input subC,
    input clear,
    input enable,
    output reg [7:0] OUT
);

    initial begin
        OUT = 0; // Inicializa o registrador como 0
    end

    always @(posedge clock or posedge clear) begin
        if (clear)
            OUT <= 0;
        else if (enable)
            if (addU)
                OUT <= OUT + 1;
            else if (subU)
                OUT <= OUT - 1;
            else if (addD)
                OUT <= OUT + 10;
            else if (subD)
                OUT <= OUT - 10;
            else if (addC)
                OUT <= OUT + 100;
            else if (subC)
                OUT <= OUT - 100;
    end
endmodule