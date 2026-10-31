# PCS3635-T2BA6-Relato3


Versão revisada para consulta pública. A disposição gráfica foi substituída por texto, tabelas e diagramas novos. Dados pessoais de terceiros e referências privadas foram retirados. Os créditos foram preservados.


Introdução

O objetivo da Experiência 3 é projetar uma unidade de controle para um sistema digital simples, integrando um fluxo de dados previamente desenvolvido. Este sistema deve ser sintetizado em uma placa FPGA DE0-CV e validado através de simulações e testes experimentais. A experiência explora conceitos de máquinas de estado e sua codificação em Verilog, além de técnicas de simulação no ModelSim.

====================================================================

Descrição do Projeto

O sistema digital sequencial gerencia 16 dados de 4 bits armazenados em uma memória interna, onde cada dado ocupa um endereço único. O funcionamento começa com a ativação do sinal "iniciar", que configura o circuito para as condições iniciais, como zerar os contadores e registradores. Em seguida, o sistema captura entradas do usuário por meio de chaves de 4 bits, comparando-as com os dados armazenados na memória. O resultado da comparação é exibido na saída de depuração db_igual, enquanto db_chaves, db_contagem e db_memoria mostram, respectivamente, as chaves fornecidas, o endereço atual da memória e o dado armazenado.

Após cada comparação, o contador interno é incrementado para acessar o próximo endereço, repetindo o ciclo até que todos os 16 dados sejam verificados. Durante o processo, o estado atual do circuito é exibido na saída db_estado, e, ao concluir as operações, o sinal pronto é ativado por um ciclo de clock, indicando o término da execução. O circuito, então, retorna ao estado inicial, aguardando um novo comando. Esse fluxo automatizado e controlado por estados garante eficiência e repetição sem necessidade de intervenção manual.

====================================================================

Detalhamento do Projeto Lógico

O projeto tem como objetivo implementar uma unidade de controle ao comparador feito no experimento 2. As chaves serão usadas como entrada do usuário e seus valores serão comparados com todos os números armazenados na ROM fornecida.

Projeto do Fluxo de Dados

O fluxo de dados do sistema é composto por três componentes principais: um contador, que gera os endereços da memória; um registrador, que armazena os valores das chaves de entrada fornecidas pelo usuário; e uma memória interna, que contém 16 dados de 4 bits acessados sequencialmente. Este fluxo foi adaptado da Experiência 2, incorporando sinais adicionais, como zeraC e contaC, para garantir a comunicação e operação sincronizada com a unidade de controle.

O projeto foi construído com base na estrutura apresentada na figura 5 da apostila, mas ajustes foram necessários para adequá-lo ao experimento. Por exemplo, a entrada "dado" da memória foi descartada, pois não era relevante para a funcionalidade requerida. No módulo do comparador, saídas não diferenciais foram ignoradas, enquanto entradas incompatíveis foram ajustadas para atender às exigências do circuito. Esses ajustes garantiram maior consistência e eficiência no funcionamento do fluxo de dados.

Projeto da Unidade de Controle

A unidade de controle é baseada em uma máquina de estados finitos, projetada para gerenciar a lógica do circuito. Cada estado representa uma fase específica do processo, como inicialização, leitura de dados, comparação ou finalização. A unidade de controle gera sinais como zeraC, registraR e contaC, que comandam os elementos do fluxo de dados.

A transição entre os estados é determinada pelas condições lógicas do circuito, como a ativação do sinal iniciar ou a conclusão da comparação de dados (db_igual). Essa abordagem modular e hierárquica facilita a implementação do circuito em Verilog e garante flexibilidade para futuras modificações.

Tendo isso em vista, a unidade de controle, neste experimento, já foi entregue feita e, portanto, não foi necessário construí-la. Após um estudo da mesma pelo arquivo exp3_unidade_controle.v, foi possível construir o seguinte panorama e completar a tabela 1:

Figura 1 - panorama Unidade de Controle

Tabela 1 – Descrição da Unidade de Controle do Sistema

| Nome do Estado | Descrição do Estado | Próximo Estado | Condições e Justificativas para a Transição entre Estados |
| --- | --- | --- | --- |
| Inicial | Aguardo pelo iniciar | Inicial | iniciar = 0 |
| Inicial | Aguardo pelo iniciar | Preparação | iniciar = 1 |
| Preparação | Configuração das condições iniciais | Registra | - |
| Registra | Armazena valores das chaves | Comparação | - |
| Comparação | Compara valores da chave com dado da ROM | Fim | fimC = 1 |
| Comparação | Compara valores da chave com dado da ROM | Próximo | fimC = 0 |
| Fim | Já foram feitas todas comparações | Inicial | - |
| Próximo | Incrementa contador interno para atualizar dado da memória | Registra | - |

