# Documento sem título


Versão revisada para consulta pública. A disposição gráfica foi substituída por texto, tabelas e diagramas novos. Dados pessoais de terceiros e referências privadas foram retirados. Os créditos foram preservados.


1. Introdução

Nesta experiência, o objetivo é projetar e implementar um Sistema de Sonar digital em FPGA, capaz de realizar a varredura angular de um ambiente utilizando um servomotor e um sensor ultrassônico HC-SR04. A cada posição angular, o sistema mede a distância até o objeto mais próximo e envia os resultados através de comunicação serial UART. A montagem prática será feita na placa FPGA DE0-CV, integrando diversos módulos desenvolvidos em experiências anteriores, agora refatorados e adaptados.

2. Objetivos

Aplicar conceitos de sistemas digitais síncronos para controlar servomotor, sensor e transmissão serial.


Implementar a varredura sequencial de 8 posições angulares do sonar (20° a 160°).


Medir a distância ao objeto mais próximo e transmitir os dados no formato ASCII:


“ângulo,distância#” (exemplo: 120,017#).


Realizar integração modular de circuitos já testados:


Controle de servo (PWM).


Interface com sensor HC-SR04.


Transmissão UART (115200/7E1).


Validar o funcionamento por simulação no ModelSim e testes na bancada.


3. Descrição Técnica do Projeto

3.1 Arquitetura Geral

O sistema é composto por três blocos principais:

Controle do Servomotor (controle_servo)


Gera sinais PWM para posicionar o sonar em 8 ângulos fixos.


Cada posição é definida por uma largura de pulso (0,7 ms a 2,2 ms).


Interface com Sensor HC-SR04 (interface_hcsr04)


Emite o pulso Trigger (10 µs).


Mede a largura do pulso Echo, convertendo-o em centímetros.


Transmissão Serial (tx_serial_7E1)


Converte ângulo e distância em códigos ASCII.


Envia no formato “XXX,YYY#” a 115200 bauds.


A Unidade de Controle (UC) coordena os blocos, garantindo a sequência correta:

Posiciona o servo.


Mede distância.


Transmite dados.


Aguarda tempo de espera.


Passa à próxima posição.

3.2 Fluxo de Dados (FD)

Registradores armazenam ângulo atual e distância medida.


Uma ROM (rom_angulos_8x24.v) contém os códigos ASCII dos ângulos pré-definidos .


Multiplexadores selecionam qual informação será transmitida.


Sinais de controle coordenam início/fim de medição e envio.

3.3 Unidade de Controle (UC)

FSM de estados principais:

Idle: espera ligar=1.


Medida: ativa Trigger e mede Echo.


Serial: envia ângulo e distância.


Fim_Posicao: gera pulso indicando conclusão.


Reposiciona: incrementa ângulo e recomeça ciclo.

4. Metodologia de Desenvolvimento

Etapa 1: Revisão dos módulos das experiências anteriores (servo, trena digital, UART).


Etapa 2: Simulação unitaria no ModelSim de cada módulo.


Etapa 3: Integração incremental → servo + sensor, depois servo + UART, até sistema completo.


Etapa 4: Criação do testbench do sistema sonar, com geração de casos de Echo simulados.


Etapa 5: Síntese e teste em bancada, monitorando sinais de depuração.


5. Plano de Testes

Objetivo
 Verificar, em nível de sistema, se a cadeia de medição e formatação está funcionando: geração de trigger, medição de echo, conversão para BCD, seleção de caracteres (incluindo ângulo via ROM), e controle de transmissão 7E1, com variação controlada da posição do servo.


Configuração


timescale 1ns/1ns, clock = 50 MHz (período 20 ns).


Reset síncrono aplicado no início.


Dispositivo em teste: topo exp4_trena.


Metodologia (passo a passo por caso)


Define a posição do servo (posicao_in) para um dos valores de interesse.


Gera um pulso “mensurar” (5 ciclos de clock).


Aguarda 400 µs (latência fixa de modelo).


Aplica echo=1 por um tempo específico (em µs) e, em seguida, baixa para 0.


