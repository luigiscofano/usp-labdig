# PCS3635-T2BA6-planejamento4


Versão revisada para consulta pública. A disposição gráfica foi substituída por texto, tabelas e diagramas novos. Dados pessoais de terceiros e referências privadas foram retirados. Os créditos foram preservados.


Introdução

A Experiência 4 tem como objetivo projetar e implementar um circuito digital utilizando FPGA, abordando o uso de sinais periódicos como clock e a interface com elementos externos para entrada de dados. Este projeto baseia-se na adaptação do circuito desenvolvido na experiência anterior, expandindo sua funcionalidade para gerenciar sinais externos de entrada e utilizar uma máquina de estados adequada para um sinal de clock periódico. Ao final, espera-se compreender os aspectos de síntese e validação em placas FPGA.

====================================================================

Descrição do Projeto

O sistema digital é composto por duas partes principais: o Fluxo de Dados e a Unidade de Controle. O Fluxo de Dados processa as entradas e gera as saídas, enquanto a Unidade de Controle gerencia o comportamento do sistema com base em uma máquina de estados. O circuito inicializa ao receber o sinal de reset e aguarda o comando iniciar para começar. Durante a operação, ele compara os dados de entrada (jogadas) com valores armazenados em uma memória. Caso todas as jogadas sejam corretas, ativa-se a saída acertou; em caso de erro, a saída errou é ativada e o processo é interrompido. O sistema aguarda um novo comando para reiniciar.

====================================================================

Detalhamento do Projeto Lógico

Este capítulo do relatório tem a finalidade de descrever detalhes do projeto lógico desenvolvido na presente experiência.

Projeto do Fluxo de Dados

O fluxo de dados do sistema é responsável pelo armazenamento e manipulação das informações de entrada e saída. Ele inclui um contador interno que percorre os endereços da memória, onde estão armazenados os 16 dados de 4 bits. Adicionalmente, um circuito de detecção de borda (edge detector) é utilizado para processar as entradas das chaves de forma síncrona ao clock, transformando sinais de longa duração em pulsos de um único ciclo. Essa abordagem permite capturar com precisão os eventos acionados manualmente pelo jogador.

O fluxo de dados também conta com registradores para armazenar temporariamente os valores das jogadas e realizar comparações com os dados da memória. Os resultados das comparações são enviados à unidade de controle para decidir a sequência de estados. As saídas de depuração, como db_contagem, db_memoria e db_jogadafeita, permitem monitorar o funcionamento interno do fluxo de dados por meio de displays de 7 segmentos.

Além disso, foi escolhido o RESET estar ativo INICIAR, pois é uma saída que é sempre alta no estado INICIAR e baixa no restante, para que um pulso não fosse confundido em alguma parte mais avançada da máquina de estados. Para isso, o RESET foi conectado no ZeraC.

Visão do fluxo de dados no RTL viewer feito pelo grupo

Projeto da Unidade de Controle

A unidade de controle é implementada como uma máquina de estados finita baseada no diagrama apresentado na Figura 6 da apostila. Cada estado possui uma função específica, como aguardar o início do circuito, capturar uma jogada, ou finalizar o processo.

Tabela 1 – Descrição da Unidade de Controle do Sistema

| Nome do Estado | Descrição do Estado | Próximo Estado | Condições e Justificativas para a Transição entre Estados |
| --- | --- | --- | --- |
| Espera Início | Aguarda o sinal de início do circuito após o reset. | Espera Jogada | Recebe o sinal iniciar. |
| Espera Jogada |  /  /  |  /  /  | Detecta borda no sinal do edge detector. |
| Verifica Jogada | Compara o dado das chaves com o valor armazenado na memória. | Incrementa ou Finaliza | Resultado da comparação (acerto ou erro). |
| Incrementa Contador | Atualiza o endereço da memória para a próxima posição, se o jogador acertar. | Espera Início | Jogada válida e não atingiu o último dado. |
| Final Acerto |  /  /  | Espera Início | Aguarda reinicialização do circuito pelo sinal reset. |
| Final Erro |  / Indica que uma jogada foi incorreta, ativando a saída errou e pronto. /  | Espera Início | Aguarda reinicialização do circuito pelo sinal reset. |

Projeto do Sistema Digital

