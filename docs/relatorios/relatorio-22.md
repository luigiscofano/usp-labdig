# PCS3635-T2BA6-relato5


Versão revisada para consulta pública. A disposição gráfica foi substituída por texto, tabelas e diagramas novos. Dados pessoais de terceiros e referências privadas foram retirados. Os créditos foram preservados.


Introdução

O objetivo desta experiência é desenvolver um circuito digital para um jogo de sequência de jogadas utilizando Verilog e implementado em uma FPGA. O jogo consiste em armazenar e verificar uma sequência de jogadas feitas pelo usuário, comparando-as com uma sequência pré-definida na memória do sistema. Para isso, serão projetados e implementados um fluxo de dados eficiente e uma unidade de controle que coordene as transições de estados e a execução das ações de comparação, armazenamento e verificação das jogadas. Além disso, técnicas de depuração serão utilizadas para validar a funcionalidade do circuito e garantir sua correta operação no hardware. Além disso, será realizada a síntese do projeto na FPGA DE0-CV, permitindo a execução real do jogo e a observação de seu funcionamento no ambiente de laboratório. 

====================================================================

Descrição do Projeto

O projeto consiste na implementação de um jogo onde o jogador deve reproduzir corretamente uma sequência de jogadas armazenadas na memória do sistema. A cada rodada, o jogador deve inserir um novo elemento na sequência de forma cumulativa e, caso erre, a partida termina imediatamente. O circuito é projetado para gerenciar a entrada das jogadas por meio de botões e exibir os resultados nos LEDs da FPGA. O jogo possui três saídas principais: "ganhou", "perdeu" e "pronto", que indicam respectivamente se o jogador completou a sequência corretamente, se errou ou se o jogo está aguardando um novo início.

A implementação será realizada em Verilog e utilizará uma abordagem modular para dividir a lógica do jogo em diferentes blocos funcionais. A comunicação entre esses módulos será feita por meio de sinais de controle de dados. A experiência também exigirá a criação de mecanismos de depuração, incluindo sinais adicionais que permitam monitorar o estado interno do sistema e facilitar a identificação de erros.



====================================================================

Detalhamento do Projeto Lógico

Projeto do Fluxo de Dados

O fluxo de dados do jogo de sequência de jogadas é estruturado para garantir que as entradas do jogador sejam corretamente registradas, armazenadas e comparadas com a sequência pré-definida. Ele é composto por contadores, registradores, memória e comparadores, todos interligados e controlados pela unidade de controle.

O contador de limite (ContLmt) gerencia o número de jogadas que devem ser realizadas em cada rodada. Ele recebe os sinais contaL e zeraL da unidade de controle para avançar ou resetar a contagem, respectivamente. Sua saída (s_limite) indica quantas jogadas a rodada atual exige. Além disso, esse contador produz um sinal (fimL) que informa se todas as rodadas foram concluídas.

O contador de endereço (ContEnd) controla a posição da memória sendo acessada e a progressão das jogadas dentro da sequência. Ele recebe os sinais contaE e zeraE, responsáveis por incrementar ou resetar o contador conforme o jogo avança. Sua saída (s_endereco) é usada para acessar a memória de jogadas (MemJog), garantindo que a sequência armazenada seja lida corretamente. O sinal fimE é gerado quando todas as jogadas de uma rodada foram realizadas.

A memória de jogadas (MemJog) armazena a sequência correta a ser reproduzida pelo jogador. Cada jogada é armazenada em uma posição endereçada pelo s_endereco, e a saída da memória (s_dado) fornece o valor esperado para aquela jogada. Esse valor será comparado com a jogada realizada pelo jogador.

O registrador de jogadas (RegBotoes) armazena a jogada atual do jogador. Ele recebe a entrada dos botões (botoes), e quando o sinal registraR é ativado, essa jogada é armazenada e disponibilizada para comparação. O registrador pode ser resetado pelo sinal limpaR, garantindo que ele esteja pronto para uma nova jogada quando necessário. Sua saída (s_jogada) é utilizada no comparador de jogadas.

