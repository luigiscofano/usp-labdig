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
    output db_fim,
    output [6:0] disp1_respostaOut,
    output [6:0] disp2_respostaOut,
    output [6:0] disp3_respostaOut,
    output [6:0] db_A,
    output [6:0] db_B,
    output [5:0] db_addr,
    output [5:0] contagem_acertos,
    output [6:0] caixa1,
    output [6:0] caixa2,
    output [3:0] Ds,
    output DP
);

    wire zeraE, enE, fimE, fimL, zeraCtrl, enableCtrl, resetControls;
    wire clearReg, regEnable;
    wire enableDif, clear_contacertos, enable_contacertos;
    wire  [1:0] db_op, contaCaixa;


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
        .db_addr                (db_addr),
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
        .db_fim                 (db_fim),
        .db_estado              (db_estado),
        .enableDif              (enableDif),
        .clear_contacertos      (clear_contacertos),
        .enable_contacertos     (enable_contacertos)
    );

    bin2disp IC (
        .bin_in                 (respostaOut),
        .disp1                  (disp1_respostaOut),
        .disp2                  (disp2_respostaOut),
        .disp3                  (disp3_respostaOut)
    );

    //DISPLAY COMPRADOS
    wire [6:0] disp1_A, disp2_A, disp3_A, disp1_B, disp2_B, disp3_B, dispOP, dispIg;
    bin2disp hexA (
        .bin_in                 (db_A),
        .disp1                  (disp1_A),
        .disp2                  (disp2_A),
        .disp3                  (disp3_A)
    );
    bin2disp hexB (
        .bin_in                 (db_B),
        .disp1                  (disp1_B),
        .disp2                  (disp2_B),
        .disp3                  (disp3_B)
    );
    op2disp hexOp (
        .op                     ({1'b0, db_op}),
        .dispOp                 (dispOp)
    );
    op2disp hexIg (
        .op                     (3'b100),
        .dispOp                 (dispIg)
    );

    assign caixa1 = (contaCaixa == 2'b00) ? disp1_A :
                    (contaCaixa == 2'b01) ? disp2_A :
                    (contaCaixa == 2'b10) ? disp3_A :
                    dispOp;
    assign caixa2 = (contaCaixa == 2'b00) ? disp1_B :
                    (contaCaixa == 2'b01) ? disp2_B :
                    (contaCaixa == 2'b10) ? disp3_B :
                    dispIg;

    decoderCaixa decoder(
		.contaCaixa(contaCaixa), 
		.Ds(Ds)
    );
    assign DP = 1'b1;

endmodule