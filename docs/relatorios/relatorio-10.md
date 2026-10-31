# PCS3645-T5BA6-SEMANA 4


Versão revisada para consulta pública. A disposição gráfica foi substituída por texto, tabelas e diagramas novos. Dados pessoais de terceiros e referências privadas foram retirados. Os créditos foram preservados.


1. Introdução

	Durante a semana, foi refinado a forma do funcionamento do jogo com base nas possíveis maneiras de comunicação com crianças que apresentem TEA, tomando cuidado com, por exemplo, a possível hipersensibilidade com a cor vermelha, ou cores do espectro. Com isso em mente, chegamos no consenso de trabalhar com duas formas de comunicações principais: um semáforo, que indica, com cores coloridas e suas posições, quando a criança pode avançar em direção ao guardião; e o próprio guardião em si, que teria um aspecto de olhar ou não para criança, indicando quando o movimento seria dedicado e quando não o seria.

	Assim, para essa semana, focaremos em avançar no projeto lógico, além das especificações técnicas, pensando em eleger os componentes a serem usados e comprados.

Dois problemas em mente que precisaremos pensar de antemão são os seguintes:

Qual será a forma que o guardião será montado? O servo motor deverá aguentar sua estrutura;

Como capturaremos os dados sobre o movimento da criança? Um sensor de distância nos dará dados mais precisos sobre a velocidade e posição, mas será mais difícil de trabalhar com a lógica, enquanto um sensor de movimento deve ser mais simples, porém não indica os dados em questão, além de poder identificar falsos positivos mais facilmente.

2. Descrição do Projeto

	Em respeito aos dados de movimento, foi eleito o sensor HC-SR04 como a forma mais prática e completa de conseguir suas informações. Para enfrentar a imprecisão numérica, tiraremos diversas medidas por vez e faremos o devido tratamento.

	Em respeito aos componentes, planejaremos usar:

	 -HC-SR04; projeto deve ter um módulo exclusivo que funciona de forma a testá-lo e ser usado no projeto final. Esse módulo deve ter um sinal ativado para disparar um número de medidas, da onde será tirado a distância.

FD e UC do medidor_distancia (Fonte: miro do grupo)

A concatenação do conversor de bcd para binário, passando pelo módulo de média e em seguida para o conversor de binário para bcd foi chamado de media_bcd e teve seu funcionamento validado com simulação 

Nota-se que toda subida de clock a saída é ajustada para a divisão dos números somados por 4, cortando os decimais.

A interface_hcsr04 tem a seguinte unidade de controle:


	Como faremos diversas medidas, é possível que algumas falhem, gerando algum tipo de time out. Nesse caso, é necessário implementar uma fuga do estado de espera_echo para o estado de envia_trigger, tentando novamente a realização da medição. Para isso também será necessário incluir um contador com esse caráter no fluxo de dados. Isso pode ser feito ou na interface_hcrs04, como sugerido acima, ou então no módulo medidor_distancia.

	Com o sinal pronto, emitido no estado final_medida, seremos capazes de implementar as 4 medidas subsequentes no estado total.

- Servo motor; seu módulo deve ter apenas três opções de operação: olhando, não olhando e de lado(indicando que o jogo não está ativo). Poderemos usar apenas um encapsulamento do componente já existente que permite apenas as três larguras em questão.

	- Transmissão serial; devemos definir como a informação será transmitida e deve haver um módulo que recebe todas as informações e ao receber um sinal, realiza a transmissão da forma como foi planejado

Informações a serem transmitidas:

Posição: 3 dígitos, representando quantidade em centímetros da distância ao sensor;

Variação da posição desde a última medida: 3 dígitos, representando quantidade em centímetros;

Velocidade medida de aproximação: 2 dígitos, representando velocidade em centímetros por segundo;

Semáforo sinal que controla a interface que representa o semáforo. Semaforo = 0: Vermelho; Semaforo = 1: Verde;

Formato:

