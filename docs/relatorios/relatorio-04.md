# PCS3645-T5BA6-relato4


Versão revisada para consulta pública. A disposição gráfica foi substituída por texto, tabelas e diagramas novos. Dados pessoais de terceiros e referências privadas foram retirados. Os créditos foram preservados.


1. Introdução

Nesta quarta experiência, o objetivo principal é implementar uma trena digital baseada no sensor ultrassônico HC-SR04, já utilizado em etapas anteriores do laboratório, e estender suas funcionalidades para incluir a transmissão serial UART. Assim, além de exibir o valor da medida nos displays de 7 segmentos, o sistema também enviará, caractere por caractere, o valor correspondente em código ASCII para um dispositivo externo, como um computador, finalizando a mensagem com o caractere especial ‘#’.

Este projeto consolida diversos conceitos estudados ao longo do curso, incluindo o uso de máquinas de estados finitas (FSM), a organização do fluxo de dados para operações aritméticas e controle de registradores, e a utilização de protocolos de comunicação digital. Além disso, reforça a importância de se considerar tanto a temporização do sistema (em nível de ciclos de clock e tempos de bit) quanto o interfaceamento elétrico entre FPGA, sensor e módulos de saída. O resultado esperado é um sistema que una capacidade de medida física real (distância em centímetros) com capacidade de comunicação digital padronizada (protocolo UART).

2. Descrição do Circuito e da Simulação

2.1 Fluxo de Dados

O Fluxo de Dados (FD) da experiência é o coração aritmético e funcional do projeto. Ele reúne blocos que já foram desenvolvidos em etapas anteriores, como o módulo de interface com o HC-SR04, que gera o pulso de trigger de 10 µs, captura o sinal de echo e, a partir da largura medida, converte o tempo de voo da onda ultrassônica em centímetros. Esse valor é armazenado em registradores codificados em BCD, prontos para exibição nos displays.

A novidade é a incorporação de um transmissor serial UART ao fluxo. Esse módulo é responsável por transformar os números medidos em caracteres ASCII. O processo envolve selecionar cada dígito (centenas, dezenas e unidades), adicionar o deslocamento para o código ASCII de números (0x30) e enviar sequencialmente os bits pela linha de transmissão serial, seguindo o padrão 115200 bauds, 7E1. Para organizar o envio, um contador associado ao multiplexador (MUX) define qual caractere está sendo transmitido a cada instante: primeiro as centenas, depois as dezenas, em seguida as unidades, e por fim o caractere ‘#’ que sinaliza o fim da transmissão.

Esse arranjo exige sinais de sincronização internos, como fim_contador (indica que todos os caracteres já foram transmitidos), pronto_medida (indica que a conversão da distância foi concluída) e pronto_serial (confirma o fim da transmissão de um caractere). Assim, o FD consegue se organizar para fornecer informações corretas e completas, tanto para os displays quanto para a saída serial.

2.2 Unidade de Controle (UC) e Funcionamento

A Unidade de Controle (UC) funciona como o “cérebro” do sistema, sendo responsável por orquestrar os diferentes módulos do FD. Ao contrário de um projeto em que cada caractere seria tratado por um estado específico, a UC desta experiência foi projetada para ser mais compacta e eficiente, utilizando poucos estados e deixando para o fluxo de dados e para o contador a responsabilidade de iterar sobre os caracteres.

O funcionamento segue uma sequência bem definida: o sistema inicia em um estado de preparação, aguardando o acionamento do comando de medida. Ao receber esse comando, a UC aciona o FD para gerar o pulso trigger, aguardar o echo e registrar o valor da distância. Em seguida, entra em um estado de espera até receber o sinal pronto_medida, que confirma que o valor foi convertido e armazenado. A partir desse ponto, a UC inicia a transmissão serial, controlando os sinais de seleção do MUX e aguardando o pronto_serial a cada caractere enviado. Quando o contador interno atinge o fim da sequência, o sinal fim_contador é ativado, levando a UC ao estado final e garantindo que todo o ciclo foi concluído corretamente.

