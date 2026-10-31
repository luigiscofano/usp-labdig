module medidor_distancia_uc (
    input  clock,
    input  reset,
    input  iniciar,               
    input  hcsr04_pronto,        
    // input  timeout,              
    input  fim_4_medidas,        

    output reg pegar_medida,
    output reg medir_hcsr04,
    output reg conta_contador_4_medidas,
    output reg zera_contador_4_medidas,
    output reg zera_media,
    output reg armazena_medida_final,
    output reg pronto
);

    // Parâmetros dos estados
    parameter ESPERA        = 3'b000; // 0
    parameter INICIA_MEDIDA = 3'b001; // 1
    parameter MEDINDO         = 3'b010; // 2
    parameter ARMAZENA      = 3'b011; // 3
    parameter PROXIMO       = 3'b100; // 4
    parameter FIM           = 3'b101; // 5

    reg [2:0] Eatual, Eprox;

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
                    Eprox = INICIA_MEDIDA;
                else
                    Eprox = ESPERA;
                    
            INICIA_MEDIDA:
                Eprox = MEDINDO;

            MEDINDO:
                if (hcsr04_pronto)
                    Eprox = PROXIMO;
                else
                    Eprox = MEDINDO;

            PROXIMO:
                if (fim_4_medidas)
                    Eprox = FIM;
                else
                    Eprox = INICIA_MEDIDA;
            FIM:
                Eprox = ESPERA;
            default:
                Eprox = ESPERA;
        endcase
    end

    // Saídas de controle
    always @(*) begin
        //interface hcsr04
        medir_hcsr04 = (Eatual == INICIA_MEDIDA) ? 1'b1 : 1'b0;
        
        //contador
        conta_contador_4_medidas = (Eatual == PROXIMO) ? 1'b1 : 1'b0;
        zera_contador_4_medidas = (Eatual == ESPERA) ? 1'b1 : 1'b0;
        
        //media
        zera_media = (Eatual == ESPERA) ? 1'b1 : 1'b0;
        pegar_medida = (Eatual == PROXIMO) ? 1'b1 : 1'b0;
        
        //registrador
        armazena_medida_final = (Eatual == FIM) ? 1'b1 : 1'b0;
        
        
        pronto = (Eatual == FIM) ? 1'b1 : 1'b0;
    end

endmodule
