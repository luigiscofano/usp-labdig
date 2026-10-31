# PCS3635-T5BA6-relato3


Versão revisada para consulta pública. A disposição gráfica foi substituída por texto, tabelas e diagramas novos. Dados pessoais de terceiros e referências privadas foram retirados. Os créditos foram preservados.


1. Introdução

Esta experiência tem como objetivo central o desenvolvimento de um circuito digital capaz de realizar a interface com o sensor ultrassônico HC-SR04 para medição de distância. 

O sensor ultrassônico é amplamente utilizado em dispositivos de medição de distância, como trenas digitais e sistemas embarcados de detecção de obstáculos. Ele opera emitindo pulsos sonoros de 40 kHz que viajam no ar à velocidade do som e retornam após refletirem em um objeto. O circuito digital deverá calcular a distância com base na largura do pulso de resposta (echo).

Assim, além de projetar a unidade de controle e o fluxo de dados, será necessário considerar técnicas de interfaceamento, já que o sensor opera com alimentação de 5 V e a FPGA utiliza 3,3 V.

2. Descrição do Projeto

As trenas digitais modernas utilizam diferentes tecnologias de medição de distância, incluindo feixes laser e ondas ultrassônicas. No caso do HC-SR04, o funcionamento baseia-se na emissão de ondas ultrassônicas, no cálculo do tempo de voo até o objeto e na recepção do sinal refletido.

A velocidade do som varia conforme a temperatura ambiente (entre 319 m/s a -20 ºC e 355 m/s a 30 ºC), mas é usual adotar o valor nominal de 340 m/s a 15 ºC. O circuito implementado deve ser capaz de compensar variações de tempo na ordem de microssegundos e converter esse valor para centímetros.

Interface do Sensor

O HC-SR04 possui quatro pinos principais: VCC (5 V), GND, TRIGGER e ECHO. Para iniciar a medição, deve-se enviar ao pino TRIGGER um pulso de 10 µs. Em seguida, o sensor gera internamente 8 pulsos de 40 kHz e ativa a saída ECHO, cujo tempo em nível alto é proporcional à distância medida.

Na FPGA, a leitura da largura do ECHO deve ser feita com precisão de microssegundos. O circuito projetado deve gerar o pulso TRIGGER, medir a largura do ECHO e, a partir disso, calcular a distância em cm.

Interfaceamento Elétrico

Como a FPGA DE0-CV trabalha com sinais LVCMOS de 3,3 V, é necessário o uso de buffers de conversão de nível:

74LS365: buffer com alta capacidade de corrente (24 mA), usado para ligar saídas da FPGA a dispositivos de 5 V.


74HC4050: buffer com entradas tolerantes a sobretensão, permitindo conectar sinais de 5 V (como o ECHO do sensor) às entradas de 3,3 V da FPGA
interface-sensor-distancia-2025…
.


Sem esse interfaceamento, o circuito poderia ser danificado ou funcionar de forma incorreta.

Projeto do Circuito

O módulo interface_hcsr04 segue a seguinte especificação:

module interface_hcsr04 (

    input wire clock,

    input wire reset,

    input wire medir,

    input wire echo,

    output wire trigger,

    output wire [11:0] medida,

    output wire pronto,

    output wire [3:0] db_estado

);

Fluxo funcional:

Receber medir.


Gerar pulso TRIGGER (10 µs).


Aguardar início do ECHO.


Contar largura do ECHO em ciclos de clock.


Converter o valor para distância (cm).


Exibir em 3 dígitos BCD (000–999).


Ativar sinal pronto.


Parte Experimental

Projeto e Simulação

O planejamento inclui:

Fluxo de Dados: gerador de trigger, contador de largura, conversor tempo→distância, registradores.


Unidade de Controle: FSM coordenando estados Idle → Trigger → WaitEcho → Measure → Calc → Done.


Testbench: uso do interface_hcsr04_tb.v no ModelSim, aprimorado para testar diferentes larguras de pulso ECHO e verificar resultados.


Estratégia de Teste em Bancada

Posicionar o objeto em distâncias pré-definidas.


Acionar medir e registrar o valor exibido nos displays.


Usar o Analog Discovery para observar trigger e echo (via db_trigger e db_echo).


Avaliar precisão (valor correto da medida) e estabilidade (baixa variação entre medidas repetidas).


Síntese e Montagem

O módulo final exp3_sensor deve incluir:

Conversores hex7seg para exibir os dígitos HEX0–HEX2.


Detector de borda em medir.


Sinais de depuração: db_medir, db_trigger, db_echo, db_estado.


Pinagem mínima

CLOCK → CLK_50


RESET → SW0


MEDIR → SW1


TRIGGER → GPIO_1_D1


ECHO → GPIO_1_D3


HEX0–HEX2 → Displays


PRONTO → LEDR0


db_trigger → GPIO_1_D33 (Scope CH1+)


db_echo → GPIO_1_D35 (Scope CH2+)


db_estado → HEX5

3. Detalhamento do Projeto Lógico

3.1 Projeto do Fluxo de Dados

O fluxo de dados é responsável pelas operações aritméticas e de armazenamento, coordenando os elementos que de fato tratam os sinais do sensor. Ele é formado por três blocos principais:

contador_cm (U2)


Conta o tempo em ciclos de clock correspondente à largura do pulso do echo.


A saída do contador fornece os dígitos em BCD (digito0, digito1, digito2) que representam a distância em cm.


Possui saídas de controle:


fim → indica que a contagem terminou.


pronto → habilita o armazenamento do valor final.


registrador_n (U3)


Recebe o valor do contador (12 bits) e armazena como valor estável da distância medida.


É ativado pelo sinal enable vindo da UC, garantindo que a medida só seja registrada no instante correto.


Suas saídas vão para o sistema externo como distancia[11:0].


gerador_pulso (U1)


Gera o pulso de trigger com largura fixa de 10 µs para iniciar a medição no sensor HC-SR04.


Este pulso é enviado à saída trigger, que será ligado diretamente ao pino TRIGGER do sensor.


Resumo técnico:
 O fluxo de dados mede a largura do pulso echo, converte para centímetros via contador, registra o valor e o disponibiliza como saída. Ele também gera o pulso inicial de trigger.

3.2 Projeto da Unidade de Controle

A unidade de controle organiza a sequência de operações do sistema por meio de uma máquina de estados finita (FSM).

Estados (em amarelo):


inicial / preparação → aguarda o comando medir.


envia_trigger → habilita o gerador de pulso de trigger.


espera_echo → aguarda a chegada do pulso de echo.


medida → habilita o contador para contar a largura do echo.


final_medida → identifica o fim do pulso e encerra a contagem.


armazenamento → habilita o registrador_n para salvar o valor final.


Portas lógicas (WideOr3, WideOr4, WideOr5):


Combinam sinais de diferentes estados para ativar os controles gera, registra, zera.


Garantem que cada bloco do fluxo de dados só atue no momento correto.


Saídas principais:


gera → ativa o gerador_pulso.


registra → habilita o registrador_n para armazenar a distância.


zera → reseta o contador.


pronto → indica que a medição foi concluída.


db_estado[3:0] → exporta o estado atual para depuração.


Resumo técnico:
 A UC define a lógica temporal: inicia o trigger, espera o echo, mede o pulso, registra o valor e sinaliza que a medição terminou. Ela atua como o “cérebro” do sistema, controlando os blocos do fluxo de dados.

3.3 Integração do Sistema

O FD faz a parte numérica: medir tempo, converter e armazenar.


A UC garante a sequência correta: idle → trigger → medir → armazenar → pronto.


Juntos, formam o circuito completo de interface com o HC-SR04.

4. Plano de Testes do Sistema e Simulações

O plano de testes prevê verificar se a saída serial corresponde à sequência esperada, com foco em tempo de bit, correta inserção do bit de paridade e sincronismo do sinal pronto.

O ModelSIM abaixo representa a simulação do testbench forncedio.

contador_cm teste[0]: resposta 100, conforme o esperado

contador_cm teste[1]: resposta 100, conforme o esperado

contador_cm teste[2]: resposta 74, conforme o esperado

contador_cm teste[3]: resposta 75, conforme o esperado

interface hcsr04 teste[0]: resposta 100, conforme o esperado

interface hcsr04 teste[1]: resposta 100, conforme o esperado

interface hcsr04 teste[2]: resposta 74, conforme o esperado

interface hcsr04 teste[2]: resposta 75, conforme o esperado

O que foi testado

Temos dois conjuntos de testes:

contador_cm – o bloco que mede a largura do pulso echo (em ciclos de clock) e converte para distância em centímetros (BCD).


