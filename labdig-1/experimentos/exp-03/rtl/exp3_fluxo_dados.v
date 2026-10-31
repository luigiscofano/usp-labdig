module exp3_fluxo_dados (
    input   [3:0] chaves,
    input   clock,
    input   contaC,
    input   escreveM,
    input   registraR,
    input   zeraC,
    input   zeraR,
    output  chavesIgualMemoria,
    output  [3:0] db_chaves,
    output  [3:0] db_contagem,
    output  [3:0] db_memoria,
    output  fimC
);

    wire [3:0] 
            s_endereco, //end da mem 
            s_chaves,   //valor das chaves
            s_dado;     //valor da mem

    contador_163 contador (
      .clock(clock),
      .clr  (~zeraC),
      .ld   (1'b1),
      .ent  (1'b1),
      .enp  (contaC),
      .D    (4'b0),
      .Q    (s_endereco),
      .rco  (fimC)
    );

    registrador_4 registrador (
        .clock(clock),
        .clear(zeraR),
        .enable(registraR),
        .D(chaves),
        .Q(s_chaves)
    );

    sync_rom_16x4 rom (
        .clock(clock),
        .address(s_endereco),
        .data_out(s_dado)
    );

    comparador_85 comparador (
      .A   (s_dado),
      .B   (s_chaves),
      .ALBi(1'b0),
      .AGBi(1'b0),
      .AEBi(1'b1),
      .ALBo(),
      .AGBo(),
      .AEBo(chavesIgualMemoria)
    );

    assign  db_memoria = s_dado;
    assign db_chaves = s_chaves;
    assign db_contagem = s_endereco;
endmodule