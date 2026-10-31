module unidade_controle_exp6 (
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
    input fimTMR,
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
    output reg [4:0] db_estado,
    output reg entTMR,
    output reg zeraTO,
    output reg registraM,
    output reg limpaM,
    output reg db_timeout
);

   // Define estados
    parameter inicial           = 5'h00;  // 0
    parameter inicia_elementos  = 5'h01;  // 1

    parameter prepara_jogadas   = 5'h02;  // 2
    
    parameter carrega_dado      = 5'h03;  // 3
    parameter mostra_dado       = 5'h04;  // 
    parameter zera_leds         = 5'h05;  // 
    parameter mostra_apagado    = 5'h06;  // 6
    parameter proxima_posicao   = 5'h07;  // 7

    parameter espera            = 5'h08;  // 8
    parameter registra          = 5'h09;  // 9
    parameter comparacao        = 5'h0A;  // A
    parameter proxima_jogada    = 5'h0B;  // B

    parameter entre_sequencias  = 5'h0C;  // C
    parameter prox_sequencia    = 5'h0D;  // D

    parameter fim_ganhou        = 5'h0E;  // E
    parameter fim_perdeu        = 5'h0F;  // F
    parameter fim_timeout       = 5'h10;  // 10


    // Variaveis de estado
    reg [4:0] Eatual, Eprox;

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
            inicia_elementos: Eprox = carrega_dado;


            carrega_dado: Eprox = mostra_dado;
            mostra_dado: Eprox = (fimTMR) ? zera_leds : mostra_dado;
            zera_leds: Eprox = mostra_apagado;
            mostra_apagado: begin
                                case ({enderecoIgualLimite, fimTMR})
                                    2'b11: Eprox = prepara_jogadas;
                                    2'b01: Eprox = proxima_posicao;
                                    default: Eprox = mostra_apagado;
                                endcase
                            end
            proxima_posicao: Eprox = carrega_dado;

            prepara_jogadas : Eprox = espera;

            espera:     begin
                            case ({pulso_jogada, timeOut})
                                2'b10 : Eprox = registra; // se há jogada e nao deu timeout ele registra a jogada
                                2'b01 : Eprox = fim_timeout; // se nao tem jogada e der time out ele vai pro fim_timeout
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
            prox_sequencia: Eprox = carrega_dado;
            
            fim_ganhou:   Eprox = jogar ? inicia_elementos : fim_ganhou;
            fim_perdeu:   Eprox = jogar ? inicia_elementos : fim_perdeu;
            fim_timeout:  Eprox = jogar ? inicia_elementos : fim_timeout;
            default:     Eprox = inicial;
        endcase
    end

    // Logica de saida (maquina Moore)
    always @* begin
        zeraL      = (Eatual == inicia_elementos) ? 1'b1 : 1'b0;
        contaL     = (Eatual == prox_sequencia) ? 1'b1 : 1'b0;
        zeraE      = (Eatual == inicia_elementos || Eatual == prox_sequencia || Eatual == prepara_jogadas) ? 1'b1 : 1'b0;
        contaE     = (Eatual == proxima_jogada || Eatual == proxima_posicao) ? 1'b1 : 1'b0; 
        limpaR     = (Eatual == proxima_jogada) ? 1'b1 : 1'b0;
        registraR  = (Eatual == registra) ? 1'b1 : 1'b0;
        acertou    = (Eatual == fim_ganhou) ? 1'b1 : 1'b0;
        errou      = (Eatual == fim_perdeu) ? 1'b1 : 1'b0;
        pronto     = (Eatual == fim_ganhou || Eatual == fim_perdeu) ? 1'b1 : 1'b0;
        entTO      = (Eatual == espera) ? 1'b1 : 1'b0;
        entTMR     = (Eatual == mostra_dado || Eatual == mostra_apagado) ? 1'b1 : 1'b0;
        zeraTO     = (Eatual == registra | Eatual == mostra_apagado) ? 1'b1 : 1'b0;
//		  zeraTO     = (Eatual == registra | Eatual == inicial | Eatual == mostra_apagado) ? 1'b1 : 1'b0;
        registraM  = (Eatual == mostra_dado) ? 1'b1 : 1'b0;
        limpaM     = (Eatual == zera_leds) ? 1'b1 : 1'b0;
        db_timeout = (Eatual == fim_timeout) ? 1'b1 : 1'b0;

        case (Eatual)
            inicial:            db_estado = 5'h00; //0
            inicia_elementos:   db_estado = 5'h01; //1
            prepara_jogadas:    db_estado = 5'h02; //2
            carrega_dado:       db_estado = 5'h03; //3
            mostra_dado:        db_estado = 5'h04; //
            zera_leds:          db_estado = 5'h05; //5
            mostra_apagado:     db_estado = 5'h06; //6
            proxima_posicao:    db_estado = 5'h07; //7
            espera:             db_estado = 5'h08; //8
            registra:           db_estado = 5'h09; //9
            comparacao:         db_estado = 5'h0A; //A
            proxima_jogada:     db_estado = 5'h0B; //B
            entre_sequencias:   db_estado = 5'h0C; //C
            prox_sequencia:     db_estado = 5'h0D; //D
            fim_ganhou:         db_estado = 5'h0E; //E
            fim_perdeu:         db_estado = 5'h0F; //F
            fim_timeout:         db_estado = 5'h10; //10
            default:            db_estado = 5'h1F; //0
        endcase
    end


endmodule