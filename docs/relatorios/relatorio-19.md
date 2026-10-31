# PCS3635-T2BA6-planejamento2.pdf


Versão revisada para consulta pública. A disposição gráfica foi substituída por texto, tabelas e diagramas novos. Dados pessoais de terceiros e referências privadas foram retirados. Os créditos foram preservados.


1                Introdução

O objetivo desta experiência é desenvolver e analisar um fluxo de dados simples em Verilog, utilizando componentes digitais pré-definidos, como contador binário hexadecimal e comparador de magnitude. A experiência também busca consolidar o uso de ferramentas como o software Digital e o Intel Quartus Prime para simulação, síntese e testes práticos em uma FPGA DE0-CV. O resultado esperado é a validação do funcionamento do circuito e a integração dos conhecimentos adquiridos ao longo da disciplina.

 —-------------------------------------------------------------------------------------------------------------

2                Descrição do Projeto

O projeto consiste na integração de dois módulos principais: o contador binário hexadecimal e o comparador de magnitude de 4 bits. Ambos os componentes serão conectados conforme o diagrama de blocos fornecido, respeitando os requisitos de entrada e saída. O circuito inclui:

Contador Binário Hexadecimal: Incrementa o valor em cada pulso de clock, com suporte para reset e carga de valores específicos.

Comparador de Magnitude: Compara dois valores de 4 bits e determina a relação (maior, menor ou igual).

Além disso, o projeto utiliza sinais de controle ativos em nível alto e saídas de depuração para facilitar a análise do comportamento do circuito durante as simulações e testes práticos.

Descrição de Fluxograma do Funcionamento

O fluxograma abaixo descreve o comportamento geral do circuito:

1.     Inicializar o sistema e configurar as entradas iniciais.

2.     Resetar o contador caso o sinal de reset esteja ativo.

3.     Incrementar o contador a cada pulso de clock, caso o sinal de enable esteja ativo.

4.     Realizar a comparação entre o valor do contador e a entrada ajustada pelas chaves.

5.     Indicar o resultado da comparação: maior, menor ou igual.

  —-------------------------------------------------------------------------------------------------------------

3                Detalhamento do Projeto Lógico

3.1           Projeto do Fluxo de Dados

O fluxo de dados conecta o contador e o comparador, utilizando sinais de controle como reset, enable e load para gerenciar o comportamento do circuito. A saída do contador serve como uma das entradas para o comparador, enquanto a outra entrada é fornecida por chaves ajustáveis na FPGA. O design será implementado em Verilog com descrição estrutural, garantindo modularidade e reutilização dos componentes.

O fluxo de dados do sistema é composto por dois módulos principais: o contador binário hexadecimal e o comparador de magnitude de 4 bits. O contador realiza a contagem sequencial de valores com base no sinal de clock e nas condições impostas pelos sinais de controle. A saída do contador é utilizada como entrada para o comparador, que determina a relação entre o valor do contador e o valor configurado pelas chaves.

Descrição do Fluxo de Dados

Contador:

Recebe sinais de controle (CLR, LD, ENT, CLK) para realizar funções como reset, carga de valor específico e incremento.

A saída Q representa o valor atual do contador em 4 bits, que é encaminhado para o comparador.

Comparador:

Recebe duas entradas: o valor do contador (Q) e o valor definido pelas chaves.

Determina a relação entre os valores (A>B, A=B, A<B) e ativa as saídas correspondentes. 

3.3           Projeto do Sistema Digital

O sistema digital assegura o funcionamento correto do contador e do comparador com base nos sinais de controle e condições estabelecidas.

Descrição da Integração

Integração do Contador e Comparador:

O contador recebe os sinais de controle (CLR, LD, ENT, CLK) para executar as operações de reset, carga e incremento.

A saída do contador (Q) é conectada à entrada A do comparador, enquanto a entrada B é definida pelas chaves (CHAVES).

Sinais de Depuração:

db_contagem (LEDR0-LEDR3): Mostra o valor atual do contador em LEDs.

Fim (LEDR9): Indica quando o contador atingiu seu valor máximo.

A>B, A=B, A<B (LEDR5-LEDR7): Exibem o resultado da comparação.

Descrição dos Sinais

Os sinais principais para o funcionamento do sistema são descritos na tabela abaixo:

| Sinal | Descrição | Tipo |
| --- | --- | --- |
| CLOCK | Pulso de clock para o funcionamento sequencial do contador | Entrada |
| RESET | Reinicia o contador para o estado inicial | Entrada |
| ENABLE | Habilita a contagem do contador | Entrada |
| LOAD | Carrega um valor específico no contador | Entrada |
| CHAVES | Define o valor de entrada para o comparador | Entrada |
| OUTPUT | Mostra o valor atual do contador | Saída |
| MAIOR, MENOR, IGUAL | Indica o resultado da comparação (contador vs entrada ajustada) | Saída |

Integração do Sistema

