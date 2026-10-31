# PCS3635-T2BA6-relatorioP1


Versão revisada para consulta pública. A disposição gráfica foi substituída por texto, tabelas e diagramas novos. Dados pessoais de terceiros e referências privadas foram retirados. Os créditos foram preservados.


Introdução

O objetivo do projeto é implementar um sistema digital que apresente sequências de jogadas ao jogador e avalie suas respostas, utilizando uma FPGA. A implementação busca garantir um funcionamento preciso, permitindo que o jogador interaja com o sistema de forma intuitiva e responsiva.

O jogo foi desenvolvido em Verilog, utilizando conceitos fundamentais de sistemas digitais, como contadores, registradores e comparadores. A FPGA será programada para controlar a lógica do jogo, assegurando que cada rodada ocorra conforme especificado. Esse planejamento inclui a definição dos componentes necessários, as interações entre eles e os critérios de teste para validar o funcionamento correto do jogo.

Descrição do Projeto

O jogo consiste na apresentação sequencial de LEDs que o jogador deve replicar pressionando os botões correspondentes. A cada rodada, uma nova jogada é adicionada à sequência. O jogo termina quando o jogador erra ou atinge o limite de 16 jogadas. Dessa forma, o sistema precisa ser capaz de armazenar e recuperar sequências progressivamente maiores, garantindo que o jogador seja desafiado constantemente.

Para gerenciar essa dinâmica, o projeto inclui módulos responsáveis por controlar a apresentação dos LEDs, registrar as respostas do jogador e avaliar se ele acertou ou errou. Um sistema de temporização garante a exibição correta das jogadas, e um mecanismo de verificação determina o fim da partida caso haja erro ou sucesso completo. Esses elementos são projetados para interagir de maneira eficiente e garantir uma experiência de jogo fluida.

Detalhamento do Projeto Lógico

Este capítulo do relatório tem a finalidade de descrever detalhes do projeto lógico desenvolvido na presente experiência.

Projeto do Fluxo de Dados

O Fluxo de dados pode ser descrito em duas partes: 

Contador e Comparador para controle do limite de cada sequência da rodada.

Dois registradores, contador, memória ROM, comparador e Timer que controlam o funcionamento de cada uma das rodadas.

Projeto da Unidade de Controle

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

Cenário de Teste 1 – Vitória 

O jogador acertou as 16 sequências.

Tabela 2 – Descrição e Resultados Simulados do Cenário de Teste 1

Cenário de Teste 2 – 2 acertos e erro 

O jogador errou na primeira jogada da 3a rodada.

Tabela 3 – Descrição e Resultados Simulados do Cenário de Teste 2

Joogada = 0 indica que trata-se da primeira jogada da sequência.

Sequência = 2 indica que trata-se da terceira sequência.

Estado = F aponta para o estado Fim Perdeu.

Botoes = 0010 indica que a jogada foi 2.

Dado Real = 0001 mostra que o dado esperado da ROM era 1.

BotãoIgualMemoria = 0 Indica que a igualdade é Falsa.

Portanto, a simulação foi bem sucedida.

Implantação do Projeto

Este capítulo tem o objetivo de documentar as atividades práticas de execução do projeto desenvolvido e documentado no capítulo 3 no ambiente do Laboratório Digital. 

Pinagem da Placa FPGA

RTL Viewer:

Execução Prática do Cenário de Teste 1 – Acerta todas no nível fácil - ROM1

	Nesse cenário foi necessário acertar todas as jogadas no nível fácil primeiramente na ROM1(fornecida ao grupo). Todos resultados foram conforme o esperado.

Execução Prática do Cenário de Teste 2 – Acerta todas no nível fácil - ROM2

	Nesse cenário foi necessário acertar todas as jogadas no nível fácil na segunda ROM (construída pelo grupo). Todos resultados foram conforme o esperado.

Execução Prática do Cenário de Teste 3 – Acerta todas no nível difícil - ROM1

	Nesse cenário foi necessário acertar todas as jogadas no nível difícil na ROM1. Todos resultados foram conforme o esperado.

Execução Prática do Cenário de Teste 4 – Errar Na Terceira Sequência

	Nesse cenário foi necessário acertar todas as jogadas até a terceira sequência e, então, errar. Todos resultados foram conforme o esperado.

Execução Prática do Cenário de Teste 5 –Esperar Timeout

	Nesse cenário foi necessário esperar 5 segundos e identificar os sinais de tim. Todos resultados foram conforme o esperado.

Projeto do Desafio da Experiência

Descrição do Desafio

O desafio consiste na elaboração de uma chave que pausa o Time Out. Além disso, deve ser implementado um contador que contabilize o número de acionamentos dessa chave.

Descrição do Projeto Lógico

Para manter o projeto o mais parecido possível com o original, optou-se por realizar as seguintes modificações no fluxo de dados:

Alterações da Unidade de Controle.

Foram modificadas as configurações de transição de estado para o estado Espera levando em consideração o caráter prioritário do pausa_timeout. Basicamente a condição para passar para a etapa de registrar a jogada é expressa como (jogada & ~Timeout) || (jogada & pausarTO). Para transicionar para o Fim TimeOut : (~jogada & Timeout & ~pausarTO).

Além disso, a chave Pausa Timeout, foi devidamente instanciada como input da UC e do Top Level.

Alterações do Top Level

No Top Level foi implementado um edge detector para gerar um pulso de pausa do timeout e esse pulso foi implementado como enable do contador de acionamentos do timeout. Posteriormente os dados do contador foram convertidos para o display HEX 5.

Verificação e Validação do Desafio

A implementação do desafio foi concluída e validada pelos monitores.

Conclusões

A experiência da prova foi realizada como uma verificação dos conhecimentos acumulados nos últimos experimentos, sem necessidade de desenvolvimento de algo significativo. Se consolidou como um teste e análise dos conhecimentos de simulação no ModelSim, implementação do projeto na FPGA e pensamento lógico em adaptações de projeto.















## Diagramas e reprodução desta edição

Consulte os [diagramas explicativos](../DIAGRAMAS.md), os [objetivos pedagógicos](../OBJETIVOS_PEDAGOGICOS.md) e a [validação](../VALIDACAO.md). As figuras originais não foram republicadas. Os novos diagramas e os testes acompanham as implementações organizadas.

## Autoria e créditos

Luigi Scofano de Araujo · USP 13680334.

Créditos de participação constantes do material de origem: Paulo Henrique Mota de Oliveira.

## Reprodução e figuras desta edição

[Diagramas explicativos](../DIAGRAMAS.md) · [Validação](../VALIDACAO.md) · [Objetivos pedagógicos](../OBJETIVOS_PEDAGOGICOS.md).
