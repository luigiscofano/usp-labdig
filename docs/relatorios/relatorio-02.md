# PCS3635-T5BA6-relato2


Versão revisada para consulta pública. A disposição gráfica foi substituída por texto, tabelas e diagramas novos. Dados pessoais de terceiros e referências privadas foram retirados. Os créditos foram preservados.


1. Introdução

O objetivo principal desta experiência é projetar, simular e implementar um circuito digital capaz de realizar transmissão serial assíncrona de dados em conformidade com o padrão RS-232C. A proposta didática é permitir que os alunos entendam a fundo o funcionamento do protocolo, desde a estrutura de bits até os ajustes necessários para diferentes configurações de transmissão.

Nesta atividade, partiremos de um projeto base que utiliza a configuração 7N2 (7 bits de dados, sem paridade, 2 stop bits) a 9600 bauds, realizando modificações para alcançar a configuração 7E1 (7 bits de dados, paridade par, 1 stop bit) a 115200 bauds. Dessa forma, consolidamos tanto os conceitos teóricos de comunicação serial quanto a prática de desenvolvimento com Verilog, Quartus Prime, ModelSim e FPGA DE0-CV.

2. Descrição do Projeto

O sistema desenvolvido é responsável por enviar caracteres ASCII através de uma linha serial, seguindo a lógica de transmissão assíncrona. No estado inicial (idle), o circuito aguarda o acionamento do sinal de partida, momento em que carrega os dados de entrada, gera o bit de paridade e inicia a transmissão. A sequência de bits transmitida será: start bit (0), 7 bits de dados, paridade (even), stop bit (1).

A principal modificação em relação ao projeto base é a inclusão do cálculo do bit de paridade e a alteração do controle da máquina de estados para apenas 1 stop bit, além da mudança do divisor de clock que ajusta a taxa de comunicação de 9600 bauds para 115200 bauds. Assim, enquanto no projeto inicial o tempo de bit era aproximadamente 104,17 µs, no projeto modificado será de 8,68 µs por bit, exigindo maior precisão no controle.

Fluxograma simplificado do funcionamento:

Reset inicializa todo o circuito.


Aguardamos o acionamento de partida.


O registrador carrega os 7 bits de dados e calcula a paridade.


O transmissor envia a sequência completa na saída serial.


Ao final, o sinal pronto é ativado por um ciclo de clock, indicando disponibilidade para nova transmissão.


3. Detalhamento do Projeto Lógico

3.1 Projeto do Fluxo de Dados

O fluxo de dados é responsável por armazenar e deslocar os bits a serem transmitidos. Ele é composto pelos seguintes blocos:

Registrador de deslocamento: recebe os 7 bits de entrada e o bit de paridade, deslocando-os para a saída a cada tick.


Gerador de paridade: calcula a paridade par a partir dos 7 bits de dados.


Contador de bits: controla quantos bits já foram transmitidos, garantindo o envio correto da sequência.


Multiplexador: seleciona o bit apropriado (start, dados, paridade ou stop) para a saída.


Essa estrutura garante modularidade, permitindo que ajustes sejam feitos sem comprometer a lógica global do sistema.

3.2 Projeto da Unidade de Controle

A unidade de controle é implementada como uma máquina de estados finita (FSM), responsável por definir a ordem e o tempo de transmissão.

Tabela – Descrição da Unidade de Controle do Sistema

| Estado | Descrição de Estado | Próximo Estado | Condições ; Sinais Ativos |
| --- | --- | --- | --- |
| Idle | Aguardando partida; saída serial em nível alto | Start |  |
| Start | Envia bit de start (0) | Data |  |
| Data |  /  /  | Paridade |  |
| Paridade |  /  /  | Stop |  |
| Stop |  /  /  | Pronto |  |
| Pronto |  /  /  | Idle |  |

3.3 Integração do Sistema Digital

O sistema integrado une a FSM (UC) e o fluxo de dados, sincronizados pelo sinal de tick, derivado do clock principal da placa. Além disso, sinais de depuração (db_tick, db_estado, db_saida_serial) foram incluídos para análise no ModelSim e no Analog Discovery. Essa integração facilita tanto a verificação em simulação quanto a depuração em bancada.

4. Plano de Testes do Sistema e Simulações

O plano de testes prevê verificar se a saída serial corresponde à sequência esperada, com foco em tempo de bit, correta inserção do bit de paridade e sincronismo do sinal pronto.

O ModelSIM abaixo representa a simulação do testbench forncedio.

Nessa simulação, percebe-se a transferência do sinal serial quando dado um input de partida e um impulso de pronto quando o sinal termina de ser transferido.

Acima, está representada a execução física na FPGA do testbench proposto. 

Já nessa imagem, representamos a transmissão física na FPGA da letra U maiúscula.

5. Implantação do Projeto

5.1 Pinagem da Placa FPGA

Tabela 1 - Planejamento da pinagem

