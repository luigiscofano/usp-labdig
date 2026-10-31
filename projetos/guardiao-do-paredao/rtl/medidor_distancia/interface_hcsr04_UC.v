/* --------------------------------------------------------------------------
 *  Arquivo   : interface_hcsr04_uc.v
 *  Descricao : unidade de controle da interface com sensor hcsr04
 *              adicionando tratamento de timeout (abandono de leitura)
 * -------------------------------------------------------------------------- */

module interface_hcsr04_UC (
    input  wire       clock,
    input  wire       reset,
    input  wire       medir,
    input  wire       echo,
    input  wire       fim_medida,
    input  wire       timeout,      // NOVO: time-out vindo do FD
    output reg        zera,
    output reg        gera,
    output reg        registra,
    output reg        pronto,
    output reg        abandono,     // NOVO: 1 se leitura foi abandonada
    output reg        esperando_echo,
    output reg [3:0]  db_estado
);

    // Tipos e sinais
    reg [2:0] Eatual, Eprox; // 3 bits são suficientes para até 8 estados

    // Parâmetros para os estados
    localparam INICAL        = 3'b000;
    localparam PREPARACAO     = 3'b001;
    localparam ENVIA_TRIGGER  = 3'b010;
    localparam ESPERA_ECHO    = 3'b011;
    localparam MEDIDA         = 3'b100;
    localparam ARMAZENAMENTO  = 3'b101;
    localparam FINAL_MEDIDA   = 3'b110;
    localparam ABANDONO_ESTADO= 3'b111;  // NOVO: leitura abandonada por timeout

    // Estado
    always @(posedge clock, posedge reset) begin
        if (reset) 
            Eatual <= INICAL;
        else
            Eatual <= Eprox; 
    end

    // Próximo estado
    always @(*) begin
        case (Eatual)
            INICAL:
                Eprox = medir ? PREPARACAO : INICAL;

            PREPARACAO:
                Eprox = ENVIA_TRIGGER;

            ENVIA_TRIGGER:
                Eprox = ESPERA_ECHO;

            ESPERA_ECHO: begin
                if (timeout)
                    Eprox = ABANDONO_ESTADO;    // NOVO: estourou tempo
                else
                    Eprox = echo ? MEDIDA : ESPERA_ECHO;
            end

            MEDIDA:
                Eprox = fim_medida ? ARMAZENAMENTO : MEDIDA;
            ARMAZENAMENTO:
                Eprox = FINAL_MEDIDA;

            FINAL_MEDIDA:
                Eprox = INICAL;

            ABANDONO_ESTADO:
                Eprox = INICAL;               // volta para repouso

            default:
                Eprox = INICAL;
        endcase
    end

    // Saídas de controle (Moore)
    always @(*) begin
        // padrão para abandono
        zera     = (Eatual == PREPARACAO || Eatual == ABANDONO_ESTADO) ? 1'b1 : 1'b0;
        gera     = (Eatual == ENVIA_TRIGGER) ? 1'b1 : 1'b0;
        registra = (Eatual == ARMAZENAMENTO) ? 1'b1 : 1'b0;
        pronto   = (Eatual == FINAL_MEDIDA) ? 1'b1 : 1'b0;
        abandono = (Eatual == ABANDONO_ESTADO) ? 1'b1 : 1'b0;
        esperando_echo = (Eatual == ESPERA_ECHO) ? 1'b1 : 1'b0;

        // Debug de estado
        case (Eatual)
            INICAL:          db_estado = 4'b0000;
            PREPARACAO:      db_estado = 4'b0001;
            ENVIA_TRIGGER:   db_estado = 4'b0010;
            ESPERA_ECHO:     db_estado = 4'b0011;
            MEDIDA:          db_estado = 4'b0100;
            ARMAZENAMENTO:   db_estado = 4'b0101;
            FINAL_MEDIDA:    db_estado = 4'b1111;
            ABANDONO_ESTADO: db_estado = 4'b0111; // NOVO: estado de abandono
            default:         db_estado = 4'b1110;
        endcase
    end

endmodule