posição,variação,velocidade,semaforo#

Quando jogando

	O computador deve receber esses dados, mostrar a posição do jogador de forma gráfica, além de exibir os valores dessa rodada em uma tabela. A se pensar na necessidade de exportar para posterior análise de um profissional.

Servo Motor:

Podemos testar o servo com controlador_servo. As entradas e saídas são:

| Sinal | Pinagem | Descrição |
| --- | --- | --- |
| clock | M9 | Clock 50MHz |
| olha_frente | U13 | SW0 |
| pwm | K16 | GPIO_1_D35 |
| db_olha | AA2 | LED0 |
| db_largura | U1, L2, L1 | LED7,8,9 |

Guardião

Interface Gráfica E Transmissão:

Revisão dos valores a serem enviados:

Momento: m (E - inicio movimento: ignorar outras informações; O - fim movimento onde passam as métricas)

Posição(cm): ppp (3 caracteres ASCII com o valor da posição)

Variação vermelha(cm): quanto variou enquanto o sinal estava vermelho - vvv (3 caracteres ASCII com o valor da variação)

Final: f(G - ganhou, P - perdeu, J - jogando)

m,ppp,vvv,f#

estado_semaforo {0 = verde/E; 1 = vermelho/O}

case (final)

2'b00: caractere_ascii = 7'h4A; // J

2'b01: caractere_ascii = 7'h47; // G

2'b10: caractere_ascii = 7'h50; // P

2'b11: caractere_ascii = 7'h7E; // ~

Caso de perdeu:

,000#

Sobre a transmissão:

A variação que será enviada é uma informação relevante para entender a variação que a criança foi capaz de andar. Caso negativa, também é uma informação relevante. Por isso, será importante que a variação enviada via transmissão serial, seja não apenas os 3 dígitos em centímetros do valor absoluto, como também um adicional que determina o sinal.

Também há de se considerar retirar a informação da velocidade.

Sobre a diferença: existe a diferença durante o momento parado e a diferença em relação ao último momento. É importante distinguir esses valores. Na aula do dia 17/11, determinamos que a diferença entre valores durante o sinal vermelho vai ser chamada de variação vermelha, já a variação durante o sinal verde será variação verde.

Módulo para identificar outlier e erros na medida:

Módulo media_bin que pega a média dos números que recebe

| Sinal | Pinagem | Desc |
| --- | --- | --- |
| clock | M9 |  |
| echo | T15 | GPIO_0_D35 |
| hex_db_estado[0] / hex_db_estado[1] / hex_db_estado[2] / hex_db_estado[3] / hex_db_estado[4] / hex_db_estado[5] / hex_db_estado[6] |  | HEX0 |
| iniciar |  |  |
| luz_verde | J18 | GPIO_1_D11 |
| luz_vermelha | G11 | GPIO_1_D13 |
| pwm | K16 | GPIO_1_D35 |
| reset |  |  |
| saida_serial | B16 | GPIO_0_D1 |
| sensibilidade_luz |  |  |
| trigger | T18 | GPIO_0_D33 |
| perdeu | D13 | GPIO_1_D7 |
| ganhou | G17 | GPIO_1_D9 |
















## Diagramas e reprodução desta edição

Consulte os [diagramas explicativos](../DIAGRAMAS.md), os [objetivos pedagógicos](../OBJETIVOS_PEDAGOGICOS.md) e a [validação](../VALIDACAO.md). As figuras originais não foram republicadas. Os novos diagramas e os testes acompanham as implementações organizadas.

## Autoria e créditos

Luigi Scofano de Araujo · USP 13680334.

Créditos de participação constantes do material de origem: Lucas Lacerda, Paulo Henrique Mota de Oliveira.

## Reprodução e figuras desta edição

[Diagramas explicativos](../DIAGRAMAS.md) · [Validação](../VALIDACAO.md) · [Objetivos pedagógicos](../OBJETIVOS_PEDAGOGICOS.md).
