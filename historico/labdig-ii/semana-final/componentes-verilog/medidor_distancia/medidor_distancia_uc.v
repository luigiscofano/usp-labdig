module medidor_distancia_uc (
    input  clock,
    input  reset,
    input  iniciar,               
    input  hcsr04_pronto,        
    input  hcsr04_timeout,              
    input  fim_4_medidas,
    input  medida_valida,   
    input  zero_medidas,     

    output reg pegar_medida,
    output reg medir_hcsr04,
    output reg conta_contador_4_medidas,
    output reg zera_contador_4_medidas,
    output reg zera_media,
    output reg armazena_medida_final,
    output reg pronto,
    output reg [3:0] db_estado
);

    // Parâmetros dos estados
    parameter ESPERA        = 4'b0000; // 0
    parameter INICIA_MEDIDA = 4'b0001; // 1
    parameter MEDINDO       = 4'b0010; // 2
    parameter AVALIA        = 4'b0011; // 3
    parameter SALVA         = 4'b0100; // 4
    parameter CHECA_FIM     = 4'b0101; // 5
    parameter PROXIMO       = 4'b0110; // 6
    parameter FIM           = 4'b0111; // 7
    parameter REFAZ         = 4'b1000; // 8

    reg [3:0] Eatual, Eprox;

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
                    Eprox = AVALIA;
                else
                    if(hcsr04_timeout)
                        Eprox = CHECA_FIM;
                    else
                        Eprox = MEDINDO;
            AVALIA:
                if(medida_valida)
                    Eprox = SALVA;
                else
                    Eprox = CHECA_FIM;
            SALVA:
                Eprox = CHECA_FIM;
            CHECA_FIM:
                if (fim_4_medidas)
                    if(zero_medidas)
                        Eprox = REFAZ;
                    else
                        Eprox = FIM;
                else
                    Eprox = PROXIMO;
            PROXIMO:
                Eprox = INICIA_MEDIDA;
            REFAZ:
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
        zera_contador_4_medidas = (Eatual == ESPERA || Eatual == REFAZ) ? 1'b1 : 1'b0;
        
        //media
        zera_media = (Eatual == ESPERA || Eatual == REFAZ) ? 1'b1 : 1'b0;
        pegar_medida = (Eatual == SALVA) ? 1'b1 : 1'b0;
        
        //registrador
        armazena_medida_final = (Eatual == FIM) ? 1'b1 : 1'b0;
        
        
        pronto = (Eatual == FIM) ? 1'b1 : 1'b0;
		  
        case(Eatual)
            ESPERA : db_estado = 4'h0;
            INICIA_MEDIDA : db_estado = 4'h1;
            MEDINDO : db_estado = 4'h2;
            AVALIA : db_estado = 4'h3;
            SALVA : db_estado = 4'h4;
            CHECA_FIM : db_estado = 4'h5;
            PROXIMO : db_estado = 4'h6;
            FIM : db_estado = 4'h7;
            REFAZ : db_estado = 4'h8;
        endcase
				
    end

endmodule
