module fluxo_dados_exp6 (
    input clock,
    input contaL,
    input zeraL,
    input contaE,
    input zeraE,
    input [3:0] botoes,
    input registraR,
    input limpaR,
    input entTO,
    input zeraTO,
    input entTMR,
    input limpaM,
    input registraM,
	 input memoria,
    output enderecoMenorLimite,
    output enderecoIgualLimite,
    output [3:0] db_contagem,
    output [3:0] db_memoria,
    output [3:0] db_jogada,
    output [3:0] db_limite,
    output botaoIgualMemoria,
    output fimE,
    output fimL,
    output pulso_jogada,
    output timeOut,
    output fimTMR
);
    wire tem_jogada;
    assign tem_jogada = |botoes;

    wire [3:0] s_jogada, s_endereco, s_dado, s_limite, s_dado2;
	 wire [3:0] dado_real;
	 assign dado_real = (memoria) ? s_dado2 : s_dado;

    contador_m #(.M(500), .N(9)) timerContador(
      .clock(clock),
      .zera_as(~entTMR),
      .zera_s(),
      .conta(entTMR),
      .Q(),
      .fim(fimTMR),
      .meio()
    );

    contador_m timeOutContador(
      .clock(clock),
      .zera_as(zeraTO),
      .zera_s(),
      .conta(entTO),
      .Q(),
      .fim(timeOut),
      .meio()
    );

    contador_163 ContLmt (
      .clock(clock),
      .clr  (~zeraL),
      .ld   (1'b1),
      .ent  (1'b1),
      .enp  (contaL),
      .D    (4'b0),
      .Q    (s_limite),
      .rco  (fimL)
    );

    comparador_85 CompLmt (
      .ALBi(1'b0),
      .AGBi(1'b0),
      .AEBi(1'b1),
      .A   (s_limite),
      .B   (s_endereco),
      .ALBo(),
      .AGBo(enderecoMenorLimite),
      .AEBo(enderecoIgualLimite)
    );

    contador_163 ContEnd (
      .clock(clock),
      .clr  (~zeraE),
      .ld   (1'b1),
      .ent  (1'b1),
      .enp  (contaE),
      .D    (4'b0),
      .Q    (s_endereco),
      .rco  (fimE)
    );

    sync_rom_16x4 MemJog (
        .clock(clock),
        .address(s_endereco),
        .data_out(s_dado)
    );
	 
	  rom2 rom2(
        .clock(clock),
        .address(s_endereco),
        .data_out(s_dado2)
    );
    
    comparador_85 CompJog (
      .ALBi(1'b0),
      .AGBi(1'b0),
      .AEBi(1'b1),
      .A   (dado_real),
      .B   (s_jogada),
      .ALBo(),
      .AGBo(),
      .AEBo(botaoIgualMemoria)
    );

    registrador_4 RegBotoes (
        .clock(clock),
        .clear(limpaR),
        .enable(registraR),
        .D(botoes),
        .Q(s_jogada)
    );

    registrador_4 RegMem (
        .clock(clock),
        .clear(limpaM),
        .enable(registraM),
        .D(dado_real),
        .Q(db_memoria)
    );

    edge_detector detector (
        .clock(clock),
        .reset(zeraL),
        .sinal(tem_jogada),
        .pulso(pulso_jogada)
    );

    assign db_limite = s_limite;
    assign db_jogada = s_jogada;
    assign db_contagem = s_endereco;

endmodule