O sistema integra os componentes principais de forma hierárquica:

Fluxo de Dados:

O contador recebe os sinais de CLOCK, RESET, ENABLE e LOAD para realizar sua contagem.

A saída do contador (OUTPUT) é conectada a uma entrada do comparador.

As chaves fornecem a segunda entrada do comparador (CHAVES).

Interface de Monitoramento:

As saídas do comparador (MAIOR, MENOR, IGUAL) e do contador (OUTPUT) são conectadas aos LEDs da FPGA, permitindo a visualização dos resultados.

Saídas de Depuração e Monitoramento:

O valor do contador (Q) é exibido nos LEDs LEDR0 a LEDR3.

Os resultados da comparação são exibidos nos LEDs LEDR5 a LEDR7.

Quando o contador atinge seu valor máximo, o LEDR9 é ativado.

  —-------------------------------------------------------------------------------------------------------------

4                Plano de Testes do Sistema e Simulações

Este capítulo tem o objetivo de documentar a estratégia dos testes do sistema desenvolvido e documentado no capítulo 3 e apresentar os resultados das respectivas simulações realizadas.

Sugestão: descrever cada cenário de teste em uma subseção seguindo o modelo fornecido.

4.1           Cenário de Teste 1 – contador 163

Tabela de testes para garantir o comportamento correto do contador 163

4.2           Cenário de Teste 2 – comparador 85

Descrever cenário em até dois parágrafos e detalhar as características técnicas em uma tabela com a seguinte estrutura.

Tabela 3 – Descrição e Resultados Simulados do Cenário de Teste 2

| Etapa | ALBi | AGBi | AEBi | A | B | ALBo | AGBo | AEBo |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 0 |  0 |  0 |  1 |  0000 | 0000 | 0 | 0 | 1 |
| 1 |  0 |  0 |  1 |  0110 | 0110 | 0 | 0 | 1 |
| 2 | 0 | 1 |  0 |  0110 | 0110 | 0 | 1 | 0 |
| 3 |  1 |  0 |  0 |  0110 | 0110 | 1 | 0 | 0 |
| 4 |  0 |  0 |  1 |  0001 | 0000 | 0 | 1 | 0 |
| 5 |  0 |  1 |  0 |  0001 | 0000 | 0 | 1 | 0 |
| 6 |  1 |  0 |  0 |  0001 | 0000 | 0 | 1 | 0 |
| 7 | 0 | 0 | 1 | 0011 | 1100 | 1 | 0 | 0 |
| 8 | 0 | 1 | 0 | 0011 | 1100 | 1 | 0 | 0 |
| 9 | 0 | 0 | 1 | 0011 | 1100 | 1 | 0 | 0 |

 —-------------------------------------------------------------------------------------------------------------

5                Implantação do Projeto

Este capítulo tem o objetivo de documentar as atividades práticas de execução do projeto desenvolvido e documentado no capítulo 3 no ambiente do Laboratório Digital.

5.1           Pinagem da Placa FPGA

Foi seguida a “Tabela 5: Designação de Pinos para o Circuito Digital da Atividade 3” e realizada a pinagem no Quartus como mostra a imagem.

5.2           Estratégia de Montagem

Descrever o passo-a-passo para realizar a montagem experimental. Por exemplo:

	Para realizar a programação da placa FPGA, foi utilizado o software Quartus. Foi colocado os módulos em verilog: o contador, o comparador e o top level “circuito_exp2_ativ2”. Em seguida, após sua compilação, foi averiguado sua consistência no RTL viewer. Finalmente, as ligações de terminais foram feitas com a designação de pinos seguindo a tabela 5. Assim, as configurações estavam prontas para serem exportadas para a FPGA, visto que as fiações e terminais necessários já estão configurados pela empresa que faz a placa.

	Uma vez isso feito, foi possível analisar o funcionamento da placa fisicamente usando os botões e chaves para manuseio, e LEDs para controle do funcionamento. Os sinais de depuração considerados são as análises da saída do contador(LEDs R0 a R3 e R9), além dos indicadores de comparação(R5 a R7). 

5.3           Estratégia de Depuração

Para realizar a depuração do projeto, foram realizados diversos testes iniciais para garantir o funcionamento básico do contador e do comparador. Após isso, foi realizada uma bateria de testes propostos na “Tabela 4: Plano de Testes para o Circuito Digital da Atividade 2”, comprovando a eficiência do projeto.