Espera a UC sinalizar pronto (fim da sequência de 8 símbolos).


Coleta dados de debug:


medida_bcd_dbg (centena/dezena/unidade, 12 bits BCD) do FD.


ascii7_dbg (7 bits) representando o caractere ASCII atual selecionado.


Insere 100 µs de espaçamento antes do próximo caso.


Cenários exercitados


Caso 1: posicao=000 e echo=5882 µs (≈ 100 cm).


Caso 2: posicao=111 e echo=4399 µs (≈ 75 cm).


Caso 3: posicao=011 e echo=5899 µs (≈ 100,3 cm).
 Observação: a conversão exata de largura de echo para centímetros/BCD é feita pelo interface_hcsr04_fd do projeto; o TB apenas injeta tempos de echo realistas e observa a saída.


Por que observar ascii7_atual e medida_bcd?


medida_bcd confirma a medição e o pipeline de conversão.


ascii7_atual confirma o multiplexador de símbolos (ângulo via ROM rom_angulos_8x24, vírgula, dígitos da distância e ‘#’). O TB mantém a leitura simples (não decodifica a UART), focando na lógica interna que alimenta o transmissor.


Critérios de aprovação esperados


Para cada cenário:


pronto pulsa exatamente uma vez após a sequência de 8 símbolos.


medida_bcd corresponde ao arredondamento/truncamento implementado no FD para a largura de echo aplicada.


Sem travamentos: sinais avançam entre estados e retornam ao IDLE para o próximo cenário.

Pontos Relevantes do modelSim:

Transmissão Serial (tx_out) funcionando para as 3 medições do TB.

Controle do Servo Motor (pwm_out) funcionando para os três cenários propostos: 000, 111, 011, respectivamente.

reset, mensurar, trigger, echo de acordo com o esperado.

medidas corretas (elas estão em 7bits por causa do display 7 segmentos).


6. Plano de Depuração

db_posicao (servo) → conectado ao HEX para verificar ângulo atual.


db_pwm (servo) → analisado no osciloscópio (largura de pulso).


db_estado (UC) → mostrado em HEX5 para validar sequência FSM.


db_trigger/db_echo (sensor) → monitorados no Analog Discovery.


db_saida_serial → analisado no Protocol Analyzer para checar ASCII.


fim_posicao → LEDR0, confirma conclusão de ciclo.


7. Execução Experimental

Programar FPGA com módulo servo isolado, validar PWM no osciloscópio.

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
| pwm | pino GPIO_1_D9 | G17 |  |
| medida[0] | chave SW7 | AA13 |  |
| medida[1] | chave SW8 | AB13 |  |
| medida[2] | chave SW9 | AB12 |  |

Integrar sensor ultrassônico → medir 10, 50, 100 cm e comparar com régua.


Conectar transmissão serial → checar no PC se chega no formato correto.


Executar varredura completa (8 ângulos) e validar sequência de transmissão.


Capturar sinais no Analog Discovery para anexar no relatório.


8. Desafio

9. Conclusões

A Experiência 5 – Sistema de Sonar amplia os conceitos anteriores ao integrar servo, sensor e UART em um único sistema coordenado. O projeto proporciona contato com sistemas digitais complexos, enfatizando FSM, controle temporal e comunicação externa, além de reforçar a importância da simulação, depuração e testes incrementais para o sucesso do desenvolvimento.









## Diagramas e reprodução desta edição

Consulte os [diagramas explicativos](../DIAGRAMAS.md), os [objetivos pedagógicos](../OBJETIVOS_PEDAGOGICOS.md) e a [validação](../VALIDACAO.md). As figuras originais não foram republicadas. Os novos diagramas e os testes acompanham as implementações organizadas.

## Autoria e créditos

Luigi Scofano de Araujo · USP 13680334.

Créditos de participação constantes do material de origem: Lucas Lacerda, Paulo Henrique Mota de Oliveira.

## Reprodução e figuras desta edição

[Diagramas explicativos](../DIAGRAMAS.md) · [Validação](../VALIDACAO.md) · [Objetivos pedagógicos](../OBJETIVOS_PEDAGOGICOS.md).
