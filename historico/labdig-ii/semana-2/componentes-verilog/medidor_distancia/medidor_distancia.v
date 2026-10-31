module medidor_distancia (
    input        clock,
    input        reset,

    input        iniciar,     

    // sensor HC-SR04
    input        echo,
    output       trigger,

    // saída final
    output [11:0] medida_final,
    output        pronto
);

    wire medir_hcsr04;
    wire hcsr04_pronto;

    wire zera_contador_4_medidas;
    wire conta_contador_4_medidas;
    wire fim_todas_medidas;

    wire pegar_medida;
    wire zera_media;

    wire armazena_medida_final;

    medidor_distancia_uc medidor_distancia_UC (
        .clock                     (clock),
        .reset                     (reset),
        .iniciar                   (iniciar),
        .hcsr04_pronto             (hcsr04_pronto),
        .fim_4_medidas             (fim_todas_medidas),

        .pegar_medida              (pegar_medida),
        .medir_hcsr04              (medir_hcsr04),
        .conta_contador_4_medidas  (conta_contador_4_medidas),
        .zera_contador_4_medidas   (zera_contador_4_medidas),
        .zera_media                (zera_media),
        .armazena_medida_final     (armazena_medida_final),
        .pronto                    (pronto)
    );

    medidor_distancia_fd u_fd (
        .clock                     (clock),
        .reset                     (reset),
        .medir                     (medir_hcsr04),
        .echo                      (echo),
        .trigger                   (trigger),
        .hcsr04_pronto             (hcsr04_pronto),

        .zera_contador_4_medidas   (zera_contador_4_medidas),
        .conta_contador_4_medidas  (conta_contador_4_medidas),
        .fim_todas_medidas         (fim_todas_medidas),

        .pegar_medida              (pegar_medida),
        .zera_media                (zera_media),

        .armazena_medida_final     (armazena_medida_final),
        .medida_final              (medida_final)
    );

endmodule
