module circuito_exp5 (
    input clock,
    input reset,
    input jogar,
    input [3:0] botoes,
    output [3:0] leds,
    output pronto,
    output ganhou,
    output perdeu,
    output db_botaoIgualMemoria,
    output db_clock,
    output db_tem_jogada,
    output [6:0] db_contagem,
    output [6:0] db_memoria,
    output [6:0] db_jogada,
    output [6:0] db_limite,
    output [6:0] db_estado,
    output db_Timeout
);
    // Sinais internos
    wire zeraL, contaL, zeraE, contaE, limpaR, registraR, fimE, pulso_jogada, timeOut;
    wire fimL, botaoIgualMemoria, enderecoIgualLimite, enderecoMenorLimite;
    wire [3:0] hexa_db_contagem, hexa_db_memoria, hexa_db_jogada, hexa_db_limite, hexa_db_estado;

    // Instanciação do fluxo de dados
    fluxo_dados_exp5 FD (
        .clock              ( clock ),
        .contaL             ( contaL ),
        .zeraL              ( zeraL ),
        .contaE             ( contaE ),
        .zeraE              ( zeraE ),
        .botoes             ( botoes ),
        .registraR          ( registraR ),
        .limpaR             ( limpaR ),
        .entTO              ( entTO ),
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
        .timeOut            ( timeOut )
    );

    // Instanciação da unidade de controle
    unidade_controle_exp5 UC (
        .clock              ( clock ),
        .reset              ( reset ),
        .jogar              ( jogar ),
        .fimE               ( fimE ),
        .fimL               ( fimL ),
        .pulso_jogada       ( pulso_jogada ),
        .botaoIgualMemoria  ( botaoIgualMemoria ),
        .timeOut            ( timeOut ),
        .enderecoMenorLimite( enderecoMenorLimite ),
        .enderecoIgualLimite( enderecoIgualLimite ),
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
        .db_Timeout         ( db_Timeout ),
        .db_estado          ( hexa_db_estado )
    );

    // Instanciação dos displays de 7 segmentos
    hexa7seg HEX0(hexa_db_contagem, db_contagem);
    hexa7seg HEX1(hexa_db_memoria, db_memoria);
    hexa7seg HEX2(hexa_db_jogada, db_jogada);
    hexa7seg HEX3(hexa_db_limite, db_limite);
    hexa7seg HEX5(hexa_db_estado, db_estado);

    // Atribuições diretas
    assign db_clock = clock;
    assign db_botaoIgualMemoria = botaoIgualMemoria;
    assign leds = hexa_db_jogada;
endmodule