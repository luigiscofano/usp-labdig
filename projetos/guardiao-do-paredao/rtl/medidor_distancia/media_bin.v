/*---------------Laboratorio Digital-------------------------------------
 * Arquivo   : media_bin.v
 *-----------------------------------------------------------------------
 * Descricao :  Componente que calcula a média de medidas em binário.
 *              Conforme recebe novas medidas, vai atualizando a soma
                e o divisor.
 *              Não discrimina se chegou mais que 4 medidas, mas só
                tem divisor de no máximo 4.
 *-----------------------------------------------------------------------
 */

module media_bin (
    input          clock,
    input          zera,
    input          recebeu_medida,
    input  [9:0]   valor_medida,
    output [9:0]   medida_media,
    output         zero_medidas
);

    reg [11:0] soma_reg;  

    always @(posedge clock or posedge zera) begin
        if (zera) begin
            soma_reg <= 12'd0;
        end
        else if (recebeu_medida) begin
            soma_reg <= soma_reg + valor_medida;
        end
    end

    wire [2:0]  count_q;
    contador_m #(.M(5), .N(3)) u_contador (
        .clock   (clock),
        .zera_as (zera),
        .zera_s  (1'b0),
        .conta   (recebeu_medida),
        .Q       (count_q),
        .fim     (),
        .meio    ()
    );

    // Média = soma / 4 → SHIFT RIGHT por 2
    assign medida_media = (count_q != 0) ?
                        (soma_reg / count_q) :
                        10'd0;
    assign zero_medidas = (count_q == 0);

endmodule