Os comparadores desempenham um papel fundamental na validação das jogadas. O comparador de endereços (CompLmt) verifica se a quantidade de jogadas já feitas em uma rodada atingiu o limite estabelecido (s_limite). Ele gera dois sinais: enderecoMenorOuIgualLimite, que indica se ainda há jogadas a serem feitas, e enderecoIgualLimite, que confirma se a rodada foi completamente preenchida. O comparador de jogadas (CompJog) compara a jogada armazenada (s_jogada) com a jogada esperada da memória (s_dado). Se ambas forem iguais, o sinal chavesIgualMemoria é ativado, informando que o jogador acertou aquela jogada.

Os sinais gerados por esses componentes são utilizados pela unidade de controle para determinar o fluxo do jogo. Se o jogador acertar todas as jogadas de uma rodada, o contador de limite avança e uma nova sequência é iniciada. Se houver um erro, o jogo é encerrado e o sinal de derrota é acionado. O sistema opera de forma sincronizada pelo clock, garantindo que todas as operações de armazenamento, contagem e comparação ocorram de maneira ordenada.

Esse fluxo de dados garante um processamento eficiente e estruturado para a execução do jogo, permitindo que o jogador tente reproduzir sequências progressivamente mais longas enquanto o sistema verifica sua precisão e avança para a próxima rodada ou finaliza a partida em caso de erro.

Figura 1. Fluxo de dados

Projeto da Unidade de Controle

A Unidade de Controle (UC) do jogo será modelada como uma Máquina de Estados Finitos (FSM), sendo responsável por gerenciar a progressão das jogadas e coordenar as interações entre os componentes do fluxo de dados. Seu funcionamento se baseia em um conjunto de estados bem definidos, pelos quais o sistema transita de acordo com as entradas recebidas e os resultados da comparação das jogadas.

O sistema inicia no estado inicial, onde permanece até que o jogador pressione o botão “jogar”. Quando o jogo é iniciado, a FSM avança para um estado onde inicializa os elementos do circuito, garantindo que todos os registradores e contadores estejam devidamente resetados para começar uma nova partida. Em seguida, a FSM avança para o estado de inicia sequência, determinando que uma nova rodada deve ser processada.

Uma vez iniciada a sequência, o sistema entra no estado de espera jogada, onde aguarda a entrada do jogador. Se o jogador não realizar uma jogada dentro do tempo limite, o sistema continua aguardando. Assim que uma jogada é detectada, o FSM transita para o estado de registra jogada, onde a entrada do jogador é armazenada para ser comparada com a sequência correta.

Após o registro da jogada, a FSM avança para o estado de compara jogada, onde a entrada do jogador é comparada com a sequência armazenada na memória. Se a jogada estiver correta, o sistema verifica se a sequência da rodada foi completamente reproduzida. Caso ainda restem jogadas a serem feitas, a FSM transita para o estado próxima jogada, permitindo que o jogador continue a sequência. Se todas as jogadas da rodada forem concluídas corretamente, o sistema verifica se foi a última sequência do jogo. Se não for a última, a FSM avança para o estado passa para a próxima sequência, onde os contadores de sequência e jogadas são ajustados para iniciar uma nova rodada.

Caso o jogador cometa um erro ao reproduzir a sequência, a FSM transita diretamente para o estado final com erro, ativando a saída “perdeu” e aguardando o reinício do jogo. Se todas as sequências forem reproduzidas corretamente até o final, o sistema entra no estado final com acertos, ativando a saída “ganhou” e esperando uma nova ativação do botão "jogar" para reiniciar a partida.

O FSM também inclui estados de transição para reinicialização, garantindo que o jogo possa ser reiniciado corretamente sem interferências nos estados anteriores. A FSM acompanha e gera sinais de depuração, permitindo que os estados sejam monitorados durante os testes e que possíveis falhas sejam identificadas de maneira eficiente.	

