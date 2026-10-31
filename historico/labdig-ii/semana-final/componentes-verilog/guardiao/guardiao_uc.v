module guardiao_uc (
    input iniciar,
    input clock,
    input reset,


    // Contador 1s
    output reg zera_1s,
    output reg conta_1s,
    input fim_1s,

    // Contador 3s
    output reg zera_3s,
    output reg conta_3s,
    input fim_3s,

    // Contador 5s
    output reg zera_5s,
    output reg conta_5s,
    input fim_5s,

    // Medidor de distância
    output reg iniciar_medida_distancia,
    input pronto_medida,

    // Registrador da primeira medida
    output reg clear_registrador,
    output reg registra_medida0,

    // Detector de movimento e checa_ganhou
    input mexeu,
    input flag_ganhou,


    // Transmissão de dados
    output reg iniciar_tx,
    output reg estado_semaforo,
    output reg [1:0] estado_jogo,
    input fim_tx,

    // Controlador servo
    output reg olha_frente,
    output reg guarda_pos,

    output reg enable_estado_jogo,
    output reg zera_estado_jogo,

    // LEDs
    input sensibilidade_luz,
    output reg  luz_verde,
    output reg  luz_vermelha,

    output reg [4:0] db_estado
);
    reg [4:0] Eatual, Eprox;


    parameter ESPERA          = 5'h00; // 0
    parameter ESPERA_INICIAL  = 5'h01; // 1
    parameter OLHA_PESSOA     = 5'h02; // 2
    parameter PEGA_MEDIDA0    = 5'h03; // 3
    parameter ESPERA_3S       = 5'h04; // 4
    parameter PEGA_MEDIDA1    = 5'h05; // 5
    parameter VERIFICA_MOV    = 5'h06; // 6
    parameter OLHA_PAREDE     = 5'h07; // 7
    parameter TX_FIM_MOV      = 5'h08; // 8
    parameter ESPERA_5S       = 5'h09; // 9
    parameter TX_INICIO_MOV   = 5'h0A; // A
    parameter GANHOU          = 5'h0B; // B
    parameter PERDEU          = 5'h0C; // C
    parameter TX_FINAL        = 5'h0D; // D
    parameter INICIA_MEDIDA0  = 5'h0E; // E
    parameter INICIA_MEDIDA1  = 5'h0F; // F
    parameter INICIA_TX0      = 5'h10; // 10
    parameter INICIA_TX1      = 5'h11; // 11
    parameter INICIA_TX_FINAL = 5'h12; // 12
    

    always @(posedge clock or posedge reset) begin
        if (reset)
            Eatual <= ESPERA;
        else
            Eatual <= Eprox;
    end
    
    // Lógica de próximo estado
    always @(*) begin
        case (Eatual)
            ESPERA: // 0
                if (iniciar)
                    Eprox = ESPERA_INICIAL;
                else
                    Eprox = ESPERA;
            ESPERA_INICIAL: // 1
                if(fim_3s)
                    Eprox = OLHA_PESSOA;
                else
                    Eprox = ESPERA_INICIAL;
            OLHA_PESSOA: // 2
                if(fim_1s)
                    Eprox = INICIA_MEDIDA0;
                else
                    Eprox = OLHA_PESSOA;
            PEGA_MEDIDA0: // 3
                if(pronto_medida)
                    Eprox = ESPERA_3S;
                else
                    Eprox = PEGA_MEDIDA0;
            ESPERA_3S: // 4
                if(fim_3s)
                    Eprox = INICIA_MEDIDA1;
                else
                    Eprox = ESPERA_3S;
            PEGA_MEDIDA1: // 5
                if(pronto_medida)
                    Eprox = VERIFICA_MOV;
                else
                    Eprox = PEGA_MEDIDA1;
            VERIFICA_MOV: // 6
                if(!mexeu)
                    if(flag_ganhou)
                        Eprox = GANHOU;
                    else
                        Eprox = OLHA_PAREDE;
                else
                    Eprox = PERDEU;
            OLHA_PAREDE: // 7
                Eprox = INICIA_TX0;
            TX_FIM_MOV: // 8
                if(fim_tx)
                    Eprox = ESPERA_5S;
                else
                    Eprox = TX_FIM_MOV;
            ESPERA_5S: // 9
                if(fim_5s)
                    Eprox = INICIA_TX1;
                else
                    Eprox = ESPERA_5S;
            TX_INICIO_MOV: // A
                if(fim_tx)
                    Eprox = OLHA_PESSOA;
                else
                    Eprox = TX_INICIO_MOV;
            GANHOU: // B
                Eprox = INICIA_TX_FINAL;
            PERDEU: // C
                Eprox = INICIA_TX_FINAL;
            TX_FINAL: // D
                if(fim_tx)
                    Eprox = ESPERA;
                else
                    Eprox = TX_FINAL;
            INICIA_MEDIDA0:
                Eprox = PEGA_MEDIDA0;
            INICIA_MEDIDA1:
                Eprox = PEGA_MEDIDA1;
            INICIA_TX0:
                Eprox = TX_FIM_MOV;
            INICIA_TX1:
                Eprox = TX_INICIO_MOV;
            INICIA_TX_FINAL:
                Eprox = TX_FINAL;
            default:
                Eprox = ESPERA;
        endcase
    end

    reg acende_luz;
    always @(*) begin
        zera_1s = (Eatual != OLHA_PESSOA);
        conta_1s = (Eatual == OLHA_PESSOA);

        zera_3s = (Eatual != ESPERA_INICIAL && Eatual != ESPERA_3S);
        conta_3s = (Eatual == ESPERA_INICIAL || Eatual == ESPERA_3S);

        zera_5s = (Eatual != ESPERA_5S);
        conta_5s = (Eatual == ESPERA_5S);

        iniciar_medida_distancia = (Eatual == INICIA_MEDIDA0 || Eatual == INICIA_MEDIDA1);

        clear_registrador = (Eatual == INICIA_MEDIDA0 || Eatual == ESPERA);
        registra_medida0 = (Eatual == ESPERA_3S);

        iniciar_tx = (Eatual == INICIA_TX0 || Eatual == INICIA_TX1 || Eatual == INICIA_TX_FINAL);
        estado_semaforo = (Eatual == INICIA_TX0 || Eatual == TX_FIM_MOV);
        
        estado_jogo = (Eatual == GANHOU) ? 2'b01 :
                      (Eatual == PERDEU) ? 2'b10 :
                      2'b00;
        enable_estado_jogo = (Eatual == GANHOU || Eatual == PERDEU);
        zera_estado_jogo = (Eatual == ESPERA_INICIAL);

        olha_frente = (Eatual == OLHA_PESSOA);
        guarda_pos = (Eatual == OLHA_PESSOA || Eatual == OLHA_PAREDE);

        acende_luz = !(sensibilidade_luz || Eatual == ESPERA || Eatual == ESPERA_INICIAL || Eatual == PERDEU || Eatual == GANHOU || Eatual == INICIA_TX_FINAL || Eatual == TX_FINAL);
        luz_verde = (acende_luz && (Eatual == OLHA_PAREDE || Eatual == INICIA_TX0 || Eatual == TX_FIM_MOV || Eatual == ESPERA_5S || Eatual == INICIA_TX1 || Eatual == TX_INICIO_MOV));
        luz_vermelha = (acende_luz && !luz_verde);

        case(Eatual) 
            ESPERA:          db_estado  = 5'h00; // 0
            ESPERA_INICIAL:  db_estado  = 5'h01; // 1
            OLHA_PESSOA:     db_estado  = 5'h02; // 2
            PEGA_MEDIDA0:    db_estado  = 5'h03; // 3
            ESPERA_3S:       db_estado  = 5'h04; // 4
            PEGA_MEDIDA1:    db_estado  = 5'h05; // 5
            VERIFICA_MOV:    db_estado  = 5'h06; // 6
            OLHA_PAREDE:     db_estado  = 5'h07; // 7
            TX_FIM_MOV:      db_estado  = 5'h08; // 8
            ESPERA_5S:       db_estado  = 5'h09; // 9
            TX_INICIO_MOV:   db_estado  = 5'h0A; // A
            GANHOU:          db_estado  = 5'h0B; // B
            PERDEU:          db_estado  = 5'h0C; // C
            TX_FINAL:        db_estado  = 5'h0D; // D
            INICIA_MEDIDA0:  db_estado  = 5'h0E; // E
            INICIA_MEDIDA1:  db_estado  = 5'h0F; // F
            INICIA_TX0:      db_estado  = 5'h10; // 10
            INICIA_TX1:      db_estado  = 5'h11; // 11
            INICIA_TX_FINAL: db_estado = 5'h12; // 12
        endcase
    end
endmodule