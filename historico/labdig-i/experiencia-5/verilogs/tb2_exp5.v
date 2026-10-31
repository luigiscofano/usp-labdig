module tb2_exp5;

    // Sinais para conectar com o DUT
    reg        clock_in   = 1;
    reg        reset_in   = 0;
    reg        jogar_in   = 0;
    reg  [3:0] botoes_in  = 4'b0000;

    wire [3:0] leds_out;
    wire       pronto_out;
    wire       ganhou_out;
    wire       perdeu_out;
    wire       db_botaoIgualMemoria_out;
    wire       db_clock_out;
    wire       db_tem_jogada_out;
    wire [6:0] db_contagem_out;
    wire [6:0] db_memoria_out;
    wire [6:0] db_jogada_out;
    wire [6:0] db_limite_out;
    wire [6:0] db_estado_out;
    wire [3:0] db_Timeout_out;

    // Configuração do clock
    parameter clockPeriod = 1_000_000; // em ns, f = 1KHz

    // Identificação do caso de teste
    reg [31:0] caso = 0;

    // Gerador de clock
    always #((clockPeriod / 2)) clock_in = ~clock_in;

    // Instanciação do DUT (Device Under Test)
    circuito_exp5 dut (
      .clock          ( clock_in    ),
      .reset          ( reset_in    ),
      .jogar          ( jogar_in    ),
      .botoes         ( botoes_in   ),
      .leds           ( leds_out    ),
      .pronto         ( pronto_out  ),
      .ganhou         ( ganhou_out  ),
      .perdeu         ( perdeu_out  ),
      .db_botaoIgualMemoria ( db_botaoIgualMemoria_out ),
      .db_clock       ( db_clock_out ),
      .db_tem_jogada  ( db_tem_jogada_out ),
      .db_contagem    ( db_contagem_out ),
      .db_memoria     ( db_memoria_out ),
      .db_jogada      ( db_jogada_out ),
      .db_limite      ( db_limite_out ),
      .db_estado      ( db_estado_out ),
      .db_Timeout     ( db_Timeout_out )
    );

    integer i, j;
    reg [3:0] sequence [0:15];
    // Geração dos sinais de entrada (estímulos)
    initial begin
      $display("Inicio da simulacao");
      caso = 0;
      clock_in = 1;
      reset_in = 0;
      jogar_in = 0;
      botoes_in = 4'b0000;
      #clockPeriod;

      // Resetar circuito
      caso = 1;
      @(negedge clock_in);
      reset_in = 1;
      #(clockPeriod);
      reset_in = 0;
      #(10*clockPeriod);

      // Teste 2. iniciar=1 por 5 periodos de clock
      caso = 2;
      jogar_in = 1;
      #(5*clockPeriod);
      jogar_in = 0;
      // espera
      #(10*clockPeriod);

      // Testes baseados na ROM
      sequence[0]  = 4'b0001;
      sequence[1]  = 4'b0010;
      sequence[2]  = 4'b0100;
      sequence[3]  = 4'b1000;
      sequence[4]  = 4'b0100;
      sequence[5]  = 4'b0010;
      sequence[6]  = 4'b0001;
      sequence[7]  = 4'b0001;
      sequence[8]  = 4'b0010;
      sequence[9]  = 4'b0010;
      sequence[10] = 4'b0100;
      sequence[11] = 4'b0100;
      sequence[12] = 4'b1000;
      sequence[13] = 4'b1000;
      sequence[14] = 4'b0001;
      sequence[15] = 4'b0100;

      for (i = 0; i < 3; i = i + 1) begin
        for (j = 0; j <= i; j = j + 1) begin
          caso = i * 16 + j + 3;
          @(negedge clock_in);
          botoes_in = sequence[j];
          #(10*clockPeriod);
          botoes_in = 4'b0000;
          #(10*clockPeriod);
        end
      end

      //errar
      @(negedge clock_in);
      botoes_in = 4'b1111;
      #(10*clockPeriod);
      botoes_in = 4'b0000;
      #(10*clockPeriod);

      // Final da simulação
      caso = 99;
      #100;
      $stop;
    end

endmodule