interface_hcsr04 – o topo da interface (FSM + fluxo de dados): gera o trigger, captura o echo, manda medir, armazena a distância e aciona pronto.


Interpretação dos resultados

Bloco contador_cm

teste[0]: resposta 100, conforme o esperado


teste[1]: resposta 100, conforme o esperado

 Esses dois casos injetam no contador um pulso echo que corresponde a 100 cm.

teste[2]: resposta 74, conforme o esperado


teste[3]: resposta 75, conforme o esperado

 Aqui colocamos pulsos próximos do limiar entre 74 e 75 cm.


74 cm → T≈74×58,82=4352,68 μsT \approx 74 \times 58{,}82 = 4352{,}68\,\mu sT≈74×58,82=4352,68μs (~217 634 ciclos).


75 cm → T≈4411,50 μsT \approx 4411{,}50\,\mu sT≈4411,50μs (~220 575 ciclos).


O meio-termo (ponto de troca por arredondamento) é 74,5 cm, isto é,
 T≈74,5×58,82=4382,09 μsT \approx 74{,}5 \times 58{,}82 = 4382{,}09\,\mu sT≈74,5×58,82=4382,09μs (~219 104,5 ciclos).


Portanto:


Se o echo ficou abaixo de ~4382,09 µs → 74 cm (teste[2]).


Se ficou acima → 75 cm (teste[3]).


Isso confirma que o método de arredondamento do contador_cm está certo (não está truncando para baixo): você está efetivamente “arredondando para o mais próximo”.


Conclusão do módulo: o contador_cm converte tempos em distâncias com arredondamento correto e estável, inclusive na borda entre dois valores.

Topo interface_hcsr04

teste[0]: resposta 100, conforme o esperado


teste[1]: resposta 100, conforme o esperado


teste[2]: resposta 74, conforme o esperado


teste[3]: resposta 75, conforme o esperado


Esses testes repetem os mesmos estímulos, agora passando pela FSM e pelos sinais de controle:

A UC gera o trigger (10 µs).


Espera o início do echo.


Habilita o contador_cm enquanto echo=1.


Ao cair do echo, manda armazenar no registrador_n.


Atualiza medida (BCD) e sinaliza pronto.


Os quatro resultados batendo com o esperado provam que:

A sequência da FSM (trigger → wait_echo → measure → calc/armazenamento → pronto) está correta.


O handshake UC ↔ fluxo de dados (sinais gera, zera, registra) ocorre no ciclo certo (sem “off-by-one”).


O valor que aparece em medida é o mesmo que o contador_cm geraria sozinho (integração OK).

5. Implantação do Projeto

5.1 Pinagem da Placa FPGA

Tabela 1 - Planejamento da pinagem

| Sinal |  Pino na Placa DE0-CV | Pino no FPGA | Analog Discovery |
| --- | --- | --- | --- |
| clock | CLK_50  | m9 |  |
| db_estado[0] | led LEDR[6] | u2 |  |
| db_estado[1] | led LEDR[7] | u1 |  |
| db_estado[2] | led LEDR[8] | l2 |  |
| db_estado[3] | led LEDR[9] | l1 |  |
| echo | GPIO_1_D3  | b12 |  |
| medida[20] | HEX 26 | ab21 |  |
| medida[19] | HEX 25 | ab22 |  |
| medida[18] | HEX 24 | v14 |  |
| medida[17] | HEX 23 | y14 |  |
| medida[16] | HEX 22 | aa10 |  |
| medida[15] | HEX 21 | ab17 |  |
| medida[14] | HEX 20 | y19 |  |
| medida[13] | HEX 16 | u22 |  |
| medida[12] | HEX 15 | aa17 |  |
| medida[11] | HEX 14 | ab18 |  |
| medida[10] | HEX 13 | aa18 |  |
| medida[9] | HEX 12 | aa19 |  |
| medida[8] | HEX 11 | ab20 |  |
| medida[7] | HEX 10 | aa20 |  |
| medida[6] | HEX 06 | aa22 |  |
| medida[5] | HEX 05 | y21 |  |
| medida[4] | HEX 04 | y22 |  |
| medida[3] | HEX 03 | w21 |  |
| medida[2] | HEX 02 | w22 |  |
| medida[1] | HEX 01 | v21 |  |
| medida[0] | HEX 00 | u21 |  |
| medir | chave SW1 | v13 |  |
| pronto | led LEDR[0] | aa2 |  |
| reset | chave SW0  | u13 |  |
| trigger | GPIO_1_D1 | a12 |  |

