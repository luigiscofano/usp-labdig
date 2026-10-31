module medidor_distancia (
    input        clock,
    input        reset,

    input        iniciar,     

    // sensor HC-SR04
    input        echo,
    output       trigger,

    // saída final
    output [11:0] medida_final,
    output        pronto,
    output [6:0]  hex_db_estado
);

    wire medir_hcsr04, hcsr04_pronto, hcsr04_timeout;

    wire zera_contador_4_medidas, conta_contador_4_medidas, fim_todas_medidas;

    wire pegar_medida, zera_media, zero_medidas;

    wire medida_valida;

    wire armazena_medida_final;

    wire [3:0] db_estado;
    medidor_distancia_uc medidor_distancia_UC (
        .clock                     (clock),
        .reset                     (reset),
        .iniciar                   (iniciar),
        .hcsr04_pronto             (hcsr04_pronto),
        .hcsr04_timeout            (hcsr04_timeout),
        .fim_4_medidas             (fim_todas_medidas),
        .medida_valida             (medida_valida),
		  .zero_medidas				  (zero_medidas),

        .pegar_medida              (pegar_medida),
        .medir_hcsr04              (medir_hcsr04),
        .conta_contador_4_medidas  (conta_contador_4_medidas),
        .zera_contador_4_medidas   (zera_contador_4_medidas),
        .zera_media                (zera_media),
        .armazena_medida_final     (armazena_medida_final),
        .pronto                    (pronto),
        .db_estado                 (db_estado)
    );

    medidor_distancia_fd u_fd (
        .clock                     (clock),
        .reset                     (reset),
        .medir                     (medir_hcsr04),
        .echo                      (echo),
        .trigger                   (trigger),
        .hcsr04_pronto             (hcsr04_pronto),
        .hcsr04_timeout            (hcsr04_timeout),

        .zera_contador_4_medidas   (zera_contador_4_medidas),
        .conta_contador_4_medidas  (conta_contador_4_medidas),
        .fim_todas_medidas         (fim_todas_medidas),

        .pegar_medida              (pegar_medida),
        .zera_media                (zera_media),
		  .zero_medidas			  (zero_medidas),

        .medida_valida             (medida_valida),

        .armazena_medida_final     (armazena_medida_final),
        .medida_final              (medida_final)
    );

    hexa7seg disp_medidor (
        .hexa(db_estado),
        .display(hex_db_estado)
    );

endmodule
