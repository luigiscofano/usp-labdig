/*---------------Laboratorio Digital-------------------------------------
 * Arquivo   : conversor_bin_2_bcd.v
 *-----------------------------------------------------------------------
 * Descricao : Converte número binário (0 a 999) para BCD de 3 dígitos
 *-----------------------------------------------------------------------
 */
module conversor_bin_2_bcd (
    input  [9:0]  num_bin,
    output [11:0] num_bcd      
);

    reg [3:0] centenas;
    reg [3:0] dezenas;
    reg [3:0] unidades;

    reg [9:0] resto;

    always @(*) begin
        centenas = num_bin / 100;

        resto = num_bin % 100;

        dezenas = resto / 10;

        unidades = resto % 10;
    end

    assign num_bcd = {centenas, dezenas, unidades};

endmodule