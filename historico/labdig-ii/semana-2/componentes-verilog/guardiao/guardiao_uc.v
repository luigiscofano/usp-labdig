module guardiao_uc (
    input iniciar,
    input clock,
    input reset,


    // Contador 1s
    output zera_1s,
    output conta_1s,
    input fim_1s,

    // Contador 3s
    output zera_3s,
    output conta_3s,
    input fim_3s,

    // Contador 5s
    output zera_5s,
    output conta_5s,
    input fim_5s,

    // Medidor de distância
    output iniciar_medida_distancia,
    input pronto_medida,

    // Registrador da primeira medida
    output clear_registrador,
    output registra_medida0

    // Detector de movimento
    input mexeu
);
    reg [3:0] Eatual, Eprox;


    parameter ESPERA         = 4'b0000; // 0
    parameter ESPERA_INICIAL = 4'b0001; // 1
    parameter OLHA_PESSOA    = 4'b0010; // 2
    parameter PEGA_MEDIDA0   = 4'b0011; // 3
    parameter ESPERA_3S      = 4'b0100; // 4
    parameter PEGA_MEDIDA1   = 4'b0101; // 5
    parameter VERIFICA_MOV   = 4'b0110; // 6
    parameter OLHA_PAREDE    = 4'b0111; // 7
    parameter TX_FIM_MOV     = 4'b1000; // 8
    parameter ESPERA_5S      = 4'b1001; // 9
    parameter GANHOU         = 4'b1010; // 10
    parameter PERDEU         = 4'b1011; // 11
    

    always @(posedge clock or posedge reset) begin
        if (reset)
            Eatual <= ESPERA;
        else
            Eatual <= Eprox;
    end
    // Lógica de próximo estado
    always @(*) begin
        case (Eatual)
            ESPERA:
                if (iniciar)
                    Eprox = ESPERA_INICIAL;
                else
                    Eprox = ESPERA;

            ESPERA_INICIAL:
                if(fim_3s)
                    Eprox = OLHA_PESSOA;
                else
                    Eprox = ESPERA_INICIAL;
            OLHA_PESSOA:
                if(fim_1s)
                    Eprox = PEGA_MEDIDA0;
                else
                    Eprox = OLHA_PESSOA;
            PEGA_MEDIDA0:
                if(pronto_medida)
                    Eprox = ESPERA_3S;
                else
                    Eprox = PEGA_MEDIDA0;
            ESPERA_3S:
                if(fim_3s)
                    Eprox = PEGA_MEDIDA1;
                else
                    Eprox = ESPERA_3S;
            PEGA_MEDIDA1:
                if(pronto_medida)
                    Eprox = VERIFICA_MOV;
                else
                    Eprox = PEGA_MEDIDA1;
            VERIFICA_MOV:
                if(!mexeu)
                    Eprox = OLHA_PAREDE;
                else
                    Eprox = PERDEU;
            default:
                Eprox = ESPERA;
        endcase
    end
endmodule