Projeto do Sistema Digital

A integração do sistema digital combina o fluxo de dados com a unidade de controle para formar um circuito funcional e sincronizado. O fluxo de dados é composto por um contador, uma memória e um registrador, enquanto a unidade de controle opera como uma máquina de estados finitos que regula as transições e o comportamento dos componentes através de sinais de controle. Essa integração é realizada por meio de sinais específicos que coordenam a operação dos elementos do fluxo de dados, como zeraC (para resetar o contador), contaC (para incrementá-lo), zeraR (para zerar o registrador) e registraR (para armazenar valores das chaves de entrada). A comunicação bidirecional entre os dois componentes garante que os estados e operações sejam executados de maneira sincronizada com o clock.

Os sinais de depuração desempenham um papel crucial na verificação do sistema durante as simulações e testes práticos. Por exemplo, o sinal db_contagem exibe o endereço atual da memória, permitindo monitorar o progresso do contador interno, enquanto db_memoria mostra o valor armazenado no endereço em questão. O sinal db_chaves exibe o valor capturado das chaves de entrada, e db_estado indica o estado atual da máquina de estados da unidade de controle. Além disso, o sinal db_igual verifica a correspondência entre as chaves de entrada e o dado da memória, sendo ativado quando os valores coincidem. Essa combinação de sinais facilita a identificação de possíveis erros e garante que o comportamento do sistema seja previsível e coerente.

====================================================================

Plano de Testes do Sistema e Simulações

Este capítulo documenta o plano de testes aplicado ao circuito do fluxo de dados, descrevendo os resultados esperados e observados em simulações realizadas com ModelSim. Os testes visam garantir que todas as operações do circuito, como reset, registro, comparação e incremento do contador, sejam realizadas corretamente e sincronizadas com os sinais de controle.

Cenário de Teste 1 – Plano de Testes para o Circuito do Fluxo de Dados 

No Cenário de Teste 1, o objetivo principal é verificar o comportamento do fluxo de dados isoladamente, garantindo que ele responda de forma correta aos sinais de controle enviados pela unidade de controle. O teste inicia com o reset do sistema, onde o contador e o registrador são zerados, e prossegue com uma sequência de operações básicas, como registrar chaves, comparar valores, e incrementar o contador para acessar diferentes endereços na memória.

O plano de testes é estruturado em passos que cobrem todas as funcionalidades do circuito. Inicialmente, todas as entradas são desativadas para validar o estado inicial do circuito. Em seguida, são aplicados pulsos nos sinais de controle, simulando as operações esperadas. A tabela abaixo resume os testes realizados.

Tabela 2 – Descrição e Resultados Simulados do Cenário de Teste 1

| Entradas | Saídas Esperadas | Resultado Simulado OK? | Análise de Não Conformidades |
| --- | --- | --- | --- |
| clock=0, zeraC=0, contaC=0, zeraR=0, registraR=0, chaves=0000 | chavesIgualMemoria=0, fimC=0, db_contagem=0000, db_memoria=0001, db_chaves=0000 | OK | - |
| zeraC=1, zeraR=1, clock=pulso | chavesIgualMemoria=0, fimC=0, db_contagem=0000, db_memoria=0001, db_chaves=0000  | OK | - |
| zeraC=0, contaC=0, zeraR=0, registraR=0, chaves=0001, clock=pulso | chavesIgualMemoria=0, fimC=0, db_contagem=0000, db_memoria=0001, db_chaves=0000  | OK | - |
| chaves=0001, registrarR=1, clock=pulso   | chavesIgualMemoria=1, fimC=0, db_contagem=0000, db_memoria=0001, | OK | - |
| chaves=0001, clock=pulso   | chavesIgualMemoria=1, fimC=0, db_contagem=0000, db_memoria=0001, db_chaves=0001  | OK | - |
| contaC=1, clock=pulso   | chavesIgualMemoria=0, fimC=0, db_contagem=0001, db_memoria=0010, db_chaves=0001  | OK | - |
| chaves=0010 clock=pulso   | chavesIgualMemoria=1, fimC=0, db_contagem=0001, db_memoria=0010, | OK | - |
| chaves=0010 clock=pulso   | chavesIgualMemoria=1, fimC=0, db_contagem=0001, db_memoria=0010, db_chaves=0010 | OK | - |
| contaC=1, clock=pulso   | chavesIgualMemoria=0, fimC=0, db_contagem=0010, db_memoria=0100, db_chaves=0010 | OK | - |
| chaves=1000 clock=pulso  | chavesIgualMemoria=0, fimC=0, db_contagem=0010, db_memoria=0100, | OK | - |
| chaves=1000 clock=pulso   | chavesIgualMemoria=0, fimC=0, db_contagem=0010, db_memoria=0100, db_chaves=1000  | OK | - |
| chaves=1000 clock=pulso  | chavesIgualMemoria=0, fimC=0, db_contagem=0010, db_memoria=0100, db_chaves=1000  | OK | - |
| contaC=1, / clock=pulso(13x)  | chavesIgualMemoria=0, fimC=1, db_contagem=1111, db_memoria=0100, db_chaves=1000 | OK | - |