| # | Resultado esperado | Resultado observado |
| --- | --- | --- |
| c.i. | contagem=0, fim=0, maior=0, menor=0, igual=1 | contagem=0, fim=0, maior=0, menor=0, igual=1 |
| 1 | contagem=0, fim=0, maior=0, menor=0, igual=1 | contagem=0, fim=0, maior=0, menor=0, igual=1 |
| 2 | contagem=0, fim=0, maior=0, menor=1, igual=0 | contagem=0, fim=0, maior=0, menor=1, igual=0 |
| 3 | contagem=1, fim=0, maior=0, menor=0, igual=1 | contagem=1, fim=0, maior=0, menor=0, igual=1 |
| 4 | contagem=3, fim=0, maior=1, menor=0, igual=0  | contagem=3, fim=0, maior=1, menor=0, igual=0 |
| 5 | contagem=3, fim=0, maior=0, menor=1, igual=0 | contagem=3, fim=0, maior=0, menor=1, igual=0 |
| 6 | contagem=14, fim=0, maior=1, menor=0, igual=0 | contagem=14, fim=0, maior=1, menor=0, igual=0 |
| 7 | contagem=15, fim=1, maior=1, menor=0, igual=0 | contagem=15, fim=1, maior=1, menor=0, igual=0 |

Portanto, o teste indica que o projeto foi realizado da maneira correta, haja vista que todos os testes obtiveram o resultado esperado na primeira tentativa. A depuração ocorreu apenas na etapa do Quartus, para conseguir realizar a depuração.

OBS: No teste número 1 é pedido para ligar o zera, porém a partir de então o zera foi desativado.

5.4           Execução Prática do Cenário de Teste 1 – <Objetivo Sucinto do Cenário>

Os resultados observados nos testes estão apresentados na tabela 4, no tópico acima. Não foram encontradas anomalias.

 —-------------------------------------------------------------------------------------------------------------

6                Projeto do Desafio da Experiência

No planejamento, incluir esta seção e as suas subseções, mas descrever que serão documentadas durante a aula.

6.1           Descrição do Desafio

	Colocar no display os valores da contagem e das chaves.

6.2           Descrição do Projeto Lógico

Ao código verilog da atividade anterior, foi adicionado o módulo heg7seg duas vezes. O primeiro utilizou o fio s_contagem, que guardava o valor da contagem, e o segundo utilizou o input chaves, que guardava o valor das chaves. A partir disso, gerou-se duas novas saídas adequadas para serem interpretadas pelo display.

Com as novas saídas, foi adicionado na pinagem a localização correspondente do display encontrada na tabela do material de apoio. Com um processo análogo ao que foi feito na atividade anterior, o projeto foi compilado e passado a FPGA sem problemas.

6.3           Verificação e Validação do Desafio

Para testar o novo projeto, foram realizados os mesmos testes que anteriormente na tabela 4, validando o desafio.

6.3.1     Cenário de Teste 1

| # | Resultado esperado | Resultado observado |
| --- | --- | --- |
| c.i. | contagem=0, fim=0, maior=0, menor=0, igual=1 | contagem=0, fim=0, maior=0, menor=0, igual=1 |
| 1 | contagem=0, fim=0, maior=0, menor=0, igual=1 | contagem=0, fim=0, maior=0, menor=0, igual=1 |
| 2 | contagem=0, fim=0, maior=0, menor=1, igual=0 | contagem=0, fim=0, maior=0, menor=1, igual=0 |
| 3 | contagem=1, fim=0, maior=0, menor=0, igual=1 | contagem=1, fim=0, maior=0, menor=0, igual=1 |
| 4 | contagem=3, fim=0, maior=1, menor=0, igual=0  | contagem=3, fim=0, maior=1, menor=0, igual=0 |
| 5 | contagem=3, fim=0, maior=0, menor=1, igual=0 | contagem=3, fim=0, maior=0, menor=1, igual=0 |
| 6 | contagem=14, fim=0, maior=1, menor=0, igual=0 | contagem=14, fim=0, maior=1, menor=0, igual=0 |
| 7 | contagem=15, fim=1, maior=1, menor=0, igual=0 | contagem=15, fim=1, maior=1, menor=0, igual=0 |

 —-------------------------------------------------------------------------------------------------------------

7                Conclusões

Este planejamento fornece uma visão detalhada do desenvolvimento do projeto lógico, simulações e implantação prática na FPGA. Através das etapas descritas, será possível validar o funcionamento correto do circuito proposto, garantindo que os objetivos da experiência sejam alcançados. Durante a execução, ajustes poderão ser realizados conforme necessário para resolver eventuais problemas identificados.












## Diagramas e reprodução desta edição

Consulte os [diagramas explicativos](../DIAGRAMAS.md), os [objetivos pedagógicos](../OBJETIVOS_PEDAGOGICOS.md) e a [validação](../VALIDACAO.md). As figuras originais não foram republicadas. Os novos diagramas e os testes acompanham as implementações organizadas.

## Autoria e créditos

Luigi Scofano de Araujo · USP 13680334.

Créditos de participação constantes do material de origem: Lucas Lacerda, Paulo Henrique Mota de Oliveira.

## Reprodução e figuras desta edição

[Diagramas explicativos](../DIAGRAMAS.md) · [Validação](../VALIDACAO.md) · [Objetivos pedagógicos](../OBJETIVOS_PEDAGOGICOS.md).