Visão do projeto no RTL viewer feito pelo grupo

O sistema digital integra o fluxo de dados e a unidade de controle. O fluxo de dados gerencia as operações lógicas e o armazenamento, enquanto a unidade de controle define a lógica sequencial do circuito. A comunicação entre os dois ocorre por meio de sinais de controle, como zeraC (para reiniciar o contador) e contaC (para incrementá-lo), além de sinais de condição, como igual e fimC.

As saídas de depuração, como db_clock, db_estado e db_jogadafeita, são exibidas em LEDs e displays de 7 segmentos, permitindo que o comportamento do circuito seja monitorado em tempo real. Essa integração garante que o sistema responda de forma previsível a eventos externos e facilite a identificação de possíveis erros durante os testes e a depuração.

====================================================================

Plano de Testes do Sistema e Simulações

O plano de testes foi desenvolvido para validar o funcionamento do sistema digital projetado, simulando cenários que cobrem as principais operações esperadas do circuito. As simulações foram realizadas no software ModelSim utilizando o testbench fornecido e complementado para verificar comportamentos esperados em cada cenário.

Cenário de Teste 1 – Acertar todos

Neste cenário, o jogador realiza todas as 16 jogadas corretamente. O objetivo é verificar o comportamento do circuito ao completar o ciclo de operação sem erros. Espera-se que o sinal acertou seja ativado ao final, juntamente com a saída pronto, indicando que o processo foi concluído com sucesso.

As entradas incluem o acionamento sequencial das chaves em correspondência com os dados armazenados na memória. As saídas simuladas são observadas para confirmar se as comparações são feitas corretamente, se o contador é incrementado de forma adequada, e se o estado final é alcançado.

Tabela 2 – Descrição e Resultados Simulados do Cenário de Teste 1

| Entradas | Saídas Esperadas | Resultado Simulado OK? | Análise de Não Conformidades |
| --- | --- | --- | --- |
| Reset=1 | Sistema resetado, contador e memória inicializados | OK | - |
| Reset=0, Iniciar=1 | Sistema aguardando a primeira jogada | OK | - |
| Chave[0]=Dado[0] | db_igual=1, db_contagem=0x01, db_memoria=0xA | OK | - |
| Chave[1]=Dado[1] |  /  /  | OK | - |
| … | … | OK | - |
| Chave[15]=Dado[15] | acertou=1, pronto=1, db_estado=“Final Acerto” | OK | - |

Cenário de Teste 2 – Três acertos Um erro

Este cenário avalia a resposta do sistema ao detectar um erro. Após três jogadas corretas, o jogador erra a quarta jogada. O objetivo é garantir que o sistema interrompa o ciclo de operação e ative as saídas errou e pronto corretamente.

As entradas simulam o erro intencional no momento correspondente à quarta jogada. O circuito deve interromper o processo imediatamente e desativar os sinais relacionados à sequência correta.

Tabela 3 – Descrição e Resultados Simulados do Cenário de Teste 2

| Entradas | Saídas Esperadas | Resultado Simulado OK? | Análise de Não Conformidades |
| --- | --- | --- | --- |
| Reset=1 |  /  /  | OK | - |
| Reset=0, Iniciar=1 | Sistema aguardando a primeira jogada | OK | - |
| Chave[0]=Dado[0] | db_igual=1, db_contagem=0x01, db_memoria=0xA | OK | - |
| Chave[1]=Dado[1] | db_igual=1, db_contagem=0x02, db_memoria=0xB | OK | - |
| Chave[2]=Dado[2] | db_igual=1, db_contagem=0x03, db_memoria=0xC | OK | - |
| Chave[3]!=Dado[3] | errou=1, pronto=1, db_estado=“Final Erro” | OK | - |

====================================================================

Implantação do Projeto

Este capítulo tem o objetivo de documentar as atividades práticas de execução do projeto desenvolvido e documentado no capítulo 3 no ambiente do Laboratório Digital. 

Pinagem da Placa FPGA

Descrever em um parágrafo e incluir obrigatoriamente uma figura legível do “pin planner” do Intel Quartus evidenciando a realização da 

A configuração foi verificada no Quartus Prime para garantir que todos os sinais estão corretamente associados aos elementos físicos.

