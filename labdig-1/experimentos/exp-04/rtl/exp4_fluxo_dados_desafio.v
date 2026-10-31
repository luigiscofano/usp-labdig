module exp4_fluxo_dados_desafio (
 input clock,
 input zeraC,
 input contaC,
 input zeraR,
 input registraR,
 input [3:0] chaves,
 input entTO,
 output igual,
 output fimC,
 output jogada_feita,
 output db_tem_jogada,
 output [3:0] db_contagem,
 output [3:0] db_memoria,
 output [3:0] db_jogada,
 output timeOut
);

    wire tem_jogada, acerto;
    assign tem_jogada = (chaves[0] | chaves[1] | chaves[2] | chaves[3]);

    wire [3:0] s_chaves, s_endereco, s_dado;

    contador_m timeOutContador
    (
      .clock(clock),
      .zera_as(~entTO),
      .zera_s(),
      .conta(entTO),
      .Q(),
      .fim(timeOut),
      .meio()

    );

    contador_163 contadorJ (
      .clock(clock),
      .clr  (~zeraC),
      .ld   (1'b1),
      .ent  (1'b1),
      .enp  (contaC),
      .D    (4'b0),
      .Q    (s_endereco),
      .rco  (fimC)
    );

    registrador_4 registradorJ (
        .clock(clock),
        .clear(zeraR),
        .enable(registraR),
        .D(chaves),
        .Q(s_chaves)
    );

    sync_rom_16x4 memoria (
        .clock(clock),
        .address(s_endereco),
        .data_out(s_dado)
    );

    comparador_85 comparador (
      .ALBi(1'b0),
      .AGBi(1'b0),
      .AEBi(1'b1),
      .A   (s_dado),
      .B   (s_chaves),
      .ALBo(),
      .AGBo(),
      .AEBo(acerto)
    );

    edge_detector detector (
        .clock(clock),
        .reset(zeraC),
        .sinal(tem_jogada),
        .pulso(jogada_feita)
    );

    assign db_contagem = s_endereco;
    assign db_jogada = s_chaves;
    assign db_tem_jogada = tem_jogada;
    assign db_memoria = s_dado;
    assign igual = acerto & ~timeOut;

endmodule