Esse arranjo de UC compacta e FD mais detalhado é uma solução eficiente, pois simplifica a lógica de controle e torna o sistema mais escalável para futuras modificações, como aumentar a quantidade de caracteres transmitidos ou incluir novos formatos de saída.

| Estado Atual | Próximo Estado | Condição/Acão |
| --- | --- | --- |
| CENTENA_REQ | CENTENA_START | (tx_pronto) |
| CENTENA_REQ | CENTENA_REQ | (!tx_pronto) |
| CENTENA_START | CENTENA_WAIT |  |
| CENTENA_WAIT | DEZENA_REQ | (tx_pronto) |
| CENTENA_WAIT | CENTENA_WAIT | (!tx_pronto) |
| DEZENA_REQ | DEZENA_START | (tx_pronto) |
| DEZENA_REQ | DEZENA_REQ | (!tx_pronto) |
| DEZENA_START | DEZENA_WAIT |  |
| DEZENA_WAIT | DEZENA_WAIT | (!tx_pronto) |
| DEZENA_WAIT | UNIDADE_REQ | (tx_pronto) |
| DONE | IDLE |  |
| HASH_REQ | HASH_REQ | (!tx_pronto) |
| HASH_REQ | HASH_START | (tx_pronto) |
| HASH_START | HASH_WAIT |  |
| HASH_WAIT | DONE | (tx_pronto) |
| HASH_WAIT | HASH_WAIT | (!tx_pronto) |
| IDLE | IDLE | (!mensurar_pulso) |
| IDLE | KICK_MEASURE | (mensurar_pulso) |
| KICK_MEASURE | WAIT_MEASURE_READY |  |
| UNIDADE_REQ | UNIDADE_REQ | (!tx_pronto) |
| UNIDADE_REQ | UNIDADE_START | (tx_pronto) |
| UNIDADE_START | UNIDADE_WAIT |  |
| UNIDADE_WAIT | HASH_REQ | (tx_pronto) |
| UNIDADE_WAIT | UNIDADE_WAIT | (!tx_pronto) |
| WAIT_MEASURE_READY | CENTENA_REQ | (medida_pronta) |
| WAIT_MEASURE_READY | WAIT_MEASURE_READY | (!medida_pronta) |

2.3 Simulação no ModelSim

Antes de levar o sistema para a placa FPGA, é fundamental validar o seu funcionamento no ambiente de simulação. Para isso, será utilizado o testbench exp4_trena_tb.v, que fornecerá estímulos representando diferentes larguras de echo (ou seja, diferentes distâncias medidas). A simulação deverá confirmar se o pulso trigger possui largura de 10 µs, se o tempo do echo é corretamente convertido em centímetros, e se o valor resultante aparece corretamente nos três dígitos de saída.

Outro ponto crítico da simulação é a transmissão serial. Será verificado se a linha de transmissão envia a sequência correta de bits, respeitando a temporização do protocolo UART a 115200 bauds. Por exemplo, se a distância medida for 172 cm, a simulação deverá mostrar a transmissão dos caracteres ASCII “1”, “7”, “2”, seguidos pelo caractere de encerramento “#”. O testbench também permitirá verificar sinais internos, como o estado da UC (db_estado), a geração do trigger (db_trigger), a leitura do echo (db_echo) e a linha de saída serial (db_saida_serial), o que facilita a depuração e a verificação detalhada de cada etapa.

Conforme destacado, percebe-se que a transmissão serial foi bem sucedida.

3. Preparação para Síntese na Placa

3.1 Plano de Teste

O plano de teste experimental consiste em uma série de casos cuidadosamente escolhidos para cobrir tanto situações normais quanto situações extremas. Inicialmente, o sistema será resetado e os displays deverão exibir zero, enquanto a UC retorna ao estado inicial. Em seguida, com o comando de mensuração, o trigger deve ser gerado e o sistema deve entrar no ciclo de medição. Para objetos colocados a 10 cm, espera-se que o valor “010” apareça nos displays e seja transmitido serialmente. O mesmo se aplica a distâncias médias (50 cm → “050”) e maiores (100 cm → “100”).