Cenário de Teste 2 – Plano de Teste para o Circuito da Experiência

O Cenário de Teste 2 avalia a funcionalidade completa do sistema digital, incluindo as transições entre estados, inicialização, registro, comparação, incremento do contador e finalização do ciclo. O objetivo é garantir que o circuito responda corretamente às entradas e que as saídas de depuração (db_contagem, db_memoria, db_estado, pronto, e db_igual) reflitam o comportamento esperado. A tabela abaixo detalha as entradas aplicadas, as saídas esperadas e as análises realizadas.

Tabela 3 – Descrição e Resultados Simulados do Cenário de Teste 2

| Entradas | Saídas Esperadas | Resultado Simulado OK? | Análise de Não Conformidades |
| --- | --- | --- | --- |
| clock=0 reset=0 iniciar=0 chaves=0000 | pronto=0 db_igual=0 db_contagem=0000 db_memoria=0001 db_chaves=0000 db_estado=0000 | OK | - |
| reset=1 clock=pulso | pronto=0 db_igual=0 db_contagem=0000 db_memoria=0001 db_chaves=0000 db_estado=0000 | OK | - |
| reset=0 iniciar=0  / clock  (5x) | (permanece no estado inicial)  / pronto=0  / db_igual=0 db_contagem=0000 db_memoria=0001 db_chaves=0000 db_estado=0000  | OK | - |
| chaves=0100 iniciar=1 clock  | (muda para estado preparação)  / db_igual=0, db_contagem=0000, db_memoria=0001, db_chaves=0100, db_estado=0001 | OK | - |
| chaves=0100 iniciar=0 clock   | (muda para estado registra) / db_igual=0, db_contagem=0000, db_memoria=0001, db_chaves=0100, db_estado=0010 | OK | - |
| chaves=0100 iniciar=0 clock   | (muda para estado comparação) db_igual=0 db_contagem=0000 db_memoria=0001 db_chaves=0100  / db_estado=0011 | OK | - |
| chaves=0100 clock   | (muda para estado próximo)  / db_igual=0, db_contagem=0001, db_memoria=0010, db_chaves=0100, db_estado=0100 | OK | - |
| chaves=0100 clock  (3x) | (passa pelos estados registra, comparação e próximo) pronto=0 db_igual=0 db_contagem=0001 db_memoria=0010 db_chaves=0100  | OK | - |
| chaves=0100 clock  (3x) | (passa pelos estados registra, comparação e próximo) pronto=0 db_igual=1 db_contagem=0010 db_memoria=0100 db_chaves=0100  | OK | - |
| chaves=0100 clock  (3x) | (passa pelos estados registra, comparação e próximo) pronto=0 db_igual=1 db_contagem=0010 db_memoria=0100  | OK | - |
| chaves=0100 clock  (9x) | (passa 3x pelos estados registra, comparação e próximo) pronto=0 db_igual varia 0-1-0 db_contagem varia 0011-0100-0101 db_memoria varia 1000-0100-0010 db_chaves=0100  | OK | - |
| chaves=0001 clock  (6x)  | (Muda para estado registra), db_igual=0, db_contagem=0000, db_memoria=0001, db_chaves=0100, db_estado=0010 | OK | - |
| chaves=0010 clock  (6x) | (Muda para estado comparação), db_igual=0, db_contagem=0000, db_memoria=0001, db_chaves=0100, db_estado=0011 | OK | - |
| chaves=0100 clock  (6x)  | (Muda para estado próximo), db_igual=0, db_contagem=0001, db_memoria=0010, db_chaves=0100, db_estado=0100 | OK | - |
| chaves=1000 clock  (6x)  | (Passa pelos estados registra, comparação e próximo), pronto=0, db_igual=1, db_contagem=0010, db_memoria=0100, db_chaves=0100, db_estado=0100 | OK | - |
| chaves=0001 clock  (3x) | (Passa pelos estados registra, comparação e próximo repetidamente), db_igual varia 0-1-0, db_contagem varia 0011-0100-0101, db_memoria varia 1000-0100-0010, db_chaves=0100, db_estado transita pelos respectivos valores | OK | - |
| chaves=0010 clock  (3x)  | (Passa pelo estado fim), pronto=1, db_contagem=1111, db_memoria=0000, db_chaves=0000, db_estado=1111 | OK | - |
| chaves=0000 clock   | (Termina no estado inicial), pronto=0, db_contagem=0000, db_memoria=0001, db_chaves=0000, db_estado=0000 | OK | - |

