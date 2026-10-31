module mux_char (
    input [11:0] medida1,
    input [11:0] diferenca,
    input diferenca_sinal,
    input [3:0] sel_char,
    output reg [6:0] caractere_ascii
);
    /* 0000 - centena posição
     * 0001 - dezena posição
     * 0010 - unidade posição
     * 0011 - vírgula
     * 0100 - centena diferença
     * 0101 - dezena diferença
     * 0110 - unidade diferença
     * 0111 - vírgula
     * 1000 - dezena velocidade
     * 1001 - unidade velocidade
     * 1010 - vírgula
     * 1011 - estado semáforo
     * 1100 - cerquilha
     * 13 caracteres no total  */
    parameter VIRGULA = 7'h2C; // ','
    parameter CERQUILHA = 7'h23; // '#'
    always @(*) begin
        case (sel_char)
            4'd0: caractere_ascii = medida1[11:8] + 7'h30;
            4'd1: caractere_ascii = medida1[7:4] + 7'h30;
            4'd2: caractere_ascii = medida1[3:0] + 7'h30;
            4'd3: caractere_ascii = VIRGULA;
            4'd4: caractere_ascii = diferenca_sinal ? ;
            4'd4: caractere_ascii = diferenca[11:8] + 7'h30;
            4'd5: caractere_ascii = diferenca[7:4]  + 7'h30;
            4'd6: caractere_ascii = diferenca[3:0]  + 7'h30;
            4'd7: caractere_ascii = VIRGULA;
            // 4'd8: caractere_ascii = velocidade_dezena;
            // 4'd9: caractere_ascii = velocidade_unidade;
            // 4'd10: caractere_ascii = VIRGULA;
            4'd8: caractere_ascii = CERQUILHA;
            default: caractere_ascii = 7'h21; // '!'
        endcase
    end
    
endmodule