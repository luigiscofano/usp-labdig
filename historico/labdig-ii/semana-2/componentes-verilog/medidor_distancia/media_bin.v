/*---------------Laboratorio Digital-------------------------------------
 * Arquivo   : media_bin.v
 *-----------------------------------------------------------------------
 * Descricao :  Componente que calcula a média de 4 medidas em binário.
 *              Conforme recebe novas medidas, vai atualizando a soma.
 *              Sempre retorna a soma dividida por 4 (média).
 *              Não discrimina se chegou mais que 4 medidas.
 *-----------------------------------------------------------------------
 */

module media_bin (
    input          clock,
    input          zera,
    input          recebeu_medida,
    input  [9:0]   valor_medida,
    output [9:0]   medida_media
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

    // Média = soma / 4 → SHIFT RIGHT por 2
    assign medida_media = soma_reg[11:2];

endmodule