Também será verificado o comportamento fora da faixa útil do sensor, como quando não há objeto no alcance (acima de 4 m). Nesses casos, a UC deve encerrar o ciclo e retornar a um estado definido (como exibir valor máximo ou nulo). Além disso, cada transmissão serial será monitorada para garantir que todos os caracteres sejam enviados em ordem correta e finalizados com o caractere ‘#’.

3.2 Plano de Execução Experimental

Na prática, os testes seguirão uma sequência ordenada: primeiramente, configurar a FPGA com o projeto compilado no Quartus e conectar a porta USB-Serial ao computador. Em seguida, acionar o reset e confirmar que os displays são zerados. Após isso, realizar medidas com um objeto em distâncias conhecidas (10, 50, 100 cm) e observar tanto o valor exibido nos displays quanto o valor recebido via terminal serial no PC. Durante cada medição, o Analog Discovery será utilizado para capturar as formas de onda dos sinais de trigger e echo, garantindo que os tempos estejam corretos. Por fim, serão verificadas as transmissões seriais, analisando bit a bit a saída para confirmar conformidade com o protocolo UART.

3.3 Pinagem na FPGA

Tabela 1 - Planejamento da pinagem

| Sinal |  Pino na Placa DE0-CV | Pino no FPGA | Analog Discovery |
| --- | --- | --- | --- |
| clock | CLK_50  | m9 |  |
| echo | pino GPIO_1_D3 | b12 |  |
| mensurar | botão KEY0  | u7 |  |
| pronto | led LEDR0  | aa2 |  |
| reset | chave SW0 | u13 |  |
| saida serial | pino GPIO_0_D1  | b16 |  |
| trigger | pino GPIO_1_D1  | a12 |  |
| medida2[6] | HEX 26 | ab21 |  |
| medida2[5] | HEX 25 | ab22 |  |
| medida2[4] | HEX 24 | v14 |  |
| medida2[3] | HEX 23 | y14 |  |
| medida2[2] | HEX 22 | aa10 |  |
| medida2[1] | HEX 21 | ab17 |  |
| medida2[0] | HEX 20 | y19 |  |
| medida1[6] | HEX 16 | u22 |  |
| medida1[5] | HEX 15 | aa17 |  |
| medida1[4] | HEX 14 | ab18 |  |
| medida1[3] | HEX 13 | aa18 |  |
| medida1[2] | HEX 12 | aa19 |  |
| medida1[1] | HEX 11 | ab20 |  |
| medida1[0] | HEX 10 | aa20 |  |
| medida0[6] | HEX 06 | aa22 |  |
| medida0[5] | HEX 05 | y21 |  |
| medida0[4] | HEX 04 | y22 |  |
| medida0[3] | HEX 03 | w21 |  |
| medida0[2] | HEX 02 | w22 |  |
| medida0[1] | HEX 01 | v21 |  |
| medida0[0] | HEX 00 | u21 |  |

Plano de Testes

O plano de testes organiza os experimentos em laboratório para validar o funcionamento correto da trena digital em todos os cenários previstos. Os testes foram divididos em casos funcionais, de borda e de exceção.

