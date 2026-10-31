`timescale 1ns/1ps

module tb_medidor_distancia();

    reg clock = 0;
    reg reset = 0;

    reg iniciar = 0;
    reg echo = 0;

    wire trigger;
    wire [11:0] medida_final;
    wire pronto;

    // DUT
    medidor_distancia DUT(
        .clock        (clock),
        .reset        (reset),
        .iniciar      (iniciar),
        .echo         (echo),
        .trigger      (trigger),
        .medida_final (medida_final),
        .pronto       (pronto)
    );

    // 50 MHz → 20 ns período
    always #10 clock = ~clock;

    initial begin

        // Reset
        reset = 1;
        #100;
        reset = 0;
        #100;

        // Pulso de iniciar
        iniciar = 1;
        #40;
        iniciar = 0;

        // -------------------------------------------------
        // 1ª medição — cria um pulso echo de 150 us
        // -------------------------------------------------
        #200;      // espera trigger interno
        echo = 1;
        #150000;  // 150 us
        echo = 0;

        #20000;    // aguarda UC avançar para próxima medição

        // -------------------------------------------------
        // 2ª medição — pulso de 160 us
        // -------------------------------------------------
        echo = 1;
        #160_000;
        echo = 0;

        #20000;

        // -------------------------------------------------
        // 3ª medição — pulso de 140 us
        // -------------------------------------------------
        echo = 1;
        #140000;
        echo = 0;

        #20000;

        // -------------------------------------------------
        // 4ª medição — pulso de 155 us
        // -------------------------------------------------
        echo = 1;
        #155000;
        echo = 0;

        // -------------------------------------------------
        // Aguarda a UC finalizar as 4 medições
        // -------------------------------------------------
        wait(pronto == 1);

        #200;
    end


endmodule
