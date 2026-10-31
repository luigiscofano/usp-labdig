module tratar_tx_dados_fd (
    input clock,
    input reset,

    // Unidade 7e1
    input inicia_caractere,
    output saida_serial,
    output caractere_pronto,

    // Contador de caracteres
    input zera_contador,
    input proximo_char,
    output fim_cont,

    // Dados de entrada
    input [11:0] medida_antiga,
    input [11:0] medida_atual
);

    wire pulslo_inicia_caractere;
    edge_detector unidade_ed (
        .clock (clock),
        .reset (reset),
        .sinal (inicia_caractere),
        .pulse_out (pulslo_inicia_caractere)
    );

    wire [6:0] caractere_ascii;
    serial_tx_7e1 unidade_tx (
        .clock  (clock),
        .reset  (1'b0),
        .start  (pulslo_inicia_caractere),
        .data7   (caractere_ascii),
        .pronto (caractere_pronto),
        .tx     (saida_serial)
    );
    
    
    /* 0000 - centena posição
     * 0001 - dezena posição
     * 0010 - unidade posição
     * 0011 - vírgula
     * 0100 - sinal diferença
     * 0101 - centena diferença
     * 0110 - dezena diferença
     * 0111 - unidade diferença
     * 1000 - vírgula
     * 1001 - dezena velocidade
     * 1010 - unidade velocidade
     * 1011 - vírgula
     * 1100 - estado semáforo
     * 1101 - cerquilha
     * 13 caracteres no total  */

    wire [3:0] sel_char;
    contador_m #(.M(13), .N(4)) contador_char (
        .clock(clock),
        .zera_as(zera_contador),
        .zera_s(1'b0),
        .conta(proximo_char),
        .Q(sel_char),
        .fim(fim_cont),
        .meio()
    );

    wire diferenca_sinal;
    wire [11:0] diferenca;
    calculo_dados calc_dados (
        .medida0 (medida_antiga),
        .medida1 (medida_atual),
        .sinal_diferenca (diferenca_sinal),
        .diferenca (diferenca)
    );
    
    mux_char mux_caractere (
        .medida1 (medida_atual),
        .diferenca (diferenca),
        .diferenca_sinal (diferenca_sinal),
        .sel_char (sel_char),
        .caractere_ascii (caractere_ascii)
    );

endmodule