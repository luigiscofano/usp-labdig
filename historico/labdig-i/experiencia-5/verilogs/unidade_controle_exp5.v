module unidade_controle_exp5 (
    input clock,
    input reset,
    input jogar, //sinal pra começar o jogo
    input fimE, //ja leu todos endereços da ROM
    input fimL,
    input pulso_jogada, //fez uma jogada
    input botaoIgualMemoria,  //acertou jogada
    input timeOut, 
    input enderecoMenorLimite, //ainda ta fazendo uma rodada
    input enderecoIgualLimite, //chegou no fim de uma rodada
    output reg zeraL, //zera contador do limite
    output reg contaL, //enable contador do limite
    output reg zeraE, //zera contador do endereco
    output reg contaE,//vai pro proximo endereco
    output reg limpaR, //zera o registrador dos botoes
    output reg registraR, //salva o valor do registrador dos botoes
    output reg acertou,
    output reg errou,
    output reg pronto,
    output reg entTO, // Indica se o timeout deve ser ativado
    output reg db_Timeout, // Sinal de depuração indicando timeout
    output reg [3:0] db_estado
);

   // Define estados
    parameter inicial          = 4'b0000;  // 0
    parameter inicia_elementos = 4'b0001;  // 1
    parameter inicia_sequencia = 4'b0010;  // 2
    parameter espera           = 4'b0100;  // 4
    parameter registra         = 4'b0101;  // 5
    parameter comparacao       = 4'b0110;  // 6
    parameter proxima_jogada   = 4'b0111;  // 7
    parameter entre_sequencias = 4'b1000;  // 8
    parameter prox_sequencia   = 4'b1001;  // 9
    parameter fim_timeout      = 4'b1101;  // D
    parameter fim_ganhou       = 4'b1110;  // E
    parameter fim_perdeu       = 4'b1111;  // F

    // Variaveis de estado
    reg [3:0] Eatual, Eprox;

    // Memoria de estado
    always @(posedge clock or posedge reset) begin // Começa o circuito
        if (reset)
            Eatual <= inicial; // se reset for acionado reinicia
        else
            Eatual <= Eprox; // a cada clk ele muda pro proximo estado
    end

    // Logica de proximo estado
    always @* begin
        case (Eatual)
            inicial:     Eprox = jogar ? inicia_elementos : inicial;
            inicia_elementos: Eprox = inicia_sequencia;
            inicia_sequencia: Eprox = espera; // vai para o espera
            espera:     begin
                            case ({pulso_jogada, timeOut})
                                2'b10 : Eprox = registra; // se há jogada e nao deu timeout ele registra a jogada
                                2'b01 : Eprox = fim_timeout; // se nao tem jogada e der time out ele vai pro fimtimeout
                                default : Eprox = espera; // qualquer outro caso ele fica esperando
                            endcase
                        end
            registra:    Eprox = comparacao; // Compara a resposta com a rom
            comparacao: begin
                            case ({enderecoIgualLimite, botaoIgualMemoria})
                                2'b01: Eprox = proxima_jogada;
                                2'b11: Eprox = entre_sequencias;
                                default: Eprox = fim_perdeu;
                            endcase
                        end
            proxima_jogada:     Eprox = espera;
            entre_sequencias:   Eprox = fimL ? fim_ganhou : prox_sequencia;
            prox_sequencia: Eprox = inicia_sequencia;
            fim_ganhou:   Eprox = jogar ? inicia_elementos : fim_ganhou;
            fim_perdeu:   Eprox = jogar ? inicia_elementos : fim_perdeu;
            fim_timeout:   Eprox = jogar ? inicia_elementos : fim_timeout;
            default:     Eprox = inicial;
        endcase
    end

    // Logica de saida (maquina Moore)
    always @* begin
        zeraL      = (Eatual == inicia_elementos) ? 1'b1 : 1'b0;
        contaL     = (Eatual == prox_sequencia) ? 1'b1 : 1'b0;
        zeraE      = (Eatual == inicia_elementos || Eatual == prox_sequencia) ? 1'b1 : 1'b0;
        contaE     = (Eatual == proxima_jogada) ? 1'b1 : 1'b0; 
        limpaR     = (Eatual == proxima_jogada) ? 1'b1 : 1'b0;
        registraR  = (Eatual == registra) ? 1'b1 : 1'b0;
        acertou    = (Eatual == fim_ganhou) ? 1'b1 : 1'b0;
        errou      = (Eatual == fim_perdeu || fim_timeout) ? 1'b1 : 1'b0;
        pronto     = (Eatual == fim_ganhou || Eatual == fim_perdeu || Eatual == fim_timeout) ? 1'b1 : 1'b0;
        entTO      = (Eatual == espera) ? 1'b1 : 1'b0;
        db_Timeout = (Eatual == fim_timeout) ? 1'b1 : 1'b0;

        case (Eatual)
            inicial:            db_estado = 4'b0000; //0
            inicia_elementos:   db_estado = 4'b0001; //1
            inicia_sequencia:   db_estado = 4'b0010; //2
            espera:             db_estado = 4'b0100; //4
            registra:           db_estado = 4'b0101; //5
            comparacao:         db_estado = 4'b0110; //6
            proxima_jogada:     db_estado = 4'b0111; //7
            entre_sequencias:   db_estado = 4'b1000; //8
            prox_sequencia:     db_estado = 4'b1001; //F
            fim_timeout:        db_estado = 4'b1101; //D
            fim_ganhou:         db_estado = 4'b1110; //E
            fim_perdeu:         db_estado = 4'b1111; //F 
            default:            db_estado = 4'b1010; //A (erro)
        endcase
    end


endmodule