module tratar_tx_dados (
    input clock,
    input reset,
    input iniciar_tx,
    input [11:0] medida_antiga,
    input [11:0] medida_atual,
    output saida_serial,
    output fim_tx
);

    wire inicia_caractere, tx_char_pronto, zera_contador, proximo_char, fim_cont;
    tratar_tx_dados_fd FD_TX (
        .clock (clock),
        .reset (reset),
        .inicia_caractere (inicia_caractere),
        .saida_serial (saida_serial),
        .caractere_pronto (tx_char_pronto),
        .zera_contador (zera_contador),
        .proximo_char (proximo_char),
        .fim_cont (fim_cont),
        .medida_antiga (medida_antiga),
        .medida_atual (medida_atual)
    );
    tratar_tx_dados_uc UC_TX (
        .clock (clock),
        .reset (reset),
        .iniciar_tx (iniciar_tx),
        .tx_char_pronto (tx_char_pronto),
        .fim_cont (fim_cont),
        .fim_tx (fim_tx),
        .inicia_caractere (inicia_caractere),
        .zera_contador (zera_contador),
        .proximo_char (proximo_char)
    );
    
endmodule