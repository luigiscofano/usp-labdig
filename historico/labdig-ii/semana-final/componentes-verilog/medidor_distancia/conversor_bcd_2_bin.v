/*---------------Laboratorio Digital-------------------------------------
 * Arquivo   : conversor_bcd_2_bin.v
 *-----------------------------------------------------------------------
 * Descricao : Converte número em BCD (3 dígitos) para binário (0 a 999).
 *-----------------------------------------------------------------------
 */

module conversor_bcd_2_bin (
    input  [11:0] num_bcd,
    output [9:0]  num_bin 
);

    wire [3:0] centenas = num_bcd[11:8];
    wire [3:0] dezenas  = num_bcd[7:4];
    wire [3:0] unidades = num_bcd[3:0];

    assign num_bin =
          (centenas * 7'd100)
        + (dezenas  * 4'd10)
        +  unidades;

endmodule
