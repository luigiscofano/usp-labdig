module circuito_exp4_desafio (
 input clock,
 input reset,
 input iniciar,
 input [3:0] chaves,
 output acertou,
 output errou,
 output pronto,
 output [3:0] leds,
 output db_igual,
 output [6:0] db_contagem,
 output [6:0] db_memoria,
 output [6:0] db_estado,
 output [6:0] db_jogadafeita,
 output db_clock,
 output db_iniciar,
 output db_tem_jogada,
 output [3:0] contagemDebug,
 output [3:0] memoriaDebug,
 output [3:0] estadoDebug,
 output [3:0] jogadafeitaDebug,
 output db_pulso,
 output db_contaC,
 output db_timeOut
);

    wire contaC, zeraC, zeraR, registraR, igual, fim, jogada_feita, entTO, timeOut;
    wire [3:0] jogadaDP_in, contagemDP_in, memoriaDP_in, estadoDP_in;

    exp4_fluxo_dados_desafio FD (
        //inputs
        .clock(clock),
        .zeraC(zeraC),
        .contaC(contaC),
        .zeraR(zeraR),
        .registraR(registraR),
        .chaves(chaves),
        .entTO(entTO),

        //outputs
        .igual(igual),
        .fimC(fim),
        .jogada_feita(jogada_feita),
        .db_tem_jogada(db_tem_jogada),
        .db_contagem(contagemDP_in),
        .db_memoria(memoriaDP_in),
        .db_jogada(jogadaDP_in),
        .timeOut(timeOut)
    );

    exp4_unidade_controle_desafio UC (
        //inputs
        .clock(clock),
        .reset(reset),
        .iniciar(iniciar),
        .fim(fim),
        .jogada(jogada_feita),
        .igual(igual),
        .timeOut(timeOut),

        //outputs
        .zeraC(zeraC),
        .contaC(contaC),
        .zeraR(zeraR),
        .registraR(registraR),
        .acertou(acertou),
        .errou(errou),
        .pronto(pronto),
        .db_estado(estadoDP_in),
        .entTO(entTO),
        .db_Timeout(db_Timeout)
    );

    hexa7seg HEX0( //CONTAGEM
        .hexa(contagemDP_in),
        .display(db_contagem)
    );
    
    hexa7seg HEX1( //MEMÓRIA
        .hexa(memoriaDP_in),
        .display(db_memoria)  
    );
    
    hexa7seg HEX2( //JOGADA
        .hexa(jogadaDP_in),
        .display(db_jogadafeita) 
    );
    
    hexa7seg HEX5( //ESTADO
        .hexa(estadoDP_in),
        .display(db_estado)
    );

    assign db_clock = clock;
    assign db_igual = igual;
    assign db_iniciar = iniciar;
    assign leds = jogadaDP_in;

    assign contagemDebug = contagemDP_in;
    assign memoriaDebug = memoriaDP_in;
    assign estadoDebug = estadoDP_in;
    assign jogadafeitaDebug = jogadaDP_in;
    assign db_pulso = jogada_feita;
    assign db_contaC = contaC;

endmodule