Tabela 1 – Descrição da Unidade de Controle do Sistema

| Nome do Estado | Descrição do Estado | Próximo Estado | Condições e Justificativas para a Transição entre Estados |
| --- | --- | --- | --- |
| inicial | Espera o acionamento do jogar para começar o funcionamento do circuito | inicia_elementos | jogar = 1 faz passar para o próximo estado |
| inicia_elementos | Zera os contadores e garante as condições iniciais | inicia_sequencia | transição imediata para o próximo estado |
| inicia_sequencia | Estado intermediário para reinício da sequencia, habilita o contador limite (contaL) | espera | transição imediata para o próximo estado |
| espera | aguarda a jogada enquanto não houver timeout e liga o enable do contador do timeout | registra ou fim_timeout | se fim por timeout: fim_timeout. / se não: registra |
| registra | registra a jogada / habilita o registrador | comparacao | transição imediata para o próximo estado |
| comparacao | compara a jogada com o dado armazenado na rom | proxima_jogada ou / entre_sequencias / ou fim_perdeu | se a comparação for diferente: fim_perdeu / se o endereço for igual ao limite: entre_sequencias / se o endereço for menor que o limite: / proxima_jogada |
| proxima_jogada | prepara para a próxima jogada / limpa registrador e habilita o contador de endereço | espera | transição imediata para o próximo estado |
| entre_sequencias | Identifica se o jogo acabou depois da sequência acabar | fim_ganhou / proxima_sequencia | o contador limite está no fim: fim_ganhou / o contador ainda não está no fim: proxima_sequencia |
| prox_sequencia | Prepara para começar a proxima sequencia. Habilita o contador do limite para ser incrementado uma unidade | inicia_sequencia | transição imediata para o próximo estado |
| fim_timeout | Indica que houve um fim causado pelo timeout | inicia_elementos | jogar = 1 faz passar para o próximo estado |
| fim_ganhou | Indica que houve vitória no jogo após 16 sequencias | inicia_elementos | jogar = 1 faz passar para o próximo estado |
| fim_perdeu | Indica que houve um fim causado por um erro. | inicia_elementos | jogar = 1 faz passar para o próximo estado |

Maquina de estados implementada no projeto

Projeto do Sistema Digital

A integração do fluxo de dados com a unidade de controle será realizada por meio de sinais de controle que coordenam a execução das operações do jogo. A FSM ativará os sinais necessários para permitir a captura das entradas, a atualização da memória e a geração das saídas corretas. Essa abordagem garante um funcionamento sequencial adequado, evitando inconsistências no processamento das jogadas.

O sistema digital será projetado para incluir mecanismos de depuração que permitam visualizar o estado atual do jogo, a posição da memória e os valores comparados. Isso facilitará a análise do funcionamento do circuito durante os testes e a validação da lógica implementada. Além disso, o uso de simulações no ModelSim auxiliará na verificação da correta operação do sistema antes de sua síntese na FPGA.

====================================================================

Plano de Testes do Sistema e Simulações

Cenário de Teste 1 – Acertar todas

O primeiro cenário de teste verificará a operação do jogo em uma situação ideal onde o jogador acerta todas as jogadas. O teste começará com o acionamento do botão "jogar", seguido da inserção correta de cada jogada conforme a sequência armazenada na memória. O sistema deverá responder armazenando cada entrada, exibindo os valores correspondentes nos LEDs e avançando para a próxima jogada.

Esse teste validará a lógica de controle do jogo e a operação dos principais componentes do fluxo de dados. Os sinais de depuração serão utilizados para monitorar a evolução das jogadas e garantir que a FSM transite corretamente entre os estados. A simulação deverá demonstrar que o contador avança adequadamente e que a saída "ganhou" é ativada ao final do jogo.

Tabela 2 – Descrição e Resultados Simulados do Cenário de Teste 1

