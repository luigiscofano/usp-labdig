module guardiao (
    input clock,
    input reset,
    input iniciar,

    // LEDs
    input  sensibilidade_luz,
    output luz_verde,
    output luz_vermelha,

    // Sensor HC-SR04
    input  echo,
    output trigger,

    // Transmissão serial
    output saida_serial,

    // Servo motor
    output pwm,

    // Displays
    output [6:0] hex_db_estado
);

    //
    // Fios UC → FD
    //
    wire zera_1s, conta_1s, fim_1s;
    wire zera_3s, conta_3s, fim_3s;
    wire zera_5s, conta_5s, fim_5s;

    wire iniciar_medida_distancia;
    wire pronto_medida;

    wire clear_registrador;
    wire registra_medida0;

    wire mexeu, flag_ganhou;

    wire iniciar_tx;
    wire estado_semaforo;
    wire [1:0] estado_jogo;
    wire fim_tx;

    wire olha_frente;
    wire guarda_pos;

    wire enable_estado_jogo;
    wire zera_estado_jogo;

    wire [4:0] db_estado;
	 
	edge_detector edge_iniciar (
        .clock(clock),
        .reset(reset),
        .sinal(iniciar),
        .pulso(pulso_iniciar)
    );
	 
    guardiao_uc UC (
        .iniciar(pulso_iniciar),
        .clock(clock),
        .reset(reset),

        // Contadores
        .zera_1s(zera_1s),
        .conta_1s(conta_1s),
        .fim_1s(fim_1s),

        .zera_3s(zera_3s),
        .conta_3s(conta_3s),
        .fim_3s(fim_3s),

        .zera_5s(zera_5s),
        .conta_5s(conta_5s),
        .fim_5s(fim_5s),

        // Medidor
        .iniciar_medida_distancia(iniciar_medida_distancia),
        .pronto_medida(pronto_medida),

        // Registrador medida0
        .clear_registrador(clear_registrador),
        .registra_medida0(registra_medida0),

        // Movimento
        .mexeu(mexeu),
        .flag_ganhou(flag_ganhou),

        // Transmissão
        .iniciar_tx(iniciar_tx),
        .estado_semaforo(estado_semaforo),
        .estado_jogo(estado_jogo),
        .fim_tx(fim_tx),

        // Servo
        .olha_frente(olha_frente),
        .guarda_pos(guarda_pos),

        // Estado do jogo
        .enable_estado_jogo(enable_estado_jogo),
        .zera_estado_jogo(zera_estado_jogo),

        //LEDs
        .sensibilidade_luz(sensibilidade_luz),
        .luz_verde(luz_verde),
        .luz_vermelha(luz_vermelha),

        .db_estado(db_estado)
    );

    guardiao_fd FD (
        .clock(clock),
        .reset(reset),

        // Contadores
        .zera_1s(zera_1s),
        .conta_1s(conta_1s),
        .fim_1s(fim_1s),

        .zera_3s(zera_3s),
        .conta_3s(conta_3s),
        .fim_3s(fim_3s),

        .zera_5s(zera_5s),
        .conta_5s(conta_5s),
        .fim_5s(fim_5s),

        // Medida distância
        .iniciar_medida_distancia(iniciar_medida_distancia),
        .echo(echo),
        .trigger(trigger),
        .pronto_medida(pronto_medida),

        // Registrador primeira medida
        .clear_registrador(clear_registrador),
        .registra_medida0(registra_medida0),

        // Movimento
        .mexeu(mexeu),
        .flag_ganhou(flag_ganhou),

        // TX
        .iniciar_tx(iniciar_tx),
        .estado_semaforo(estado_semaforo),
        .estado_jogo(estado_jogo),
        .saida_serial(saida_serial),
        .fim_tx(fim_tx),

        // Servo
        .olha_frente(olha_frente),
        .guarda_pos(guarda_pos),
        .pwm(pwm),

        // Estado do jogo
        .enable_estado_jogo(enable_estado_jogo),
        .zera_estado_jogo(zera_estado_jogo),

        // Displays
        .medida_0_unidade(),
        .medida_0_dezena(),
        .medida_0_centena(),
        .medida_1_unidade(),
        .medida_1_dezena(),
        .medida_1_centena()
    );

    hexa7seg display0 (
        .hexa(db_estado[3:0]),
        .display(hex_db_estado)
    );

endmodule
