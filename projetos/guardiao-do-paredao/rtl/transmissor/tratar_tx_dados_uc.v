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
    parameter ENVIA = 3'b001;
    parameter AGUARDA = 3'b010;
    parameter PROXIMO = 3'b011;
    parameter ADD_CONT = 3'b100;
    parameter PRONTO = 3'b101;

    reg [2:0] Eatual, Eprox;
    
    always @(posedge clock or posedge reset) begin
        if (reset)
            Eatual <= ESPERA;
        else
            Eatual <= Eprox;
    end

    always @(*) begin
        case(Eatual)
            ESPERA: //0
                if (iniciar_tx)
                    Eprox = ENVIA;
                else
                    Eprox = ESPERA;
            ENVIA: //1
                Eprox = AGUARDA;
            AGUARDA: //2
                if (tx_char_pronto)
                    Eprox = PROXIMO;
                else
                    Eprox = AGUARDA;
            PROXIMO: //3
                if (fim_cont)
                    Eprox = PRONTO;
                else
                    Eprox = ADD_CONT;
            ADD_CONT: //4  
                Eprox = ENVIA;
            PRONTO: //5
                Eprox = ESPERA;
            default:
                Eprox = ESPERA;
        endcase
    end
    

    always @(*) begin
        fim_tx = (Eatual == PRONTO) ? 1'b1 : 1'b0;
        inicia_caractere = (Eatual == ENVIA) ? 1'b1 : 1'b0;
        zera_contador = (Eatual == ESPERA) ? 1'b1 : 1'b0;
        proximo_char = (Eatual == ADD_CONT) ? 1'b1 : 1'b0;
    end

    
endmodule