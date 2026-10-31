module jogo_desafio_memoria (
    input clock,
    input reset,
    input jogar,
    input [3:0] botoes,
	 input memoria,
    output [3:0] leds,
    output pronto,
    output ganhou,
    output perdeu,
    output timeout,
    output db_botaoIgualMemoria,
    output db_clock,
    output db_tem_jogada,
    output [6:0] db_contagem,
    output [6:0] db_memoria,
    output [6:0] db_jogada,
    output [6:0] db_limite,
    output [6:0] db_estado
);
    // Sinais internos
    wire zeraTO, zeraL, contaL, zeraE, contaE, limpaR, registraR, fimE, pulso_jogada, wire_timeOut;
    wire fimL, botaoIgualMemoria, enderecoIgualLimite, enderecoMenorLimite;
    wire [3:0] hexa_db_contagem, hexa_db_memoria, hexa_db_jogada, hexa_db_limite;
    wire [4:0] hexa_db_estado;
    wire entTO, entTMR, fimTMR, registraM, limpaM;
    // Instanciação do fluxo de dados
    fluxo_dados_exp6 FD (
        .clock              ( clock ),
        .contaL             ( contaL ),
        .zeraL              ( zeraL ),
        .contaE             ( contaE ),
        .zeraE              ( zeraE ),
        .botoes             ( botoes ),
        .registraR          ( registraR ),
        .limpaR             ( limpaR ),
        .entTO              ( entTO ),
        .zeraTO             ( zeraTO ),
        .entTMR             ( entTMR ),
        .limpaM             ( limpaM ),
        .registraM          ( registraM ),
		  .memoria				 ( memoria ),
        .enderecoMenorLimite( enderecoMenorLimite ),
        .enderecoIgualLimite( enderecoIgualLimite),
        .db_contagem        ( hexa_db_contagem ),
        .db_memoria         ( hexa_db_memoria ),
        .db_jogada          ( hexa_db_jogada ),
        .db_limite          ( hexa_db_limite ),
        .botaoIgualMemoria  ( botaoIgualMemoria ),
        .fimE               ( fimE ),
        .fimL               ( fimL ),
        .pulso_jogada       ( pulso_jogada ),
        .timeOut            ( wire_timeOut ),
        .fimTMR             ( fimTMR )
    );

    // Instanciação da unidade de controle
    unidade_controle_exp6 UC (
        .clock              ( clock ),
        .reset              ( reset ),
        .jogar              ( jogar ),
        .fimE               ( fimE ),
        .fimL               ( fimL ),
        .pulso_jogada       ( pulso_jogada ),
        .botaoIgualMemoria  ( botaoIgualMemoria ),
        .timeOut            ( wire_timeOut ),
        .enderecoMenorLimite( enderecoMenorLimite ),
        .enderecoIgualLimite( enderecoIgualLimite ),
        .fimTMR              ( fimTMR ),
        .zeraL              ( zeraL ),
        .contaL             ( contaL ),
        .zeraE              ( zeraE ),
        .contaE             ( contaE),
        .limpaR             ( limpaR ),
        .registraR          ( registraR ),
        .acertou            ( ganhou ),
        .errou              ( perdeu ),
        .pronto             ( pronto ),
        .entTO              ( entTO ),
        .db_estado          ( hexa_db_estado ),
        .entTMR             ( entTMR ),
        .zeraTO             ( zeraTO ),
        .registraM          ( registraM ),
        .limpaM             ( limpaM ),
        .db_timeout         ( timeout) //colocar timeout
    );
	 
    // Instanciação dos displays de 7 segmentos
    hexa7seg HEX0(hexa_db_contagem, db_contagem);
    hexa7seg HEX1(hexa_db_memoria, db_memoria);
    hexa7seg HEX2(hexa_db_jogada, db_jogada);
    hexa7seg HEX3(hexa_db_limite, db_limite);
    estado7seg HEX5(hexa_db_estado, db_estado);

    // Atribuições diretas
    assign db_clock = clock;
    assign db_botaoIgualMemoria = botaoIgualMemoria;
    assign leds = hexa_db_memoria; //leds guarda a saída da RegMem
endmodule