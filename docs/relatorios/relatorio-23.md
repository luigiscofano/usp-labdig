# PCS3635-T2BA6-planejamento


Versão revisada para consulta pública. A disposição gráfica foi substituída por texto, tabelas e diagramas novos. Dados pessoais de terceiros e referências privadas foram retirados. Os créditos foram preservados.


Introdução

Este planejamento detalha o desenvolvimento do projeto lógico do "Jogo do Desafio da Memória", baseado no funcionamento do brinquedo Genius. O objetivo é projetar e implementar um sistema digital que apresente sequências de jogadas ao jogador e avalie suas respostas, utilizando uma FPGA. A implementação busca garantir um funcionamento preciso, permitindo que o jogador interaja com o sistema de forma intuitiva e responsiva.

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

Projeto da Unidade de Controle

Detalhar o projeto do fluxo de dados.

Sugestão: incluir uma figura legível com o panorama da unidade de controle e descrevê-la em uma tabela com a seguinte estrutura.

Tabela 1 – Descrição da Unidade de Controle do Sistema

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

Plano de Testes do Sistema e Simulações

Este capítulo tem o objetivo de documentar a estratégia dos testes do sistema desenvolvido e documentado no capítulo 3 e apresentar os resultados das respectivas simulações realizadas.

Sugestão: descrever cada cenário de teste em uma subseção seguindo o modelo fornecido.

Cenário de Teste 1 – Vitória 

O jogador acertou as 16 sequências.

Tabela 2 – Descrição e Resultados Simulados do Cenário de Teste 1

| Entradas | Saídas Esperadas | Resultado Simulado OK? | Análise de Não Conformidades |
| --- | --- | --- | --- |
| Reset = 1 | Sistema resetado, contador e memória inicializados | ok | - |
| Reset = 0, Jogar = 1 | Sistema aguardando entrada do jogador | ok | - |
| Jogada 1 correta | LED correspondente acende, contador avança | ok | - |
| Jogada 2 correta | LED correspondente acende, contador avança | ok | - |
| … | … | … | - |
| Jogada final correta | Saída "ganhou" ativada | ok | - |

Cenário de Teste 2 – 2 acertos e erro 

O jogador acertou 2 jogadas e errou sua terceira tentativa.

Tabela 3 – Descrição e Resultados Simulados do Cenário de Teste 2

| Entradas | Saídas Esperadas | Resultado Simulado OK? | Análise de Não Conformidades |
| --- | --- | --- | --- |
| Reset = 1 | Sistema resetado, contador e memória inicializados | ok | - |
| Reset = 0, Jogar = 1 | Sistema aguardando entrada do jogador | ok | - |
| Jogada 1 correta | LED correspondente acende, contador avança | ok | - |
| Jogada 2 correta | LED correspondente acende, contador avança | ok | - |
| Jogada 3  / errada | LED erro ascende | ok | - |

Implantação do Projeto

Este capítulo tem o objetivo de documentar as atividades práticas de execução do projeto desenvolvido e documentado no capítulo 3 no ambiente do Laboratório Digital. 

Pinagem da Placa FPGA

RTL Viewer:

Estratégia de Montagem

Descrever o passo-a-passo para realizar a montagem experimental. Por exemplo:

Como realizar a programação da placa FPGA;

Como realizar ligações de terminais e fios (incluir diagramas/esquemas);

Quais sinais / elementos físicos são monitorados;

Quais sinais de depuração são considerados e como são monitorados.

Estratégia de Depuração

Descrever que estratégia o grupo prevê para realizar a depuração do projeto. Por exemplo:

Como monitorar sinais de depuração e como interpretá-los;

Que recursos do laboratório são utilizados (osciloscópio, multímetro, módulos específicos do AnalogDiscovery, etc.) e como emprega-los;

Como realizar alterações no projeto lógico em caso de problema;

Como realizar alterações de montagem em caso de problema;

Como garantir que as modificações não alteram outras funcionalidades já confirmadas como plenamente operacionais;

Execução Prática do Cenário de Teste 1 – Memoria = 0

Jogador seleciona a memória original e acerta todas as jogadas.

Tabela 4 – Jogador acerta todos os cenários para a memória original

| Entradas | Saídas Esperadas | Resultado Prátioco OK? | Resultado da simulação OK? |
| --- | --- | --- | --- |
| Reset = 1 | Sistema resetado, contador e memória inicializados | ok | ok |
| Reset = 0, Jogar = 1 | Sistema aguardando entrada do jogador | ok | ok |
| Jogada 1 correta | LED correspondente acende, contador avança | ok | ok |
| Jogada 2 correta | LED correspondente acende, contador avança | ok | ok |
| … | … | … | … |
| Jogada final correta | Saída "ganhou" ativada | ok | ok |

A memoria=0 refere-se à rom original.

Execução Prática do Cenário de Teste 2 - Memoria = 1

Jogador seleciona a memória implementada e acerta todas as jogadas.

Tabela 5 – Descrição e Resultados Práticos do Cenário de Teste 2

| Entradas | Saídas Esperadas | Resultado Prátioco OK? | Resultado da simulação OK? |
| --- | --- | --- | --- |
| Reset = 1 | Sistema resetado, contador e memória inicializados | ok | ok |
| Reset = 0, Jogar = 1 | Sistema aguardando entrada do jogador | ok | ok |
| Jogada 1 correta | LED correspondente acende, contador avança | ok | ok |
| Jogada 2 correta | LED correspondente acende, contador avança | ok | ok |
| … | … | … | … |
| Jogada final correta | Saída "ganhou" ativada | ok | ok |