====================================================================

Implantação do Projeto

Este capítulo tem o objetivo de documentar as atividades práticas de execução do projeto desenvolvido e documentado no capítulo 3 no ambiente do Laboratório Digital.

Pinagem da Placa FPGA

A pinagem da placa FPGA DE0-CV foi planejada e definida utilizando o recurso “Pin Planner” do software Intel Quartus Prime. Cada sinal do circuito foi atribuído a pinos específicos da FPGA de acordo com a funcionalidade do sistema. Por exemplo, os sinais de entrada, como clock, reset, e iniciar, foram conectados a botões e chaves deslizantes na placa, enquanto os sinais de depuração, como db_estado, db_memoria e db_igual, foram associados aos displays de 7 segmentos e LEDs para visualização em tempo real. A figura gerada no “Pin Planner” ilustra detalhadamente a designação de cada pino, garantindo que a interface física esteja alinhada com o projeto lógico.

Tabela 4 - Planejamento da pinagem

OBS: Nota-se que db_zerac, db_fimc, dbzerar, db_registrar e db_contac não existem nos projetos e nem nos seus planos, e portanto, foram adicionados posteriormente ao pin planner. 

Estratégia de Montagem

Programação da Placa FPGA:

Ligações de Terminais e Fios:

Conecte os botões e chaves da placa FPGA aos sinais de entrada, como reset e iniciar;

Use os displays de 7 segmentos para conectar sinais como db_contagem e db_memoria, e LEDs para exibir db_igual, pronto e db_estado;

Certifique-se de que os conectores de energia e terra (GND) estejam adequadamente configurados.

Durante o processo de testes, o jumper designado para o sinal de RESET estava com mal-contato, o que fazia com que a contagem fosse reiniciada com frequência e de maneira errônea. Além disso, o cabo USB da FPGA estava dando conflito no reconhecimento do USB do Analog Discovery, durante a tentativa de baixar o programa do Quartus Programmer para a placa.

Após a resolução desses problemas de cunho técnico, o sistema funcionou normalmente.

Sinais / Elementos Físicos Monitorados:

Monitore os sinais de saída através dos LEDs e displays configurados;

Utilize um osciloscópio ou um analisador lógico para verificar o sinal do clock e os estados de transição, caso necessário.

Estratégia de Depuração

A depuração do projeto será baseada no monitoramento dos sinais de depuração (db_igual, db_contagem, db_memoria, db_chaves, e db_estado) exibidos nos LEDs e displays da FPGA, garantindo que eles reflitam os estados esperados em cada etapa do ciclo. Caso sejam detectados problemas, ferramentas como osciloscópio (mede sinais em tempo real para verificar clock e transições)  e Analog Discovery (monitora sinais digitais, simula entradas e valida o funcionamento lógico do circuito) serão usadas para verificar a integridade do sinal de clock, capturar formas de onda digitais e identificar comportamentos anômalos.

Se houver inconsistências na lógica do circuito, o código Verilog será revisado e ajustado de forma incremental, recompilado no Quartus e reprogramado na FPGA. Para problemas na montagem física, as conexões serão verificadas e corrigidas com base na configuração do "Pin Planner". Após cada modificação, testes serão realizados para garantir que funcionalidades já validadas não sejam comprometidas, seguindo o plano de testes documentado no tópico 4 e revalidando os sinais de depuração em todas as etapas.

Execução Prática do Cenário de Teste 1 – <Objetivo Sucinto do Cenário>

