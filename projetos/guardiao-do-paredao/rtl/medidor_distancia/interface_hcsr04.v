/* --------------------------------------------------------------------------
 *  Arquivo   : interface_hcsr04.v
 *  Descricao : top-level da interface com o sensor hcsr04
 *              integra UC + FD + timeout + sinal de abandono
 * -------------------------------------------------------------------------- */

module interface_hcsr04 (
    input  wire         clock,
    input  wire         reset,
    input  wire         medir,
    input  wire         echo,
    output wire         trigger,
    output wire [11:0]  medida,
    output wire         pronto,
    output wire         abandono,   // NOVO: 1 se leitura foi abandonada
    output wire [3:0]   db_estado
);

    // Sinais internos
    wire        s_zera;
    wire        s_gera;
    wire        s_registra;
    wire        s_fim_medida;
    wire        s_timeout;
    wire [11:0] s_medida;

    // Sinal de "estamos no estado espera_echo" decodificado de db_estado
    wire        s_espera_echo;

    // Unidade de controle
    interface_hcsr04_UC U1 (
        .clock     (clock       ),
        .reset     (reset       ),
        .medir     (medir       ),
        .echo      (echo        ),
        .fim_medida(s_fim_medida),
        .timeout   (s_timeout   ), // NOVO
        .zera      (s_zera      ),
        .gera      (s_gera      ),
        .registra  (s_registra  ),
        .pronto    (pronto      ),
        .abandono  (abandono    ), // NOVO
        .esperando_echo(s_espera_echo),
        .db_estado (db_estado   )
    );


    // Fluxo de dados
    interface_hcsr04_FD U2 (
        .clock      (clock        ),
        .pulso      (echo         ), // echo do sensor
        .zera       (s_zera       ),
        .gera       (s_gera       ),
        .registra   (s_registra   ),
        .espera_echo(s_espera_echo),
        .fim_medida (s_fim_medida ),
        .trigger    (trigger      ),
        .fim        (             ), // não usado
        .distancia  (s_medida     ),
        .timeout    (s_timeout    )  // NOVO
    );

    // Saída da medida
    assign medida = s_medida;

endmodule
