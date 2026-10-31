module guardiao_fd (
    input clock,
    input reset,
    
    // Contador 1s
    input zera_1s,
    input conta_1s,
    output fim_1s,

    // Contador 3s
    input zera_3s,
    input conta_3s,
    output fim_3s,

    // Contador 5s
    input zera_5s,
    input conta_5s,
    output fim_5s,

    // Medidor de distância
    input iniciar_medida_distancia,
    input echo,
    output trigger,
    output pronto_medida,

    // Registrador da primeira medida
    input clear_registrador,
    input registra_medida0,

    // Detector de movimento
    output mexeu,

    // Displays 7 segmentos
    output [6:0] medida_0_unidade,
    output [6:0] medida_0_dezena,
    output [6:0] medida_0_centena,
    output [6:0] medida_1_unidade,
    output [6:0] medida_1_dezena,
    output [6:0] medida_1_centena
);
    contador_m #(.M(50_000_000), .N(26)) timer_1s (
        .clock   (clock),
        .zera_as (1'b0),
        .zera_s  (zera_1s),
        .conta   (conta_1s),
        .Q       (),
        .fim     (fim_1s),
        .meio    ()
    );

    contador_m #(.M(150_000_000), .N(28)) timer_3s (
        .clock   (clock),
        .zera_as (1'b0),
        .zera_s  (zera_3s),
        .conta   (conta_3s),
        .Q       (),
        .fim     (fim_3s),
        .meio    ()
    );
    
    contador_m #(.M(250_000_000), .N(28)) timer_5s (
        .clock   (clock),
        .zera_as (1'b0),
        .zera_s  (zera_5s),
        .conta   (conta_5s),
        .Q       (),
        .fim     (fim_5s),
        .meio    ()
    );

    wire [11:0] wire_medida1;
    medidor_distancia medidor (
        .clock      (clock),
        .reset      (reset),
        .iniciar    (iniciar_medida_distancia),
        
        // sensor HC-SR04
        .echo       (echo),
        .trigger    (trigger),
        
        .medida_final  (wire_medida1),
        .pronto        (pronto_medida)
    );


    wire [11:0] wire_medida0;
    registrador_n #(.N(12)) registrador_medida_0 (
        .clock  (clock),
        .clear  (clear_registrador),
        .enable (registra_medida0),
        .D      (wire_medida1),
        .Q      (wire_medida0)
    );

    move_dection detector_movimento (
        .medida0   (wire_medida0),
        .medida1   (wire_medida1),
        .mexeu      (mexeu)
    );
    

endmodule