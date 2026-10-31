module bin2disp(
    input [7:0] bin_in,    // Número binário de 8 bits de entrada (0 a 255)
    output [6:0] disp1, // 1º dígito (dezenas)
    output [6:0] disp2, // 2º dígito (unidades)
    output [6:0] disp3  // 3º dígito (primeiro dígito de unidade)
);
    reg [3:0] digit1, digit2, digit3;
    always @(*) begin
        // Convertendo o número binário para os três dígitos.
        digit1 = bin_in / 100;    // Divisão inteira para o primeiro dígito (centenas)
        digit2 = (bin_in % 100) / 10;  // Segundo dígito (dezenas)
        digit3 = bin_in % 10;     // Terceiro dígito (unidades)
    end

    estado7seg conversor1 (
        .estado ({1'b0, digit1}),
        .display(disp1)
    );
    estado7seg conversor2 (
        .estado ({1'b0, digit2}),
        .display(disp2)
    );
    estado7seg conversor3 (
        .estado ({1'b0, digit3}),
        .display(disp3)
    );

endmodule