Conclusões

No planejamento, redija um texto de até dois parágrafos explicando se o desenvolvimento realizado antes da aula (projeto lógico e simulações) cumprem os objetivos da experiência. Caso falhas de projeto existam, descreva-as sucintamente.

No relato final, atualize as conclusões explicando em um parágrafo se o desenvolvimento realizado na aula cumpre os objetivos da experiência. Relate em mais um parágrafo eventuais dificuldades ou modificações realizadas no projeto original.

Faça o mesmo para o desafio, caso tenha realizado parcial ou totalmente durante a aula.

/* --------------------------------------------------------------------

 * Arquivo   : circuito_exp6_tb_timeout.v

 * Projeto   : Experiencia 6 - 

 * --------------------------------------------------------------------

 * Descricao : testbench Verilog para circuito da Experiencia 6 

 *             1) Plano de teste - Erro na quarta jogada por timeout

 */

`timescale 1ns / 1ns

module circuito_exp6_tb_timeout;

  // Definição dos sinais de entrada do circuito

  reg        clock_in = 1; // Clock do sistema

  reg        reset_in = 0; // Sinal de reset do circuito

  reg        iniciar_in = 0; // Sinal para iniciar o jogo

  reg        nivel = 0; // Nível do jogo (não usado diretamente neste teste)

  reg  [3:0] chaves_in = 4'b0000; // Entrada dos botões do jogador

  reg  [3:0] endereco_rom; // Endereço para acessar a ROM de jogadas

  reg        memoria = 1; // Sinal que representa a presença de memória ativa

  // Definição dos sinais de saída do circuito

  wire       ganhou; // Indica se o jogador venceu

  wire       perdeu; // Indica se o jogador perdeu

  wire       pronto; // Indica se o sistema está pronto

  wire       timeout; // Indica se houve um timeout

  wire [3:0] leds_out; // Saída dos LEDs representando a sequência

  // Sinais de depuração

  wire       db_igual_out;

  wire       db_clock_out;

  wire       db_tem_jogada_out;

  wire [6:0] db_contagem_out;

  wire [6:0] db_memoria_out;

  wire [6:0] db_estado_out;

  wire [6:0] db_jogadafeita_out;

  wire [6:0] db_limite;

  wire [3:0] instrucoes; // Dados lidos da ROM

  // Configuração do clock do sistema

  parameter clockPeriod = 1_000_000;  // 1 ms, frequência de 1 KHz

  // Identificação do caso de teste

  reg [31:0] caso = 0;

  // Geração do clock

  always #((clockPeriod / 2)) clock_in = ~clock_in;

  // Instanciação do DUT (Device Under Test)

  circuito_exp6 dut (

      .clock         (clock_in),

      .reset         (reset_in),

      .jogar         (iniciar_in),

      .nivel         (nivel),

      .botoes        (chaves_in),

      .ganhou        (ganhou),

      .memoria       (memoria),

      .perdeu        (perdeu),

      .timeout       (timeout),

      .pronto        (pronto),

      .leds          (leds_out),

      .db_igual      (db_igual_out),

      .db_contagem   (db_contagem_out),

      .db_memoria    (db_memoria_out),

      .db_estado     (db_estado_out),

      .db_jogadafeita(db_jogadafeita_out),

      .db_clock      (db_clock_out),

      .db_limite     (db_limite),

      .db_tem_jogada (db_tem_jogada_out)

  );

  // Instanciação da ROM com a sequência de jogadas

  sync_rom_16x4_desafio rom (

      .clock(clock_in),

      .address(endereco_rom),

      .data_out(instrucoes)

  );

  integer lim;

  integer n;

  // Geração dos estímulos

  initial begin

    $display("Inicio da simulacao");

    // Configuração inicial

    caso         = 0;

    clock_in     = 1;

    reset_in     = 0;

    iniciar_in   = 0;

    chaves_in    = 4'b0000;

    endereco_rom = 4'b0000;

    nivel        = 1;

    memoria      = 1;

    #clockPeriod;

    // Teste 1: Resetar o circuito

    caso = 1;

    @(negedge clock_in);

    reset_in = 1;

    #(clockPeriod);

    reset_in = 0;

    #(10 * clockPeriod);

    // Teste 2: Iniciar o jogo

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

        if (n < 3) // Acerta as três primeiras jogadas

          chaves_in = instrucoes;

        else if (n == 3) // Perde na quarta jogada por timeout

          #(50 * clockPeriod); // Atraso simulando timeout

        #(10 * clockPeriodov);

        chaves_in = 4'b0000;

        #(10 * clockPeriod);

        n = n + 1;

      end

    end

    // Final da simulação

    caso = 99;

    #(100 * clockPeriod);

    $display("Fim da simulacao");

    $stop;

  end

endmodule


















## Diagramas e reprodução desta edição

Consulte os [diagramas explicativos](../DIAGRAMAS.md), os [objetivos pedagógicos](../OBJETIVOS_PEDAGOGICOS.md) e a [validação](../VALIDACAO.md). As figuras originais não foram republicadas. Os novos diagramas e os testes acompanham as implementações organizadas.

## Autoria e créditos

Luigi Scofano de Araujo · USP 13680334.

Créditos de participação constantes do material de origem: Lucas Lacerda, Paulo Henrique Mota de Oliveira.

## Reprodução e figuras desta edição

[Diagramas explicativos](../DIAGRAMAS.md) · [Validação](../VALIDACAO.md) · [Objetivos pedagógicos](../OBJETIVOS_PEDAGOGICOS.md).
