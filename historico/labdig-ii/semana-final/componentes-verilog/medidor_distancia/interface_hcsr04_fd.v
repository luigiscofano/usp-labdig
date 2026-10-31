/* --------------------------------------------------------------------------
 *  Arquivo   : interface_hcsr04_fd.v
 *  Descricao : fluxo de dados do circuito de interface com sensor hcsr04
 *              + lógica de timeout (até ~8 m)
 * -------------------------------------------------------------------------- */

module interface_hcsr04_FD (
    input  wire        clock,   
    input  wire        pulso,         // echo do sensor
    input  wire        zera,          // reset interno da interface
    input  wire        gera,          // comando para gerar trigger
    input  wire        registra,      // armazena medida
    input  wire        espera_echo,   // ativo enquanto UC está em espera_echo
    output wire        fim_medida,    // fim da contagem de cm
    output wire        trigger,       // trigger para o hcsr04
    output wire        fim,           // fim do contador BCD (999 cm)
    output wire [11:0] distancia,     // medida em BCD (3 dígitos)
    output wire        timeout        // time-out de echo
);

    // Sinais internos
    wire [11:0] s_medida;

    // U1) TRIGGER de 10 us @ 50 MHz -> 500 clocks
    gerador_pulso #(
        .largura(500) 
    ) U1 (
        .clock (clock  ),
        .reset (zera   ),
        .gera  (gera   ),
        .para  (1'b0   ),
        .pulso (trigger),
        .pronto(/* não usado */)
    );

    // U2) Contagem em cm (R=2941 clocks ≈ 58 us @ 50 MHz)

    contador_cm #(
        .R(2941), 
        .N(12)
    ) U2 (
        .clock  (clock           ),
        .reset  (zera            ),
        .pulso  (pulso           ),
        .digito2(s_medida[11:8]  ),
        .digito1(s_medida[7:4]   ),
        .digito0(s_medida[3:0]   ),
        .fim    (fim             ),
        .pronto (fim_medida      )
    );

    // U3) Registrador da medida (3 dígitos BCD = 12 bits)
    registrador_n #(
        .N(12)
    ) U3 (
        .clock  (clock    ),
        .clear  (zera     ),
        .enable (registra ),
        .D      (s_medida ),
        .Q      (distancia)
    );

    // U4) Timeout do echo (até ~50 ms => ~ 8 m)
    time_out_hcsr04 #(
        .TIMEOUT(2_500_000) // ~50 ms @ 50 MHz
    ) U_TIMEOUT (
        .clock  (clock       ),
        .reset  (zera        ),
        .enable (espera_echo ),
        .echo   (pulso       ),
        .timeout(timeout     )
    );

endmodule
