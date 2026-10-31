module medidor_distancia_fd (
    input          clock,
    input          reset,
    input          medir,
    input          echo,
    output         trigger,
    output         hcsr04_pronto,
    
    // Contador
    input          zera_contador_4_medidas,
    input          conta_contador_4_medidas,
    output         fim_todas_medidas,
    
    // Média
    input          pegar_medida,
    input          zera_media,
    
    //Registrador
    input          armazena_medida_final,
    output [11:0]  medida_final
);
    wire [11:0] medida_bcd;     // distancia medida por hcsr04 em bcd
    
    interface_hcsr04 u_hcsr04 (
        .clock   (clock),
        .reset   (reset),
        .medir   (medir),
        .echo    (echo),
        .trigger (trigger),
        .medida  (medida_bcd),
        .pronto  (hcsr04_pronto)
    );

    contador_m #(.M(4), .N(2)) u_contador (
        .clock   (clock),
        .zera_as (zera_contador_4_medidas),
        .zera_s  (1'b0),
        .conta   (conta_contador_4_medidas),
        .Q       (),
        .fim     (fim_todas_medidas),
        .meio    ()
    );


    wire [11:0] wire_medida_final;
    media_bcd media_bcd (
        .clock            (clock),
        .zera_media       (zera_media),
        .pegar_medida     (pegar_medida),
        .medida_bcd       (medida_bcd),
        .medida_final_bcd (wire_medida_final)
    );
    
    // wire [9:0]  medida_bin;    //distancia medida por hcsr04 em binário
    
    // conversor_bcd_2_bin bcd_pra_bin (
    //     .num_bcd (medida_bcd),
    //     .num_bin (medida_bin) 
    // );


    // wire [9:0]  medida_media;
    // media_bin u_media (
    //     .clock            (clock),
    //     .zera             (zera_media),
    //     .recebeu_medida   (pegar_medida),
    //     .valor_medida     (medida_bin),
    //     .medida_media     (medida_media)
    // );

    // wire [11:0] wire_medida_final;
    // conversor_bin_2_bcd bin_para_bcd     (
    //     .num_bin  (medida_media),
    //     .num_bcd  (wire_medida_final)
    // );
    

    registrador_n #(.N(12)) u_reg_medida_final (
        .clock   (clock),
        .clear   (zera_media),
        .enable  (armazena_medida_final),
        .D       (wire_medida_final),
        .Q       (medida_final)
    );

endmodule
