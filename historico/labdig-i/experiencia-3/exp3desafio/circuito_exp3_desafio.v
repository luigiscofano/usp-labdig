
module circuito_exp3_desafio (
    input   clock,
    input   reset,
    input   iniciar,
    input   [3:0] chaves,
    output  pronto,
    output  db_igual,
    output  db_iniciar,
    output  db_zeraC,
    output  db_zeraR,
    output  db_fimC,
    output  db_contaC,
    output  db_registraR,
    output  [6:0] db_contagem,
    output  [6:0] db_memoria,
    output  [6:0] db_chaves,
    output  [6:0] db_estado,
    output  acertou,
	 output errou
);

    wire contaC, registraR, zeraC, zeraR, fimC;
    wire [3:0] chavesDP_in, contagemDP_in, memoriaDP_in, estadoDP_in;

    exp3_fluxo_dados FD (
        .chaves(chaves),
        .clock(clock),
        .contaC(contaC),
        .escreveM(1'h0),
        .registraR(registraR),
        .zeraC(zeraC),
        .zeraR(zeraR),
        .chavesIgualMemoria(db_igual),
        .db_chaves(chavesDP_in),
        .db_contagem(contagemDP_in),
        .db_memoria(memoriaDP_in),
        .fimC(fimC)
    );

    exp3_unidade_controle UC (
        .clock(clock),
        .reset(reset),
        .iniciar(iniciar),
        .fimC(fimC),
        .errou(~db_igual),
        .zeraC(zeraC),
        .contaC(contaC),
        .zeraR(zeraR),
        .registraR(registraR),
        .pronto(pronto),
        .db_estado(estadoDP_in)
    );

    hexa7seg displayChaves(
        .hexa(chavesDP_in),
        .display(db_chaves)
    );
    
    hexa7seg displayContagem(
        .hexa(contagemDP_in),
        .display(db_contagem)  
    );
    
    hexa7seg displayMemoria(
        .hexa(memoriaDP_in),
        .display(db_memoria) 
    );
    
    hexa7seg displayEstado(
        .hexa(estadoDP_in),
        .display(db_estado)
    );

    assign db_zeraC = zeraC;
    assign db_zeraR = zeraR;
    assign db_fimC = fimC;
    assign db_contaC = contaC;
    assign db_registraR = registraR;
    assign acertou = (estadoDP_in == 4'h4 || estadoDP_in == 4'h5 || estadoDP_in == 4'h6 ||estadoDP_in == 4'h7);
    assign errou = ~acertou;
endmodule