O objetivo deste cenário é verificar o comportamento básico do circuito durante a inicialização e as primeiras operações do fluxo de dados. Inicia-se com o reset do circuito, garantindo que todos os componentes estejam nos estados iniciais. Em seguida, o circuito processa os primeiros ciclos de operação, capturando os valores de entrada, registrando-os, comparando com os dados da memória e exibindo os resultados nas saídas de depuração.

As saídas esperadas incluem os valores iniciais dos sinais de depuração (db_contagem, db_memoria, db_chaves, e db_estado), que devem refletir a configuração inicial após o reset, e as alterações esperadas após cada pulso de clock. 

Tabela 5 – Descrição e Resultados Práticos do Cenário de Teste 1

| Entradas | Saídas Esperadas | Resultado Prático OK? | Análise de Não Conformidades |
| --- | --- | --- | --- |
| clock=0, zeraC=0, contaC=0, zeraR=0, registraR=0, chaves=0000 | db_contagem=0000, db_memoria=0001, db_chaves=0000, db_estado=0000 | OK | - |
| reset=1, clock=pulso | db_contagem=0000, db_memoria=0001, db_chaves=0000, db_estado=0000 | OK | - |
| reset=0, iniciar=1, clock=pulso | db_contagem=0000, db_memoria=0001, db_chaves=0000, db_estado=0001 | OK | - |
| chaves=0100, iniciar=0, clock=pulso | db_contagem=0000, db_memoria=0001, db_chaves=0100, db_estado=0010 | OK | - |

	A imagem representa o circuito em pleno funcionamento, com os 4 displays de 7 segmentos funcionando e com os jumpers do Analog Discovey conectados.

Execução Prática do Cenário de Teste 2 - <Objetivo Sucinto do Cenário>

O segundo cenário busca validar o comportamento completo do circuito ao longo de todo o ciclo operacional, desde a inicialização até a conclusão do processo. Este teste simula as transições entre estados, verificando se o contador avança corretamente, os dados da memória são lidos conforme esperado, e os sinais de depuração refletem as mudanças nos estados do sistema.

As saídas esperadas incluem os resultados da comparação entre as chaves e os dados da memória (db_igual), as atualizações nos endereços acessados (db_contagem) e o estado final do circuito após o término do ciclo (db_estado). Este cenário permite observar o funcionamento integrado do sistema e diagnosticar possíveis problemas nas interações entre os componentes.

Tabela 6 – Descrição e Resultados Práticos do Cenário de Teste 2

| Entradas | Saídas Esperadas | Resultado Prático OK? | Análise de Não Conformidades |
| --- | --- | --- | --- |
| clock=0, reset=0, iniciar=0, chaves=0000 | db_contagem=0000, db_memoria=0001, db_chaves=0000, db_estado=0000 | OK | - |
| reset=1, clock=pulso | db_contagem=0000, db_memoria=0001, db_chaves=0000, db_estado=0000 | OK | - |
| chaves=0100, iniciar=1, clock=pulso | db_contagem=0000, db_memoria=0001, db_chaves=0100, db_estado=0001 | OK | - |
| chaves=0100, clock=6x | db_contagem varia de 0001 a 0111, db_memoria varia de 0010 a 1000, / db_estado reflete as transições correspondentes | OK | - |

====================================================================

Projeto do Desafio da Experiência

Descrição do Desafio

O desafio propõe a modificação do sistema digital para incluir duas novas saídas, acertou e errou, que indicam se todas as comparações foram bem-sucedidas ou se houve algum erro. Essas saídas são ativadas ao final do processamento, junto com o sinal pronto, permitindo uma análise mais detalhada do desempenho do circuito.

Descrição do Projeto Lógico

Alterações do Fluxo de Dados

	O fluxo de dados permanece igual, dado que foi utilizado chavesIgualMemoria para controle de acerto e erro. 

Alterações da Unidade de Controle

	Para a unidade de controle, foi adicionado uma nova condição de fim de jogo: erro. Isso veio de um novo input errou. O plano inicial foi utilizar essa nova lógica como um jeito de notar acumulação de acertos. Entretanto, foi percebido que se o jogador acertasse todos os 16 números, seria contabilizado como erro. Para isso, foi criado um novo estado fimGanhou de mecânica similar a fim. O estado antigo fim foi usado como um estado de erro.

Alterações do Sistema Digital

No top-level utilizamos o output chavesIgualMemoria negado como input da unidade de controel. Sabemos, então, que enquanto a UC está nos estados Registra, Comparação, Próximo ou fimGanhou, todos os valores até então foram acertados. Dessa forma, o número dos estados foi usado para determinar os novos outputs acertou e errou.