5.2 Estratégia de Montagem

Programar FPGA no Quartus.


Ligar HC-SR04 via protoboard e 74HC4050 (nível 5V→3,3V).


Medir com objeto em distâncias conhecidas (5 cm, 50 cm, 1 m, 2 m).


Usar Scope do Analog Discovery p/ verificar trigger e echo.


5.3 Estratégia de Depuração

A depuração será feita em duas etapas:

Validar largura do trigger (≈10 µs).


Confirmar proporcionalidade da largura do echo com distância.


Usar db_trigger/db_echo para debug visual.


Comparar cálculo do sistema com valores reais medidos.

Simulação: usando ModelSim para verificar máquina de estados, sinal de tick e sequência transmitida, utilizando os diversos sinais de debug.


Prática em bancada: monitorar a saída no osciloscópio e no analisador de protocolos. Sinais de depuração internos serão usados para confirmar estados e transições.

6. Projeto do Desafio da Experiência

O desafio propõe a elaboração de um sistema digital em FPGA que controle simultaneamente um servomotor e um sensor ultrassônico de distância. A ideia é posicionar o conjunto servo+HC-SR04 em três ângulos distintos e realizar medições de distância em cada posição, possibilitando a detecção de múltiplos objetos em diferentes direções, como em um sonar simplificado.

O módulo Verilog desenvolvido (exp3_desafio) deve:

Receber a entrada posicao, que define três ângulos possíveis para o servomotor.


Acionar o servomotor, colocando o sensor no ângulo definido.


Executar a medição de distância por meio do HC-SR04 a cada posição (via entrada medir).


Fornecer a saída correspondente em displays e sinais de depuração.

O conjunto servo + sensor HC-SR04 é orientado para três ângulos distintos (ex.: esquerda, centro, direita).


Em cada ângulo, o sensor emite o pulso ultrassônico e mede a distância até o objeto posicionado nessa direção.


O sistema coleta e registra três distâncias diferentes, correspondentes a Objeto 1, Objeto 2 e Objeto 3.


Esse esquema ilustra como o FPGA, ao controlar o servo, cria um mapeamento angular do ambiente, semelhante a um radar de varredura.

Ademais:

interface_hcsr04INT: realiza a interface do sensor ultrassônico, responsável pela geração do trigger, medição do echo e cálculo da distância.


controle_servoSRV (em destaque no retângulo vermelho): módulo que gera o sinal PWM para posicionar o servomotor em três ângulos possíveis. Ele é controlado pela entrada posicao.


detector_bordaDB: detecta bordas no sinal de medir, convertendo em pulsos de controle sincronizados.


hex7seg: módulos codificadores responsáveis por converter as medidas de distância em BCD para exibição nos displays HEX0–HEX3.


Sinais de depuração (db_): exportados para LEDs, displays e GPIOs, permitindo monitorar no Analog Discovery os pulsos de trigger, echo, PWM do servo e estados da UC.


Esse arranjo permite verificar não apenas se o sensor mede corretamente, mas também se o servomotor está sendo posicionado no ângulo certo antes de cada medição.

7. Conclusões (Relato)

O planejamento mostra que o sistema é tecnicamente viável e modular. As simulações previstas devem confirmar que a largura do echo é corretamente convertida em centímetros, e a implementação na FPGA exibirá valores consistentes nos displays.

O desafio deve aprimorar a robustez do sistema, explorando novas técnicas de filtragem, resolução ou sinalização adicional, consolidando o aprendizado de projeto digital em FPGA.



















## Diagramas e reprodução desta edição

Consulte os [diagramas explicativos](../DIAGRAMAS.md), os [objetivos pedagógicos](../OBJETIVOS_PEDAGOGICOS.md) e a [validação](../VALIDACAO.md). As figuras originais não foram republicadas. Os novos diagramas e os testes acompanham as implementações organizadas.

## Autoria e créditos

Luigi Scofano de Araujo · USP 13680334.

Créditos de participação constantes do material de origem: Lucas Lacerda, Paulo Henrique Mota de Oliveira.

## Reprodução e figuras desta edição

[Diagramas explicativos](../DIAGRAMAS.md) · [Validação](../VALIDACAO.md) · [Objetivos pedagógicos](../OBJETIVOS_PEDAGOGICOS.md).
