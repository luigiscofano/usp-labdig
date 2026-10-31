`timescale 1ns/1ps

module tb_tratar_tx_dados;

    reg clock;
    reg reset;
    reg iniciar_tx;
    wire saida_serial;
    wire fim_tx;

    // Instância do DUT top-level de teste
    test_tratar_tx_dados DUT (
        .clock(clock),
        .reset(reset),
        .iniciar_tx(iniciar_tx),
        .saida_serial(saida_serial),
        .fim_tx(fim_tx)
    );

    // -------------------------------
    // Clock 50 MHz (20 ns período)
    // -------------------------------
    initial begin
        clock = 0;
        forever #10 clock = ~clock;
    end

    // -------------------------------
    // Estímulos
    // -------------------------------
    initial begin
        // $display("==== INICIANDO TESTE ====");

        iniciar_tx = 0;
        reset = 1;
        #100;
        reset = 0;

        // Aguarda algumas dezenas de ciclos
        #200;

        // Inicia transmissão
        iniciar_tx = 1;
        #20;
        iniciar_tx = 0;

        // Agora a UC vai transmitir 13 caracteres + '#'
        // O serial_tx_7e1 demora bastante para cada caractere,
        // então damos tempo longo.

        wait(fim_tx);

        #2000;
    end

    // Monitor útil para debug
    // initial begin
    //     $monitor("[%0t] clk=%b reset=%b iniciar=%b fim_tx=%b tx=%b",
    //              $time, clock, reset, iniciar_tx, fim_tx, saida_serial);
    // end

endmodule