| Sinal |  Pino na Placa DE0-CV | Pino no FPGA | Analog Discovery |
| --- | --- | --- | --- |
| CLOCK | CLOCK 50 | M9 |  |
| RESET | SW0 | U13 |  |
| PARTIDA | SW1 | V13 |  |
| DADOS_ASCII(0) | SW2 | T13 |  |
| DADOS_ASCII(1) … DADOS_ASCII(6) | SW3 | T12 |  |
| DADOS_ASCII(1) … DADOS_ASCII(6) | SW4 | AA15 |  |
| DADOS_ASCII(1) … DADOS_ASCII(6) | SW5 | AB15 |  |
| DADOS_ASCII(1) … DADOS_ASCII(6) | SW6 | AA14 |  |
| DADOS_ASCII(1) … DADOS_ASCII(6) | SW7 | AA13 |  |
| DADOS_ASCII(1) … DADOS_ASCII(6) | SW8 | AB13 |  |
| PRONTO | LED R9 | L1 |  |
| SAIDA_SERIAL | GPIO_0_D1  | B16 | +1 |
| db_clock | LED R0 | AA2 |  |
| db_estado(0)... / db_estado(6) | HEX 00 | U21 |  |
| db_estado(0)... / db_estado(6) | HEX 01 | V21 |  |
| db_estado(0)... / db_estado(6) | HEX 02 | W22 |  |
| db_estado(0)... / db_estado(6) | HEX 03 | W21 |  |
| db_estado(0)... / db_estado(6) | HEX 04 | Y22 |  |
| db_estado(0)... / db_estado(6) | HEX 05 | Y21 |  |
| db_estado(0)... / db_estado(6) | HEX 06 | AA22 |  |
| db_partida | LED R1 | AA1 |  |
| db_saida_serial | LED R8 | L2 |  |
| db_tick | LED R7 | U1 |  |

5.2 Estratégia de Montagem

Programar o circuito sintetizado no Quartus na placa DE0-CV.


Conectar a saída serial ao Scope do Analog Discovery.


Monitorar a largura de bit (esperado ≈ 8,68 µs).


Após validação, migrar para o Protocol Analyzer para confirmar o padrão RS-232C.


5.3 Estratégia de Depuração

A depuração será feita em duas etapas:

Simulação: usando ModelSim para verificar máquina de estados, sinal de tick e sequência transmitida, utilizando os diversos sinais de debug.


Prática em bancada: monitorar a saída no osciloscópio e no analisador de protocolos. Sinais de depuração internos serão usados para confirmar estados e transições.


6. Projeto do Desafio da Experiência

Nesta etapa, foi proposta uma modificação no circuito de transmissão serial assíncrona desenvolvido previamente. O objetivo do desafio foi analisar a arquitetura original, identificar os blocos que deveriam ser alterados e implementar a nova versão no Quartus Prime para posterior síntese na placa FPGA DE0-CV.

Estudo da modificação

Após análise do projeto base, verificamos que a alteração proposta impactava diretamente tanto o fluxo de dados quanto a unidade de controle. Foi necessário compreender o funcionamento atual da máquina de estados e revisar a lógica de geração e deslocamento dos bits, de modo a garantir que a modificação fosse incorporada sem comprometer as demais funcionalidades do transmissor.

Implementação e síntese

A modificação foi implementada no Intel Quartus Prime, resultando em ajustes nos módulos Verilog correspondentes. Em seguida, o circuito foi sintetizado com sucesso na placa DE0-CV. Durante a síntese, após erros de análise e código, documentamos a designação de pinos, mantendo a estrutura base já utilizada no planejamento e realizando apenas as adaptações necessárias para os novos sinais introduzidos pela modificação.

Montagem e testes experimentais

Com o projeto carregado na FPGA, foram feitas modificações também na montagem física do circuito, conectando os novos sinais às entradas e saídas disponíveis na placa. Os testes experimentais foram conduzidos utilizando o Analog Discovery, possibilitando a observação detalhada das formas de onda e da sequência transmitida.
Os resultados mostraram que o circuito funcionou conforme esperado, validando a modificação implementada. Foram coletadas imagens das formas de onda e analisados parâmetros como largura de bit, taxa de transmissão e sequência de bits transmitidos, confirmando a aderência ao padrão de comunicação estabelecido.

O teste acima representa a o processo de transmissão da entrada das letras do teclado para a placa FPGA e da placa FPGA para o monitor.

Testes experimentais

Testar a transmissão com caracteres diferentes para confirmar se o padrão foi seguido.


Medir a largura de bit no osciloscópio e verificar se condiz com a taxa configurada.


Usar o Protocol Analyzer para confirmar se o protocolo RS-232C está de acordo.


Documentar com capturas de tela do Analog Discovery mostrando os resultados.

No teste acima, está representado o processo de transmissão de dados da placa FPGA para o computador, porém nesse caso os inputs vinham diretamente da placa FPGA.

7. Conclusões (Relato)

O planejamento realizado até aqui mostra que as modificações do projeto base para a configuração 7E1 a 115200 bauds são viáveis e bem estruturadas. Espera-se que as simulações confirmem a correção do circuito e que a implementação prática demonstre conformidade com o protocolo RS-232C.

Com esse experimento, além de reforçar o entendimento da transmissão serial, será possível aplicar de forma prática conceitos de projeto de FSM, fluxo de dados e depuração em FPGA.
















## Diagramas e reprodução desta edição

Consulte os [diagramas explicativos](../DIAGRAMAS.md), os [objetivos pedagógicos](../OBJETIVOS_PEDAGOGICOS.md) e a [validação](../VALIDACAO.md). As figuras originais não foram republicadas. Os novos diagramas e os testes acompanham as implementações organizadas.

## Autoria e créditos

Luigi Scofano de Araujo · USP 13680334.

Créditos de participação constantes do material de origem: Lucas Lacerda, Paulo Henrique Mota de Oliveira.

## Reprodução e figuras desta edição

[Diagramas explicativos](../DIAGRAMAS.md) · [Validação](../VALIDACAO.md) · [Objetivos pedagógicos](../OBJETIVOS_PEDAGOGICOS.md).
