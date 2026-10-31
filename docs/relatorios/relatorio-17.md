# Cópia de PCS3635-T2BA6-relatorioP1


Versão revisada para consulta pública. A disposição gráfica foi substituída por texto, tabelas e diagramas novos. Dados pessoais de terceiros e referências privadas foram retirados. Os créditos foram preservados.


Registro técnico do jogo de memória

Introdução

Este relatório documenta a execução das atividades realizadas durante a atividade de implementação da disciplina PCS3635 - Laboratório Digital I, no primeiro quadrimestre de 2025. O objetivo foi implementar e verificar a lógica de funcionamento do circuito da Experiência 7, utilizando ModelSim e a FPGA DE0-CV.

O jogo será desenvolvido em Verilog, utilizando conceitos fundamentais de sistemas digitais, como contadores, registradores e comparadores. A FPGA será programada para controlar a lógica do jogo, assegurando que cada rodada ocorra conforme especificado. Esse planejamento inclui a definição dos componentes necessários, as interações entre eles e os critérios de teste para validar o funcionamento correto do jogo.

Descrição do Projeto

O jogo consiste na apresentação sequencial de LEDs que o jogador deve replicar pressionando os botões correspondentes. A cada rodada, uma nova jogada é adicionada à sequência. O jogo termina quando o jogador erra ou atinge o limite de 16 jogadas. Dessa forma, o sistema precisa ser capaz de armazenar e recuperar sequências progressivamente maiores, garantindo que o jogador seja desafiado constantemente.

Para gerenciar essa dinâmica, o projeto inclui módulos responsáveis por controlar a apresentação dos LEDs, registrar as respostas do jogador e avaliar se ele acertou ou errou. Um sistema de temporização garante a exibição correta das jogadas, e um mecanismo de verificação determina o fim da partida caso haja erro ou sucesso completo. Esses elementos são projetados para interagir de maneira eficiente e garantir uma experiência de jogo fluida.

Detalhamento do Projeto Lógico

Este capítulo do relatório tem a finalidade de descrever detalhes do projeto lógico desenvolvido na presente experiência.

Projeto do Fluxo de Dados

Detalhar o projeto do fluxo de dados.

O Fluxo de dados pode ser descrito em duas partes: 

Contador e Comparador para controle do limite de cada sequência da rodada.

Dois registradores, contador, memória ROM, comparador e Timer que controlam o funcionamento de cada uma das rodadas.

	Em azul e vermelho estão as novidades a serem implementadas na experiência 6.

2.2 Projeto da Unidade de Controle

Detalhar o projeto do fluxo de dados.

Sugestão: incluir uma figura legível com o panorama da unidade de controle e descrevê-la em uma tabela com a seguinte estrutura.

| Nome do Estado | Descrição do Estado | Próximo Estado | Condições e Justificativas para a Transição entre Estados |
| --- | --- | --- | --- |
| inicial | Espera o acionamento do jogar para começar o funcionamento do circuito | inicia_elementos | jogar = 1 faz passar para o próximo estado |
| inicia_elementos | Zera os contadores e garante as condições iniciais | Carrega Dado | transição imediata para o próximo estado |
| Carrega Dado | puxa da memória o dado para mostrar nos leds | Mostra Dado | transição imediata para o próximo estado |
| Mostra Dado | Mostra o dado nos leds | Zera Leds | Se o timer de 0.5s terminou |
| Zera Leds | apaga os leds | Mostra Apagado | transição imediata para o próximo estado |
| Mostra Apagado | Mostra os leds apagados | Prox Posição / Prepara Jogada | Se o timer de 0.5s terminou / Se o endereçoIgual a Limite |
| Prox Posição | vai para proxima posição da memoria | Carrega dado | transição imediata para o próximo estado |
| Prepara Jogada | zera o contador de endereço | Espera | transição imediata para o próximo estado |
| espera | aguarda a jogada enquanto não houver timeout e liga o enable do contador do timeout | registra ou fim_perdeu | se fim por timeout: fim_timeout. / se não: registra |
| registra | registra a jogada / habilita o registrador | comparacao | transição imediata para o próximo estado |
| comparacao | compara a jogada com o dado armazenado na rom | proxima_jogada ou / entre_sequencias / ou fim_perdeu | se a comparação for diferente: fim_perdeu / se o endereço for igual ao limite: entre_sequencias / se o endereço for menor que o limite: / proxima_jogada |
| proxima_jogada | prepara para a próxima jogada / limpa registrador e habilita o contador de endereço | espera | transição imediata para o próximo estado |
| entre_sequencias | Identifica se o jogo acabou depois da sequência acabar | fim_ganhou / proxima_sequencia | o contador limite está no fim: fim_ganhou / o contador ainda não está no fim: proxima_sequencia |
| prox_sequencia | Prepara para começar a proxima sequencia. Habilita o contador do limite para ser incrementado uma unidade | carrega dado | transição imediata para o próximo estado |
| fim_ganhou | Indica que houve vitória no jogo após 16 sequencias | inicia_elementos | jogar = 1 faz passar para o próximo estado |
| fim_perdeu | Indica que houve um fim causado por um erro. | inicia_elementos | jogar = 1 faz passar para o próximo estado |