Obs: os dados sem pinagem foram colocados para melhor depuração durante a modelagem do processo

Estratégia de Montagem

Programação da FPGA:

Compile o projeto no Quartus Prime.

Use o Programmer para transferir o arquivo de configuração .sof para a FPGA DE0-CV via conexão USB.

Certifique-se de que a FPGA está configurada corretamente, verificando os LEDs de status.

Ligações Físicas:

Conecte os terminais de entrada (botões e switches) aos pinos GPIO configurados.

Verifique se os LEDs e displays de 7 segmentos estão corretamente conectados e funcionando.

Monitoramento de Sinais:

Sinais como db_clock, db_estado, e db_memoria devem ser monitorados em tempo real nos displays e LEDs.

Use o Analog Discovery para gerar o clock externo e monitorar sinais de entrada e saída.

Depuração Inicial:

Execute o circuito com condições de teste básicas para verificar a funcionalidade de entrada/saída.

Estratégia de Depuração

Monitoramento de Sinais:

Utilize os displays e LEDs para verificar a execução dos estados e transições do circuito.

 Analise as formas de onda em um osciloscópio para confirmar a sincronização do clock e a resposta do circuito às entradas.

Recursos de Depuração:

Use o Analog Discovery para gerar sinais de teste com clock ajustável.

Utilize o ModelSim para simulações detalhadas em busca de inconsistências.

Correções em Caso de Problemas:

Ajuste o código Verilog no Quartus Prime caso sejam identificados erros na lógica.

Verifique conexões físicas e substitua componentes defeituosos, se necessário.

     d)  Manutenção da Estabilidade:

Após ajustes, execute testes de regressão para garantir que as alterações não comprometeram funcionalidades previamente verificadas.

Execução Prática do Cenário de Teste 1 – <Objetivo Sucinto do Cenário>

O cenário testa o funcionamento do sistema em condições normais, com todas as jogadas corretas.

Tabela 4 – Descrição e Resultados Práticos do Cenário de Teste 1

| Entradas | Saídas Esperadas | Resultado Prático OK? | Análise de Não Conformidades |
| --- | --- | --- | --- |
| Reset=1 | Sistema reinicializado | OK | - |
| Reset=0, Iniciar=1 | Sistema aguardando entrada | OK | - |
| Chave[0]=Dado[0] |  /  /  | OK | - |
| … | … | OK | - |
| Chave[15]=Dado[15] | acertou=1, pronto=1 | OK | - |

Execução Prática do Cenário de Teste 2 - <Objetivo Sucinto do Cenário>

Este cenário avalia a resposta do sistema ao detectar uma jogada incorreta.

Tabela 5 – Descrição e Resultados Práticos do Cenário de Teste 2

| Entradas | Saídas Esperadas | Resultado Prático OK? | Análise de Não Conformidades |
| --- | --- | --- | --- |
| Reset=1 | Sistema reinicializado | OK | - |
| Reset=0, Iniciar=1 | Sistema aguardando entrada | OK | - |
| Chave[0]=Dado[0] | db_igual=1, db_contagem=0x01, db_memoria=0xA | OK | - |
| Chave[3]!=Dado[3] | errou=1, pronto=1 | OK | - |

====================================================================

Projeto do Desafio da Experiência

Descrição do Desafio

O objetivo do desafio é alterar o projeto da Atividade 2 para implementar um mecanismo de timeout no processo de verificação das chaves. A cada rodada, o circuito deve permitir a espera pelo acionamento das chaves de entrada por um período máximo de 3 segundos. Caso o tempo limite seja atingido sem nenhuma jogada, uma saída chamada db_timeout deve ser ativada, e o jogo deve terminar, acionando o sinal errou.

Descrição do Projeto Lógico

Alterações do Fluxo de Dados

Adicionar um contador de tempo para medir o período máximo de 3 segundos, baseado no sinal de clock (50 MHz).

Ajustar a lógica para interromper o fluxo normal e ativar o sinal errou se o timeout for detectado.

Alterações da Unidade de Controle

Incluir novos estados para gerenciar o timeout:

	•	Um estado de timeout caso o contador exceda o limite de 3 segundos.

	•	Atualizar os estados de finalização para lidar com a ativação de db_timeout.

	•	Adicionar transições para retornar ao estado inicial após o término do jogo por timeout.

