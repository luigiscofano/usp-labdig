module MathGenius (
    input clock,
    input addU,
    input addD,
    input addC,
    input subU,
    input subD,
    input subC,
    input enter,
    input jogar,
    input reset,
    input [1:0] dif_input,
    output acertoJog,
    // output db_fim,
    output [6:0] dispU_respostaOut,
    output [6:0] dispD_respostaOut,
    output [6:0] dispC_respostaOut,
    // output [6:0] db_A,
    // output [6:0] db_B,
    // output [3:0] db_addr,
    output [6:0] dispU_acertos,
    output [6:0] dispD_acertos,
    output [6:0] caixa1,
    output [6:0] caixa2,
    output [3:0] Ds,
    output DP,
    output [6:0] disp_estado
);

    wire zeraE, enE, fimE, fimL, zeraCtrl, enableCtrl, resetControls;
    wire clearReg, regEnable;
    wire enableDif, clear_contacertos, enable_contacertos;
    wire  [1:0] db_op, contaCaixa;
    wire [5:0] contagem_acertos;
    wire [3:0] db_estado;
    wire resetEdge;
    wire [7:0] respostaOut;
    wire [6:0] db_A, db_B;



    fluxo_dados FD (
        .clock                  (clock),
        .zeraE                  (zeraE),
        .enE                    (enE),
        .fimE                   (fimE),
        
        .enableDif              (enableDif),
        .dif_input              (dif_input),
        .clear_contacertos      (clear_contacertos),
        .enable_contacertos     (enable_contacertos),
        .contagem_acertos       (contagem_acertos),
        
        .fimL                   (fimL),
        .addU                   (addU),
        .addD                   (addD),
        .addC                   (addC),
        .subU                   (subU),
        .subD                   (subD),
        .subC                   (subC),
        .zeraCtrl               (zeraCtrl),
        .enableCtrl             (enableCtrl),
        .resetEdge              (resetEdge),
        .clearReg               (clearReg),
        .regEnable              (regEnable),
        .respostaOut            (respostaOut),
        .acertoJog              (acertoJog),
        .db_A                   (db_A),
        .db_B                   (db_B),
        .db_op                  (db_op),
        .db_addr                (),
        .contaCaixa             (contaCaixa)
    );

    unidade_controle UC (
        .clock                  (clock),
        .reset                  (reset),
        .jogar                  (jogar),
        .enter                  (enter),
        .acerto                 (acertoJog),
        .fimJogo                (fimL),
        .zeraCtrl               (zeraCtrl),
        .enableCtrl             (enableCtrl),
        .clearReg               (clearReg),
        .regEnable              (regEnable),
        .enE                    (enE),
        .zeraE                  (zeraE),
        .resetEdge              (resetEdge),
        .db_fim                 (),
        .db_estado              (db_estado),
        .enableDif              (enableDif),
        .clear_contacertos      (clear_contacertos),
        .enable_contacertos     (enable_contacertos)
    );

    bin2disp IC ( //INPUT CONTROL
        .bin_in                 (respostaOut),
        .disp1                  (dispC_respostaOut),
        .disp2                  (dispD_respostaOut),
        .disp3                  (dispU_respostaOut)
    );

    bin2disp acertos (
        .bin_in                 ({2'b00, contagem_acertos}),
        .disp1                  (),
        .disp2                  (dispD_acertos),
        .disp3                  (dispU_acertos) 
    );

    //DISPLAY COMPRADOS
    wire [6:0] dispU_A, dispD_A, dispC_A, dispU_B, dispD_B, dispC_B, dispOP, dispIg;
    bin2disp hexA (
        .bin_in                 ({1'b0, db_A}),
        .disp1                  (dispC_A),
        .disp2                  (dispD_A),
        .disp3                  (dispU_A)
    );
    bin2disp hexB (
        .bin_in                 ({1'b0, db_B}),
        .disp1                  (dispC_B),
        .disp2                  (dispD_B),
        .disp3                  (dispU_B)
    );
    op2disp hexOp (
        .op                     ({1'b0, db_op}),
        .dispOp                 (dispOP)
    );
    op2disp hexIg (
        .op                     (3'b100),
        .dispOp                 (dispIg)
    );

    estado7seg dispEstado (
        .estado({1'b0, db_estado}),
        .display(disp_estado)
    );

    assign caixa1 = (contaCaixa == 2'b00) ? dispU_A :
                    (contaCaixa == 2'b01) ? dispD_A :
                    (contaCaixa == 2'b10) ? dispC_A :
                    dispOP;
    assign caixa2 = (contaCaixa == 2'b00) ? dispU_B :
                    (contaCaixa == 2'b01) ? dispD_B :
                    (contaCaixa == 2'b10) ? dispC_B :
                    dispIg;

    decoderCaixa decoder(
		.contaCaixa(contaCaixa), 
		.Ds(Ds)
    );
    assign DP = 1'b1;

endmodule