Projeto do Sistema Digital

A integração entre fluxo de dados e unidade de controle ocorre por meio de sinais de controle e condição, garantindo a sincronização do jogo. O sistema é projetado para operar de maneira eficiente, minimizando atrasos e evitando conflitos de sinalização.

Os componentes digitais devem ser implementados com base em práticas otimizadas de projeto digital. A arquitetura modular possibilita a reutilização de partes do circuito em futuras versões do jogo. Essa abordagem também permite a depuração facilitada e a execução de testes de forma independente.

Atividade 1 - Síntese e Teste do Circuito da Experiência 7

Durante esta etapa, foi realizada a síntese do projeto e a programação na FPGA DE0-CV. Em seguida, executou-se o Plano de Testes para verificar o correto funcionamento do circuito.

Tudo ocorreu conforme o planejado, pois já havia participado do Open Lab e estava familiarizado com o processo de síntese e testes. Não encontrei dificuldades na execução desta etapa, e a demonstração do funcionamento do circuito foi concluída com sucesso.

Atividade 2 - Verificação Lógica com ModelSim

Nesta atividade, foi definido um cenário de teste onde o jogo funcionaria corretamente até que ocorresse um timeout na quarta jogada.

Tive facilidade na execução dessa tarefa, mas precisei modificar o testbench de erro para que o timeout ocorresse exatamente na quarta jogada. Essa alteração foi necessária para garantir que a transição de estados ocorresse corretamente, conforme solicitado no enunciado.

Testbench Modificado