| Entradas | Saídas Esperadas | Resultado Simulado OK? | Análise de Não Conformidades |
| --- | --- | --- | --- |
| Reset = 1 | Sistema resetado, contador e memória inicializados | ok | - |
| Reset = 0, Jogar = 1 | Sistema aguardando entrada do jogador | ok | - |
| Jogada 1 correta | LED correspondente acende, contador avança | ok | - |
| Jogada 2 correta | LED correspondente acende, contador avança | ok | - |
| … | … | … | - |
| Jogada final correta | Saída "ganhou" ativada | ok | - |

Início da jogada

Fim da quinta sequência e início da sexta

Acerto de todas sequências

Cenário de Teste 2 – Acertar duas sequências e errar

No segundo cenário, o objetivo será testar a resposta do sistema a um erro cometido pelo jogador. Após iniciar o jogo, uma jogada incorreta será inserida deliberadamente em um momento intermediário da sequência. O circuito deverá detectar o erro imediatamente e ativar a saída "perdeu", encerrando o jogo.

Esse teste é essencial para validar a robustez do projeto e garantir que o sistema consiga identificar falhas e reagir corretamente. Durante a simulação, os sinais de depuração serão analisados para confirmar que a FSM detecta a jogada errada e transita corretamente para o estado de término do jogo. Além disso, serão verificadas possíveis inconsistências que possam comprometer a integridade do circuito.

Tabela 3 – Descrição e Resultados Simulados do Cenário de Teste 2

| Entradas | Saídas Esperadas | Resultado Simulado OK? | Análise de Não Conformidades |
| --- | --- | --- | --- |
| Reset = 1 | Sistema resetado, contador e memória inicializados | ok | - |
| Reset = 0, Jogar = 1 | Sistema aguardando entrada do jogador | ok | - |
| Seq 1 correta | LED correspondente acende, contador avança | ok | - |
| Seq 2 correta | LED correspondente acende, contador avança | ok | - |
| Jogada errada | Saída "perdeu" ativada, jogo encerrado | ok | - |

Final da sequência 2, início da 3 e estado de erro

Cenário de Teste 3 – Acertar duas sequências e time out

No segundo cenário, o objetivo será testar a resposta do sistema a um erro cometido pelo jogador. Após iniciar o jogo, uma jogada incorreta será inserida deliberadamente em um momento intermediário da sequência. O circuito deverá detectar o erro imediatamente e ativar a saída "perdeu", encerrando o jogo.

Esse teste é essencial para validar a robustez do projeto e garantir que o sistema consiga identificar falhas e reagir corretamente. Durante a simulação, os sinais de depuração serão analisados para confirmar que a FSM detecta a jogada errada e transita corretamente para o estado de término do jogo. Além disso, serão verificadas possíveis inconsistências que possam comprometer a integridade do circuito.

Tabela 3 – Descrição e Resultados Simulados do Cenário de Teste 2

| Entradas | Saídas Esperadas | Resultado Simulado OK? | Análise de Não Conformidades |
| --- | --- | --- | --- |
| Reset = 1 | Sistema resetado, contador e memória inicializados | OK |  |
| Reset = 0, Jogar = 1 | Sistema aguardando entrada do jogador | OK |  |
| Seq 1 correta | LED correspondente acende, contador avança | OK |  |
| Seq 2 correta | LED correspondente acende, contador avança | OK |  |
| Esperar 3 segundos | Estado time out ativo | OK |  |

Início e acerto das jogadas

Espera de 3 segundos e estado de timeout ativo

====================================================================

Implantação do Projeto

Pinagem da Placa FPGA

A pinagem da FPGA foi realizada utilizando o Pin Planner do Intel Quartus, garantindo que todos os sinais de entrada e saída do circuito estejam corretamente atribuídos aos pinos físicos da placa DE0-CV. A tabela a seguir apresenta a designação dos principais pinos utilizados:

Estratégia de Montagem

A montagem experimental do circuito foi realizada seguindo os seguintes passos:

Configuração da FPGA

Carregar o código Verilog no Intel Quartus.

