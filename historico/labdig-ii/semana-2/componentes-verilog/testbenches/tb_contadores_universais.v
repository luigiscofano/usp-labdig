`timescale 1ns/1ps

module tb_contadores_universais();

    // Sinais da DUT
    reg clock;
    reg [1:0] escolhe_contador;
    reg zera_contadores;
    reg conta_contadores;
    wire fim_contador;

    // Instância do módulo
    contadores_universais #(.clock_frequency(5), .largura(3)) dut (
        .clock           (clock),
        .escolhe_contador(escolhe_contador),
        .zera_contadores (zera_contadores),
        .conta_contadores(conta_contadores),
        .fim_contador    (fim_contador)
    );

    initial begin
        clock = 0;
        forever #1 clock = ~clock;
    end

    // Procedimento de teste
    initial begin
        conta_contadores  = 0;

        //1s
        escolhe_contador  = 2'b00;
        
        zera_contadores   = 1;
        #4;
        zera_contadores = 0;
        conta_contadores  = 1;

        #40;
        zera_contadores = 1; 
        conta_contadores  = 0;


        //2s
        escolhe_contador  = 2'b01;
        
        #4;
        zera_contadores = 0;
        conta_contadores  = 1;
        #40;
        zera_contadores = 1; 
        conta_contadores  = 0;

        //3s
        escolhe_contador  = 2'b10;
        #4;
        zera_contadores = 0;
        conta_contadores  = 1;

        #40;
        zera_contadores = 1; 
        conta_contadores  = 0;

        //5s
        escolhe_contador  = 2'b10;
        
        #4;
        zera_contadores = 0;
        conta_contadores  = 1;

        #40;
        zera_contadores = 1;
    end

endmodule
