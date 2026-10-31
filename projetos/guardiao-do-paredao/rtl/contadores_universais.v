/*
 * Depois perguntar se contador_m para M=2 tem N=1 ou N=2
 * escolhe_contador:
 *   00 -> contador de 1 segundo
 *   01 -> contador de 2 segundos
 *   10 -> contador de 3 segundos
 *   11 -> contador de 5 segundos
*/
module contadores_universais #(parameter clock_frequency=50_000_000, largura=26)
(
    input        clock,
    input  [1:0] escolhe_contador,
    input        zera_contadores,
    input        conta_contadores,
    output       fim_contador
);

    wire fim_contador_1s, fim_contador_2s, fim_contador_3s, fim_contador_5s;

    // Clock de 50MHz, cada segundo é 50.000.000 ciclos
    contador_m #(.M(clock_frequency), .N(largura)) contador_1_segundo (
        .clock   (clock),
        .zera_as (zera_contadores),
        .zera_s  (1'b0),
        .conta   (conta_contadores),
        .Q       (),
        .fim     (fim_contador_1s),
        .meio    ()
    );

    contador_m #(.M(2), .N(2)) contador_2s (
        .clock   (clock),
        .zera_as (zera_contadores),
        .zera_s  (1'b0),
        .conta   (fim_contador_1s & conta_contadores),
        .Q       (),
        .fim     (fim_contador_2s),
        .meio    ()
    );

    contador_m #(.M(3), .N(2)) contador_3s (
        .clock   (clock),
        .zera_as (zera_contadores),
        .zera_s  (1'b0),
        .conta   (fim_contador_1s & conta_contadores),
        .Q       (),
        .fim     (fim_contador_3s),
        .meio    ()
    );

    contador_m #(.M(5), .N(3)) contador_5s (
        .clock   (clock),
        .zera_as (zera_contadores),
        .zera_s  (1'b0),
        .conta   (fim_contador_1s & conta_contadores),
        .Q       (),
        .fim     (fim_contador_5s),
        .meio    ()
    );

    assign fim_contador = (escolhe_contador == 2'b00) ? fim_contador_1s :
                          (escolhe_contador == 2'b01) ? fim_contador_2s :
                          (escolhe_contador == 2'b10) ? fim_contador_3s :
                                                        fim_contador_5s;
endmodule