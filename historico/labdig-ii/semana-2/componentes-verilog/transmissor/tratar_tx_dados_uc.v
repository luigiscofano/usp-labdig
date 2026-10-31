module tratar_tx_dados_uc (
    input clock,
    input reset,
    input iniciar_tx,

    input tx_char_pronto,
    input fim_cont,
    output reg fim_tx,
    output reg inicia_caractere,
    output reg zera_contador,
    output reg proximo_char
);
    parameter ESPERA = 3'b000;
    parameter TX_CHAR = 3'b001;
    parameter CHECA_FIM = 3'b010;
    parameter ADD_CONT = 3'd011;
    parameter TX_HASH = 3'd100;
    parameter PRONTO = 3'd101;

    reg [2:0] Eatual, Eprox;
    
    always @(posedge clock or posedge reset) begin
        if (reset)
            Eatual <= ESPERA;
        else
            Eatual <= Eprox;
    end

    always @(*) begin
        case(Eatual)
            ESPERA:
                if (iniciar_tx)
                    Eprox = TX_CHAR;
                else
                    Eprox = ESPERA;
            TX_CHAR:
                if (tx_char_pronto)
                    Eprox = CHECA_FIM;
                else
                    Eprox = TX_CHAR;
            CHECA_FIM:
                if (fim_cont)
                    Eprox = TX_HASH;;
                else
                    Eprox = ADD_CONT;
            ADD_CONT:   
                Eprox = TX_CHAR;
            TX_HASH:
                if (tx_char_pronto)
                    Eprox = PRONTO;
                else
                    Eprox = TX_HASH;
            PRONTO:
                Eprox = ESPERA;
            default:
                Eprox = ESPERA;
        endcase
    end
    

    always @(*) begin
        fim_tx = (Eatual == PRONTO) ? 1'b1 : 1'b0;
        inicia_caractere = (Eatual == TX_CHAR || Eatual == TX_HASH) ? 1'b1 : 1'b0;
        zera_contador = (Eatual == ESPERA) ? 1'b1 : 1'b0;
        proximo_char = (Eatual == ADD_CONT) ? 1'b1 : 1'b0;
    end

    
endmodule