Gerar e compilar o projeto, garantindo que não haja erros.

Transferir o arquivo de configuração .sof para a placa DE0-CV via cabo USB.

Conexão de Terminais e Fios

Os botões de entrada foram conectados aos GPIOs especificados.

Os LEDs e displays de 7 segmentos foram associados às saídas de depuração e estado do jogo.

A ligação elétrica foi revisada para evitar conexões incorretas.

Monitoramento de Sinais Físicos

O clock foi monitorado através de um osciloscópio.

As saídas foram verificadas diretamente nos LEDs da placa FPGA.

Sinais internos foram analisados utilizando a interface de depuração do Quartus Prime.

Sinais de Depuração

db_clock: Mostra a frequência do sinal de clock.

db_memoria: Indica o dado armazenado na memória no momento da jogada.

db_contagem: Exibe o número da jogada atual.

db_estado: Mostra o estado atual da FSM em um display de 7 segmentos.

Estratégia de Depuração

Para garantir o funcionamento correto do sistema, as seguintes estratégias de depuração foram adotadas:

Simulação no ModelSim

Testes de cada cenário de jogo foram realizados antes da síntese.

Sinais internos, como transições de estados e registros, foram analisados na simulação.

Monitoramento no Quartus Prime

Foram utilizados sinais de depuração exibidos nos LEDs e displays de 7 segmentos da FPGA.

O Signal Tap Logic Analyzer foi usado para capturar eventos internos.

Correção de Problemas

Ajustes no código Verilog foram feitos com base nos resultados da simulação.

Conexões físicas da placa foram verificadas e ajustadas conforme necessário.

Validação Final

Todos os cenários de teste foram executados para garantir que o comportamento do sistema estivesse conforme o esperado.

Foram registrados os tempos de resposta da FSM e possíveis inconsistências foram analisadas.

Execução Prática do Cenário de Teste 1 – <Objetivo Sucinto do Cenário>

Neste cenário, o objetivo é validar a implementação prática do jogo na FPGA e garantir que ele funcione conforme especificado no modelo simulado. O teste começará com o acionamento do botão "Jogar", seguido da inserção correta de cada jogada conforme a sequência armazenada na memória. O sistema deverá responder armazenando cada entrada, exibindo os valores correspondentes nos LEDs e avançando para a próxima jogada.

Durante o teste, os sinais de depuração foram monitorados para garantir que o contador avançasse corretamente e que a FSM transitasse entre os estados esperados. A principal expectativa é que, ao final do jogo, a saída "ganhou" seja ativada, confirmando que todas as jogadas foram realizadas corretamente. Caso alguma diferença seja identificada entre os testes práticos e a simulação, será documentada na seção de análise de não conformidades.

Tabela 4 – Descrição e Resultados Práticos do Cenário de Teste 1

| Entradas | Saídas Esperadas | Resultado Prático OK? | Análise de Não Conformidades |
| --- | --- | --- | --- |
| Reset = 1 | Sistema resetado, contador e memória inicializados | OK | - |
| Reset = 0, Jogar = 1 | Sistema aguardando entrada do jogador | OK | - |
| Jogada 1 correta | LED correspondente acende, contador avança | OK | - |
| Jogada 2 correta | LED correspondente acende, contador avança | OK | - |
| … | … | OK | - |
| Jogada final correta | Saída "ganhou" ativada | OK | - |

Execução Prática do Cenário de Teste 2 - <Objetivo Sucinto do Cenário>

O objetivo deste teste é verificar a resposta do sistema a um erro cometido pelo jogador. Após o início do jogo, uma jogada incorreta será inserida deliberadamente em um momento intermediário da sequência. O circuito deve identificar o erro imediatamente, interromper a execução e ativar a saída "perdeu", encerrando o jogo.

Durante a execução prática, os sinais de depuração foram monitorados para garantir que a FSM transitasse corretamente para o estado de fim de jogo após um erro. Além disso, foi verificado se as saídas e os estados internos permaneceram consistentes com o esperado, assegurando que o jogo não prosseguisse após a detecção do erro.