Verificação e Validação do Desafio

Cenário de Teste 1 – Testar o fim após erro

O primeiro cenário de teste verifica se o sistema pode processar corretamente os 16 dados da memória, garantindo que a saída acertou seja ativada ao final quando todas as comparações forem corretas. O objetivo é confirmar que o circuito acumula os resultados das comparações corretamente e que as transições entre os estados funcionam como esperado.

Os testes envolvem fornecer chaves que correspondem exatamente aos valores armazenados na memória. A tabela 7 a seguir resume os parâmetros do teste.

Tabela 7 – Descrição e Resultados do Cenário de Teste 1 para o Desafio

|  | Entradas | Saídas Esperadas | Resultado Simulado OK? | Resultado Prático OK? | Análise de Não Conformidades |
| --- | --- | --- | --- | --- | --- |
| c.i. | reset=1, / clock=pulso | acertou=0, / errou=1, / db_estados=0,  | OK | OK | - |
| 1 | reset=0, iniciar=1 / clock=pulso | acertou=0, / errou=1, / db_estados=1,  | OK | OK | - |
| 2 | chaves= / 0001, /  clock= / 2 pulsos | acertou=1, / errou=0, / db_estados=5,  | OK | OK | - |
| 3 | chaves= / 0010, clock= / 3 pulsos | acertou=1, / errou=0, / db_estados=5,  | OK | OK | - |
| 4 | chaves= / 1000, / clock= / 1pulsos | acertou=0, / errou=1, / db_estados=F,  | OK | OK |  |

Cenário de Teste 2 – Testar vitória

O segundo cenário avalia o comportamento do sistema quando ocorre pelo menos um erro nas comparações. Este teste garante que o sinal errou seja ativado corretamente, mesmo que uma única comparação falhe, enquanto acertou permanece desativado. O objetivo é validar a lógica cumulativa dos erros e o funcionamento da máquina de estados no caso de falhas.

As chaves fornecidas são deliberadamente diferentes de pelo menos um dado da memória. A validação é feita monitorando os sinais de depuração e as saídas acertou e errou ao final do ciclo. A tabela 8 a seguir resume os parâmetros do teste.

Tabela 8 – Descrição e Resultados do Cenário de Teste 1 para o Desafio

| Entradas | Saídas Esperadas | Resultado Simulado OK? | Resultado Prático OK? | Análise de Não Conformidades |
| --- | --- | --- | --- | --- |
| clock=0, reset=1 | acertou=0, errou=0, pronto=0, db_contagem=0000, db_memoria=0000, db_igual=0 | OK | OK | - |
| reset=0, iniciar=1 | acertou=0, errou=0, pronto=0, db_contagem=0000, db_memoria=0000, db_igual=1 | OK | OK | - |
| chaves=0100, clock=1 | acertou=0, errou=1, pronto=0, db_contagem=0001, db_memoria=0010, db_igual=0 | OK | OK | - |
| chaves=1111, clock=15 | acertou=0, errou=1, pronto=1, db_contagem=1111, db_memoria=1111, db_igual=1 | OK | OK | - |

Simulação do modelsim do desafio:

====================================================================

Conclusões

O projeto atingiu os objetivos propostos, com o sistema digital sequencial funcionando corretamente para inicialização, leitura de chaves, comparação de dados e transições de estados. Sinais de depuração, como db_igual e db_contagem, permitiram validar o comportamento do circuito nas simulações e testes práticos.

A implementação na FPGA exigiu pequenos ajustes na pinagem e no código Verilog, mas o sistema apresentou desempenho estável e consistente após as correções. Dessa forma, o projeto consolidou o aprendizado em design e integração de sistemas digitais, cumprindo todos os requisitos propostos.
















## Diagramas e reprodução desta edição

Consulte os [diagramas explicativos](../DIAGRAMAS.md), os [objetivos pedagógicos](../OBJETIVOS_PEDAGOGICOS.md) e a [validação](../VALIDACAO.md). As figuras originais não foram republicadas. Os novos diagramas e os testes acompanham as implementações organizadas.

## Autoria e créditos

Luigi Scofano de Araujo · USP 13680334.

Créditos de participação constantes do material de origem: Lucas Lacerda, Paulo Henrique Mota de Oliveira.

## Reprodução e figuras desta edição

[Diagramas explicativos](../DIAGRAMAS.md) · [Validação](../VALIDACAO.md) · [Objetivos pedagógicos](../OBJETIVOS_PEDAGOGICOS.md).