| ID | Caso de Teste | Entradas/Condições de Execução | Saída Esperada | Observações |
| --- | --- | --- | --- | --- |
| T1 | Reset Inicial | reset=1 por alguns ciclos | Displays zerados, UC em estado inicial, saída serial inativa | Confirma inicialização limpa e estável |
| T2 | Acionamento de Medida | mensurar=1 | Trigger de 10 µs gerado, UC migra para estado Medida | Verificar forma de onda do trigger no osciloscópio |
| T3 | Medida Curta (10 cm) | Objeto a ~10 cm → echo ≈ 588 µs | Displays mostram “010”; saída serial envia “0”, “1”, “0”, “#” | Confirmar largura de echo com Analog Discovery |
| T4 | Medida Média (50 cm) | Objeto a ~50 cm → echo ≈ 2941 µs | Displays mostram “050”; saída serial envia “0”, “5”, “0”, “#” | – |
| T5 | Medida Longa (100 cm) | Objeto a ~100 cm → echo ≈ 5882 µs | Displays mostram “100”; saída serial envia “1”, “0”, “0”, “#” | – |
| T6 | Fora de Alcance | Objeto acima de 4 m ou sem reflexão | Displays mostram valor nulo ou máximo definido; saída serial envia “000#” ou similar | Verifica comportamento em ausência de eco válido |
| T7 | Teste de Transmissão Serial | Qualquer medida (ex.: 172 cm) | Saída serial transmite sequência ASCII “1”, “7”, “2”, “#”, em 115200/7E1 | Validar bit a bit com Protocol Analyzer |
| T8 | Estado Final | Após envio do último caractere (#) | UC entra no estado Final; pronto=1; transmissão paralisa até próxima medida | Garante que FSM retorna aocíclo |

Plano de Depuração

A depuração é essencial para identificar e corrigir erros no sistema. Para isso, serão utilizados sinais internos de depuração exportados para LEDs, displays auxiliares e GPIOs, monitorados no Analog Discovery.

Estratégias de Depuração

Trigger


Observar db_trigger no osciloscópio para verificar se o pulso possui 10 µs.


Caso a largura esteja incorreta, revisar o contador do módulo gerador_pulso.


Echo


Monitorar db_echo para validar se o pulso recebido corresponde à distância real.


Se houver instabilidade, revisar o contador de largura e o interfaceamento via 74HC4050.


FSM (db_estado)


Exibir os estados da UC no display HEX5.


Confirmar a sequência correta: Idle → Medida → Espera_Medida → Transmissão → Final.


Se houver travamento, verificar condições de transição entre estados.


Saída Serial (db_saida_serial)


Usar o Protocol Analyzer do Analog Discovery para analisar bit a bit a linha serial.


Validar se a sequência é ASCII correta e se o caractere final ‘#’ é transmitido.


Conferir temporização (1/115200 ≈ 8,68 µs por bit).


Displays (HEX0–HEX2)


Comparar o valor exibido com o valor real da distância medida.


Se houver discrepância, inspecionar a conversão BCD e o registrador de saída.


LED PRONTO


O LEDR0 deve acender ao final de cada ciclo de medição e transmissão.


Caso não ocorra, verificar sinais de controle fim_contador e pronto_serial.

4. Desafio

Para o desafio da experiência, o objetivo é realizar duas medições, uma após a outra,com um intervalo de 2 segundos, com apenas uma ação do usuário. Durante as mudanças técnicas do projeto, foram criados novos estados para representar a primeira medição, estado de espera de 2 segundos e segunda medição.

5. Conclusões

O planejamento detalha a construção da trena digital com saída serial, integrando medições do HC-SR04 com transmissão UART. O projeto combina módulos prévios e amplia o escopo para comunicação externa, consolidando conceitos de sistemas digitais síncronos em FPGA.










## Diagramas e reprodução desta edição

Consulte os [diagramas explicativos](../DIAGRAMAS.md), os [objetivos pedagógicos](../OBJETIVOS_PEDAGOGICOS.md) e a [validação](../VALIDACAO.md). As figuras originais não foram republicadas. Os novos diagramas e os testes acompanham as implementações organizadas.

## Autoria e créditos

Luigi Scofano de Araujo · USP 13680334.

Créditos de participação constantes do material de origem: Lucas Lacerda, Paulo Henrique Mota de Oliveira.

## Reprodução e figuras desta edição

[Diagramas explicativos](../DIAGRAMAS.md) · [Validação](../VALIDACAO.md) · [Objetivos pedagógicos](../OBJETIVOS_PEDAGOGICOS.md).