Alterações do Sistema Digital

Conectar o novo contador de tempo ao fluxo de dados e à unidade de controle.

Adicionar a saída db_timeout ao sistema digital, mapeando-a para um LED ou outro elemento físico para depuração.

Verificação e Validação do Desafio

Cenário de Teste 1 – <Objetivo Sucinto do Cenário>

Plano de Testes:

	1.	Cenário 1 – Jogada Dentro do Tempo:

	•	Verificar se o sistema funciona normalmente quando uma jogada é realizada antes do limite de 3 segundos.

	2.	Cenário 2 – Timeout:

	•	Confirmar que o sistema ativa db_timeout e termina o jogo quando o tempo limite é excedido.

	3.	Cenário 3 – Não Regressão:

	•	Garantir que o sistema mantém o comportamento original (sem erros) quando não há timeout.

Tabela 6 – Descrição e Resultados do Cenário de Teste 1 para o Desafio

| Entradas | Saídas Esperadas | Resultado Simulado OK? | Resultado Prático OK? | Análise de Não Conformidades |
| --- | --- | --- | --- | --- |
| Reset=1 | Sistema resetado | OK | OK | - |
| Reset=0, Iniciar=1 | Sistema aguardando entrada  | OK | OK | - |
| Jogada dentro do tempo | Fluxo normal, db_timeout=0 | OK | OK | - |
| sem jogada (<3s) | db_timeout=1, jogo termina com errou /  | OK | OK | - |

Os resultados, tanto práticos quanto teóricos, se adequaram perfeitamente ao esperado para o experimento. O timeout foi implementado com sucesso e, em caso de espera maior que 3 segundos, o sistema considera como um erro.

ATIVIDADE 4:

Respostas às Perguntas de Aprofundamento

	1.	O que acontece no circuito caso fosse possível realizar duas jogadas consecutivas em menos de 3 ms?

Se duas jogadas consecutivas forem realizadas em menos de 3 ms, o edge detector poderá não identificar corretamente o segundo acionamento, já que o circuito foi projetado para operar com entradas humanas, onde cada jogada tem duração significativamente maior que esse intervalo. Isso resultaria na perda da primeira jogada ou no registro incorreto dos dados. 

             2.	Alterações para inclusão do nível de dificuldade

Para implementar a funcionalidade de seleção de nível de dificuldade, as seguintes alterações seriam necessárias:

	•	No Fluxo de Dados: Adicionar um registrador chamado nivel_reg para armazenar o nível selecionado. Esse valor será utilizado para configurar o número máximo de jogadas que o contador interno deve alcançar. Além disso, pode-se adicionar uma entrada de controle para ser conectada a um multiplexador, que, por sua vez, unifica qual memória deve ser usada, cada uma respectiva a. Um nível de dificuldade diferente.

	•	Na Unidade de Controle: Adicionar transições no estado inicial para configurar nivel_reg com base na nova entrada nivel. Nos estados de verificação, será necessário adicionar uma condição para encerrar o jogo quando o número de jogadas atingir o limite especificado pelo nível.

====================================================================

Conclusões

O projeto lógico e as simulações realizadas antes da aula cumpriram os objetivos principais da experiência. O circuito mostrou-se funcional, com transições corretas de estados e resposta adequada aos cenários simulados. Pequenos ajustes foram necessários, como melhorias na sincronização do edge detector e na configuração dos displays de 7 segmentos, corrigidos antes da síntese.





















## Diagramas e reprodução desta edição

Consulte os [diagramas explicativos](../DIAGRAMAS.md), os [objetivos pedagógicos](../OBJETIVOS_PEDAGOGICOS.md) e a [validação](../VALIDACAO.md). As figuras originais não foram republicadas. Os novos diagramas e os testes acompanham as implementações organizadas.

## Autoria e créditos

Luigi Scofano de Araujo · USP 13680334.

Créditos de participação constantes do material de origem: Lucas Lacerda, Paulo Henrique Mota de Oliveira.

## Reprodução e figuras desta edição

[Diagramas explicativos](../DIAGRAMAS.md) · [Validação](../VALIDACAO.md) · [Objetivos pedagógicos](../OBJETIVOS_PEDAGOGICOS.md).
