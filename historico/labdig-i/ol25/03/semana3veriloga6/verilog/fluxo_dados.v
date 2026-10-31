module fluxo_dados(
    input clock,
    //contador
    input zeraE,
    input enE,
    output fimE,

    //Registrador dificuldade       --PAULO
    input enableDif,
    input [1:0] dif_input,

    //Contador Acertos              --PAULO
    input clear_contacertos,
    input enable_contacertos,
    output [5:0] contagem_acertos,

    //comparador limite
    output fimL,

    //inputControl
    input addU,
    input addD,
    input addC,
    input subU,
    input subD,
    input subC,
    input zeraCtrl,
    input enableCtrl,
    input resetEdge,
    
    //regResposta
    input clearReg,
    input regEnable,
    output [7:0] respostaOut,

    output acertoJog,

    //rom
    output [6:0] db_A,
    output [6:0] db_B,
    output [1:0] db_op,
    output [3:0] db_addr,
    output [1:0] contaCaixa
);

    wire pulsoAddU, pulsoAddD, pulsoAddC, pulsoSubU, pulsoSubD, pulsoSubC;
    wire [1:0] op, dificuldade;
    wire [6:0] Aop, Bop;
    wire [5:0] addr;
    wire [7:0] valorInput, resposta, saidaOP;
    wire [15:0] conta1, conta2, conta3, conta4; // SAÍDAS DAS ROMS -- PAULO
    wire [15:0] contaReal; //Saida do demux que escolhe a dificuldade


    contador_m  #(.M(3), .N(2)) contDisp (
        .clock (clock),
        .zera_as (1'b0),
        .zera_s (1'b0),
        .conta (1'b1),
        .Q (contaCaixa),
        .fim (),
        .meio ()
    );

    inputControl Controle ( 
        .clock (clock),
        .addU  (pulsoAddU ),
        .subU  (pulsoSubU),
        .addD (pulsoAddD),
        .subD (pulsoSubD),
        .addC (pulsoAddC),
        .subC (pulsoSubC),
        .clear (zeraCtrl),
        .enable (enableCtrl),
        .OUT (valorInput)
    );

//EdgeDetectors
    edge_detector detectorBordaAddU (
        .clock (clock),
        .reset (resetEdge),
        .sinal (addU),
        .pulso (pulsoAddU)
    );
    edge_detector detectorBordaSubU (
        .clock (clock),
        .reset (resetEdge),
        .sinal (subU),
        .pulso (pulsoSubU)
    );
    edge_detector detectorBordaAddD (
        .clock (clock),
        .reset (resetEdge),
        .sinal (addD),
        .pulso (pulsoAddD)
    );
    edge_detector detectorBordaSubD (
        .clock (clock),
        .reset (resetEdge),
        .sinal (subD),
        .pulso (pulsoSubD)
    );
    edge_detector detectorBordaAddC (
        .clock (clock),
        .reset (resetEdge),
        .sinal (addC),
        .pulso (pulsoAddC)
    );
    edge_detector detectorBordaSubC (
        .clock (clock),
        .reset (resetEdge),
        .sinal (subC),
        .pulso (pulsoSubC)
    );

    registrador_8 RegResposta (
        .clock(clock),
        .clear(clearReg),
        .enable(regEnable),
        .D(valorInput),
        .Q(resposta)
    );

//Registrador da dificuldade, modificar o enableDif para so estar ligado nos momentos em que o jogo aceita o input da dificuldade --paulo
    reg2bits RegDif (
        .clk   (clock),
        .enable  (enableDif),
        .in_data (dif_input),
        .out_data(dificuldade)
    );
//contador de endereço
    contador_64 Contador (
        .clock(clock),
        .clr(zeraE),
        .ld(1'b0), //por enquanto vou sempre começar do zero. Futuramente quero pseudo-aleatório
        .en(enE),
        .D(6'b000000), //por enquanto vou sempre começar do zero. Futuramente quero pseudo-aleatório
        .Q(addr),
        .rco(fimE)
    );
//
    comparador_8b comparadorLimites (
        .A({2'b00, addr}),
        .B(8'b0000_0100), //por enquanto só vou contar até 4. Futuramente, vou contar até endInicial + algum numero que depende da dificuldade
        .AEBo(fimL)
    );


//ADICIONEI AS RONS -- PAULO
    rom1 romInicial (
        .clock(clock),
        .address(addr),
        .data_out(conta1)
    );

    rom2 romFacil (
        .clock(clock),
        .address(addr),
        .data_out(conta2)
    );

    rom3 romMedia (
        .clock(clock),
        .address(addr),
        .data_out(conta3)
    );

    rom4 romDificil (
        .clock(clock),
        .address(addr),
        .data_out(conta4)
    );

//

    operadorOp Operador (
        .A(Aop),
        .B(Bop),
        .op(op),
        .OUT(saidaOP)
    );

    comparador_8b comparadorJog (
        .A(saidaOP),
        .B(resposta),
        .AEBo(acertoJog)
    );

    contador_64 contAcertos (
        .clock(clock),
        .clr(clear_contacertos),
        .ld(1'b0),
        .en(enable_contacertos),
        .D (6'h00),
        .Q(contagem_acertos),
        .rco()
    );

// Seleciona a rom que queremos com base no registrador da dificuldade
    assign contaReal = (dificuldade == 2'b00) ? conta1 :
                        (dificuldade == 2'b01) ? conta2 :
                        (dificuldade == 2'b10) ? conta3 :
                        conta4;
    
    assign Aop = contaReal[15:9];
    assign Bop = contaReal[6:0];
    assign op = contaReal[8:7];
    assign respostaOut = resposta;
    assign db_A = Aop;
    assign db_B = Bop;
    assign db_op = op;
    assign db_addr = addr;


endmodule