Tabela 5 – Descrição e Resultados Práticos do Cenário de Teste 2

| Entradas | Saídas Esperadas | Resultado Prático OK? | Análise de Não Conformidades |
| --- | --- | --- | --- |
| Reset = 1 | Sistema resetado, contador e memória inicializados | OK /  | - |
| Reset = 0, Jogar = 1 | Sistema aguardando entrada do jogador | OK | - |
| Jogada 1 correta | LED correspondente acende, contador avança | OK | - |
| Jogada 2 correta | LED correspondente acende, contador avança | OK | - |
| Jogada 3 incorreta | Saída "perdeu" ativada, jogo encerrado | OK | - |
| Tentativa de nova jogada | Sem efeito, aguardando reset | OK | - |

====================================================================

6  Projeto do Desafio da Experiência

Descrição do Desafio

O desafio proposto consiste em adicionar funcionalidades ao Jogo de Sequências de Jogadas, mantendo a mesma interface de entrada e saída da atividade principal. As modificações propostas envolvem:

Implementação de Timeout Individual por Jogada

Cada jogada deve ser realizada dentro de um tempo máximo de 5 segundos.

Se o jogador não pressionar um botão dentro desse tempo, o jogo deve encerrar com a saída "perdeu".

Implementação de Níveis de Dificuldade

Adição de uma entrada nivel para definir a dificuldade do jogo.

Se nivel=0, o jogo opera no modo fácil (até 8 jogadas).

Se nivel=1, o jogo opera no modo normal (até 16 jogadas).

Essas modificações exigem alterações tanto no fluxo de dados quanto na unidade de controle, além da criação de novos sinais de depuração para garantir o correto funcionamento das novas funcionalidades.

Descrição do Projeto Lógico

Alterações da Unidade de Controle

As principais modificações na FSM envolvem:

Modificação da lógica de transição de estados para incluir o nível de dificuldade

Durante a inicialização do jogo, a UC lerá o valor de nivel e ajustará o contador de limite (ContLmt) para 8 ou 16 jogadas.

Verificação e Validação do Desafio

	Simulação desafio - acertar todas nos níveis fácil e difícil

====================================================================

7 Conclusões

O desenvolvimento prévio da experiência, incluindo o projeto lógico e as simulações, permitiu validar a estrutura da unidade de controle e do fluxo de dados antes da implementação prática. A simulação demonstrou que a FSM gerencia corretamente as transições de estado, coordenando a sequência de jogadas e determinando as condições de vitória ou derrota do jogo. Além disso, os testes realizados garantiram que os contadores, registradores e comparadores funcionam conforme o esperado, cumprindo os principais objetivos da experiência.

Entretanto, durante a simulação, foram identificadas possíveis falhas no controle de temporização e na sincronização da memória de jogadas com o contador de endereços, podendo resultar em leituras incorretas. Além disso, houve a necessidade de ajustes no tempo limite para a jogada, garantindo que o estado de timeout ocorra apenas quando necessário. Essas falhas foram documentadas e serão corrigidas durante a implementação na FPGA.


















## Diagramas e reprodução desta edição

Consulte os [diagramas explicativos](../DIAGRAMAS.md), os [objetivos pedagógicos](../OBJETIVOS_PEDAGOGICOS.md) e a [validação](../VALIDACAO.md). As figuras originais não foram republicadas. Os novos diagramas e os testes acompanham as implementações organizadas.

## Autoria e créditos

Luigi Scofano de Araujo · USP 13680334.

Créditos de participação constantes do material de origem: Lucas Lacerda, Paulo Henrique Mota de Oliveira.

## Reprodução e figuras desta edição

[Diagramas explicativos](../DIAGRAMAS.md) · [Validação](../VALIDACAO.md) · [Objetivos pedagógicos](../OBJETIVOS_PEDAGOGICOS.md).
