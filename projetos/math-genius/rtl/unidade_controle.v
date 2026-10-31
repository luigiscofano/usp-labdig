module unidade_controle(
    input clock,
    input reset,
    input jogar,
    input enter,
    input acerto,
    input fimJogo,
    output reg zeraCtrl,
    output reg enableCtrl,
    output reg clearReg,
    output reg regEnable,
    output reg enE,
    output reg zeraE,
    output reg resetEdge,
    output reg db_fim,
    output reg [3:0] db_estado,
    output reg enableDif,
    output reg clear_contacertos,
    output reg enable_contacertos
);

    parameter inicial = 4'h0;
    parameter prep = 4'h1;
    parameter mostra_eq = 4'h2;
    parameter espera = 4'h3;
    parameter salvaJog = 4'h4;
    parameter comparacao = 4'h5;
    parameter addAcerto = 4'h6;
    parameter prepProx = 4'h7;
    parameter fim = 4'h8;

    reg [3:0] estado, proximo_estado;

    always @(posedge clock or posedge reset) begin
        if(reset)
            estado <= inicial;
        else
            estado <= proximo_estado;
    end

    always @* begin
        case(estado)
            inicial: proximo_estado = jogar ? prep : inicial;
            prep: proximo_estado = mostra_eq;
            mostra_eq: proximo_estado = espera;
            espera: proximo_estado = enter ? salvaJog : espera;
            salvaJog: proximo_estado = comparacao;
            
            comparacao: begin
                case({acerto, fimJogo}) 
                    2'b00: proximo_estado = prepProx; //errou e o jogo continua
                    2'b01: proximo_estado = fim; //errou e o jogo acaba
                    default: proximo_estado = addAcerto; //acertou
                endcase
            end
            addAcerto: proximo_estado = fimJogo ? fim : prepProx; //acertou e o jogo continua ou acaba
            
            prepProx: proximo_estado = mostra_eq;
            
            fim: proximo_estado = jogar ? prep : fim; //jogar novamente ou manter no fim

            default: proximo_estado = inicial;
        endcase
    end

    always @* begin
        resetEdge = (estado == prep) ? 1 : 0; // Resetar o sinal de controle de borda
        zeraCtrl = (estado == prep || estado == prepProx) ? 1 : 0; // Zerar o controle de entrada
        enableCtrl = (estado == espera) ? 1 : 0; // Habilitar o controle de entrada
        clearReg = (estado == prep || estado == inicial) ? 1 : 0; // Limpar o registrador de resposta
        regEnable = (estado == salvaJog) ? 1 : 0; // Habilitar o registrador de resposta
        enE = (estado == prepProx) ? 1 : 0; // Ir pro próximo endereço
        zeraE = (estado == prep || estado == inicial) ? 1 : 0; // Zerar o controle de endereçamento da ROM
        db_fim = (estado == fim) ? 1 : 0; // Sinal de fim de jogo
        enableDif = (estado == prep) ? 1 : 0;
        clear_contacertos = (estado ==  prep || estado == inicial) ? 1 : 0;
        enable_contacertos = (estado == addAcerto) ? 1 : 0;
        
        case (estado)
            inicial:         db_estado = 4'h0;
            prep:            db_estado = 4'h1;
            mostra_eq:       db_estado = 4'h2;
            espera:          db_estado = 4'h3;
            salvaJog:        db_estado = 4'h4;
            comparacao:      db_estado = 4'h5;
            addAcerto:       db_estado = 4'h6;
            prepProx:        db_estado = 4'h7;
            fim:             db_estado = 4'h8;
        endcase
    end


endmodule