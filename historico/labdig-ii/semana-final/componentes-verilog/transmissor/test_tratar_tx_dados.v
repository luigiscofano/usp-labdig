module test_tratar_tx_dados (
    input clock,
    input reset,
    input iniciar_tx,
    output saida_serial,
    output fim_tx,
    output db_chave,
    output db_pulso,
    output db_reset
);

    assign db_chave = iniciar_tx;
    assign db_reset = reset;
    wire pulso_inicia;
    assign db_pulso = pulso_inicia;
	  
     edge_detector unidade_ed (
         .clock (clock),
         .reset (reset),
         .sinal (iniciar_tx),
         .pulso (pulso_inicia)
     );
    // Valores fixos
    localparam [11:0] VARIACAO = 12'h12; 
    localparam [11:0] MEDIDA_ATUAL  = 12'h440;
    localparam SEMAFORO = 1'b1;
    localparam JOGO = 2'b11;
	  
    tratar_tx_dados DUT (
        .clock(clock),
        .reset(reset),
        .iniciar_tx(pulso_inicia),
        .estado_semaforo(SEMAFORO),
        .estado_jogo(JOGO),
        .variacao_vermelha(VARIACAO),
        .medida_atual(MEDIDA_ATUAL),
        .saida_serial(saida_serial),
        .fim_tx(fim_tx)
    );

endmodule