`timescale 1ns / 1ns

module circuito_exp6_tb_timeout;

  reg clock_in = 1;

  reg reset_in = 0;

  reg iniciar_in = 0;

  reg nivel = 0;

  reg [3:0] chaves_in = 4'b0000;

  reg [3:0] endereco_rom;

  reg memoria = 1;

  wire ganhou;

  wire perdeu;

  wire pronto;

  wire timeout;

  wire [3:0] leds_out;

  wire db_igual_out;

  wire db_clock_out;

  wire db_tem_jogada_out;

  wire [6:0] db_contagem_out;

  wire [6:0] db_memoria_out;

  wire [6:0] db_estado_out;

  wire [6:0] db_jogadafeita_out;

  wire [6:0] db_limite;

  wire [3:0] instrucoes;

  parameter clockPeriod = 1_000_000;

  reg [31:0] caso = 0;

  always #((clockPeriod / 2)) clock_in = ~clock_in;

  circuito_exp6 dut (

      .clock(clock_in),

      .reset(reset_in),

      .jogar(iniciar_in),

      .nivel(nivel),

      .botoes(chaves_in),

      .ganhou(ganhou),

      .memoria(memoria),

      .perdeu(perdeu),

      .timeout(timeout),

      .pronto(pronto),

      .leds(leds_out),

      .db_igual(db_igual_out),

      .db_contagem(db_contagem_out),

      .db_memoria(db_memoria_out),

      .db_estado(db_estado_out),

      .db_jogadafeita(db_jogadafeita_out),

      .db_clock(db_clock_out),

      .db_limite(db_limite),

      .db_tem_jogada(db_tem_jogada_out)

  );

  sync_rom_16x4_desafio rom (

      .clock(clock_in),

      .address(endereco_rom),

      .data_out(instrucoes)

  );

  integer lim;

  integer n;

  initial begin

    $display("Inicio da simulacao");

    caso = 0;

    reset_in = 0;

    iniciar_in = 0;

    chaves_in = 4'b0000;

    endereco_rom = 4'b0000;

    nivel = 1;

    memoria = 1;

    #clockPeriod;

    caso = 1;

    @(negedge clock_in);

    reset_in = 1;

    #(clockPeriod);

    reset_in = 0;

    #(10 * clockPeriod);

    caso = 2;

    iniciar_in = 1;

    #(5 * clockPeriod);

    iniciar_in = 0;

    #(10 * clockPeriod);

    lim = 0;

    for (lim = 0; lim < 16; lim = lim + 1) begin

      n = 0;

      caso = lim + 3;

      while (n <= lim) begin

        #(1000 * clockPeriod);

        n = n + 1;

      end

      n = 0;

      while (n <= lim) begin

        endereco_rom = n;

        #(2 * clockPeriod);

        @(negedge clock_in);

        if (n < 3)

          chaves_in = instrucoes;

        else if (n == 3)

          #(50 * clockPeriod);

        #(10 * clockPeriod);

        chaves_in = 4'b0000;

        #(10 * clockPeriod);

        n = n + 1;

      end

    end

    caso = 99;

    #(100 * clockPeriod);

    $display("Fim da simulacao");

    $stop;

  end

endmodule

Atividade 3 - Projeto Lógico de Modificações ao Projeto da Experiência 7

Foi desenvolvido o projeto lógico para implementar as modificações solicitadas. O foco foi a adição de uma funcionalidade de pausa no jogo, permitindo ao jogador interromper e retomar o jogo posteriormente. Essa funcionalidade só poderia ser ativada quando o sistemas estivesse esperando uma jogada do jogador e ela deveria também pausar o contador do timeout.

As alterações incluíram a criação do estado PAUSADO, a suspensão do contador de tempo e a implementação de um sinal jogo_pausado, que é mapeado para um LED da FPGA ou no AnalogDiscovery. A lógica para a criação desse estado seria uma transição partindo do estado espera_jogada, caso o switch SW7 fosse ativado. Quando o SW7 é desativado o jogo retorna para o estado de espera_jogada.

Para implementar o timeout seria necessária uma modificação da lógica de saída de estados e das entradas do contador, como na imagem abaixo, feita durante a prova.

Atividade 4 - Implementação e Teste em Bancada das Modificações

Esta atividade não foi concluída por falta de tempo. Apesar disso, todas as alterações no projeto lógico foram documentadas e preparadas para implementação futura.

Conclusão

A experiência foi bem-sucedida na implementação e verificação da lógica do circuito. O processo de síntese e ModelSim ocorreu sem dificuldades significativas. A modificação do testbench foi necessária para atender ao critério de timeout na quarta jogada. A etapa final de implementação na FPGA ficou pendente devido à limitação de tempo.

Resultados Simulados do Cenário de Teste de vitória










## Diagramas e reprodução desta edição

Consulte os [diagramas explicativos](../DIAGRAMAS.md), os [objetivos pedagógicos](../OBJETIVOS_PEDAGOGICOS.md) e a [validação](../VALIDACAO.md). As figuras originais não foram republicadas. Os novos diagramas e os testes acompanham as implementações organizadas.

## Autoria e créditos

Luigi Scofano de Araujo · USP 13680334.

## Reprodução e figuras desta edição

[Diagramas explicativos](../DIAGRAMAS.md) · [Validação](../VALIDACAO.md) · [Objetivos pedagógicos](../OBJETIVOS_PEDAGOGICOS.md).
