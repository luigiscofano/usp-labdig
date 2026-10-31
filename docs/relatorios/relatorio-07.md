# PCS3645-T5BA6-FINAL


Versão revisada para consulta pública. A disposição gráfica foi substituída por texto, tabelas e diagramas novos. Dados pessoais de terceiros e referências privadas foram retirados. Os créditos foram preservados.


1. Introdução

	Durante a semana, foi refinado a forma do funcionamento do jogo com base nas possíveis maneiras de comunicação com crianças que apresentem TEA, tomando cuidado com, por exemplo, a possível hipersensibilidade com a cor vermelha, ou cores do espectro. Com isso em mente, chegamos no consenso de trabalhar com duas formas de comunicações principais: um semáforo, que indica, com cores coloridas e suas posições, quando a criança pode avançar em direção ao guardião; e o próprio guardião em si, que teria um aspecto de olhar ou não para criança, indicando quando o movimento seria dedicado e quando não o seria.

	Assim, para essa semana, focaremos em avançar no projeto lógico, além das especificações técnicas, pensando em eleger os componentes a serem usados e comprados.

Dois problemas em mente que precisaremos pensar de antemão são os seguintes:

Qual será a forma que o guardião será montado? O servo motor deverá aguentar sua estrutura;

Como capturaremos os dados sobre o movimento da criança? Um sensor de distância nos dará dados mais precisos sobre a velocidade e posição, mas será mais difícil de trabalhar com a lógica, enquanto um sensor de movimento deve ser mais simples, porém não indica os dados em questão, além de poder identificar falsos positivos mais facilmente.

1.2 Detalhamento técnico

O problema central da semana é uma decisão de arquitetura do sistema: escolher (i) o meio de percepção do movimento do jogador (sensor), (ii) o meio de atuação do “guardião” (servo), e (iii) o protocolo e o caminho de telemetria (transmissão serial + interface no computador). O projeto tem restrições específicas: operação em tempo real, robustez a ruído de medição, e design de interação adequado ao público-alvo (crianças com TEA), o que exige sinais simples, repetíveis e previsíveis (semáforo e “olhar do guardião”), evitando estímulos potencialmente desconfortáveis.

Do ponto de vista de Sistemas Digitais, isso se traduz em:

Uma máquina de estados para governar o jogo (espera, mede, avalia, sinaliza, finaliza).


Um sub-sistema de aquisição com temporização rigorosa (HC-SR04 exige pulsos e medição de tempo de eco).


Um sub-sistema de filtragem/validação (múltiplas medidas + média + tratamento de falhas/timeouts).


Um sub-sistema de atuação (PWM para servo com poucos estados discretos).


Um sub-sistema de comunicação (serial com formatação ASCII, sincronização por delimitador e suporte a logging externo).


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

		2.2 Arquitetura funcional proposta

A especificação do relatório original indica uma decomposição clássica em Fluxo de Dados (FD) e Unidade de Controle (UC) para os módulos principais. O objetivo é garantir que cada bloco tenha: entradas/saídas bem definidas, temporização conhecida e comportamento determinístico.

2.2.1 Aquisição de distância (HC-SR04) e robustez

O HC-SR04 mede distância via tempo de voo ultrassônico:

O sistema gera um pulso de trigger (típico ≥ 10 µs).


O sensor responde com echo em nível alto por um tempo proporcional à distância.


A lógica digital mede a largura do pulso de echo (contador clockado), convertendo em tempo e depois em distância.


O relatório original já prevê o problema-chave: falhas de leitura (echo não chega, ruído, saturação), exigindo timeout e retentativas. A recomendação é uma UC com fuga do estado de espera de echo para um novo disparo (envia_trigger) após tempo limite, usando um contador dedicado. Isso evita deadlock da FSM e permite operação contínua.

2.2.2 Medição múltipla + média (media_bcd / media_bin)

Para reduzir imprecisão numérica, o projeto planeja tirar diversas medidas por rodada e aplicar um tratamento estatístico (média). O relatório descreve explicitamente a cadeia: conversor BCD→binário, módulo de média, e binário→BCD (media_bcd), validado via simulação, com atualização a cada subida de clock e divisão por 4 (para 4 amostras), descartando decimais.

Do ponto de vista digital:

Somador acumulador para N amostras.


Contador de amostras para determinar quando acumulou N leituras válidas.


Divisão por potência de 2 (N=4) pode ser implementada por deslocamento (shift), simplificando hardware, coerente com “cortando os decimais”.


Além disso, como o relatório menciona “módulo para identificar outlier e erros na medida” e um “media_bin” (média em binário), a evolução natural é:

Rejeitar leituras fora de faixa física (ex.: > 400 cm, < 0 cm).


Rejeitar leituras com tempo de echo incompatível.


Opcionalmente, usar mediana/trimmed mean; porém a proposta atual mantém média simples por custo baixo.


2.2.3 Servo motor como atuador discreto (3 posições)

O servo é modelado como um atuador com apenas três estados discretos: olhando (frente), não olhando (trás) e lateral (jogo inativo). Isso reduz a complexidade: ao invés de controlar ângulo contínuo, a UC do jogo seleciona entre três larguras de pulso PWM predefinidas.

Implementação típica:

Um bloco de PWM com período fixo (ex.: 20 ms).


Um multiplexador selecionando a largura do pulso (duty em tempo absoluto) conforme estado do jogo.


Sinais de debug (LEDs/HEX) para validar seleção, conforme tabela de pinagem mencionada no relatório
 PCS3645-T5BA6-SEMANA 4
.


2.2.4 Transmissão serial e protocolo ASCII

O relatório define duas versões de protocolo:

Uma versão “posição,variação,velocidade,semaforo#” para o caso “jogando”
 PCS3645-T5BA6-SEMANA 4
.


Uma versão mais refinada com momento e final: “m,ppp,vvv,f#”, onde:


m ∈ {E, O} indica início (verde) e fim (vermelho) do movimento.


ppp são 3 caracteres ASCII da posição.


vvv são 3 caracteres ASCII da variação vermelha.


f ∈ {G, P, J} indica ganhou/perdeu/jogando
 PCS3645-T5BA6-SEMANA 4
.


Há também um requisito importante: a variação pode ser negativa, e o relatório recomenda transmitir não só o valor absoluto mas também um indicativo de sinal. Isso impacta diretamente o parser do lado do PC (deve aceitar “-15” ou campo adicional para sinal).

3. Interface Gráfica E Transmissão:

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

4. Código-fonte completo (Processing) – Guardião do Paredão (4 m)

//-------------------------- Guardião do Paredão (4 m) --------------------------

// V0 - versão com gráficos + MODO PLANILHA (CSV para Excel) + tecla J (Jogar/reset)

import processing.serial.*;

import java.util.*;

import java.text.*;   // para timestamp no nome do arquivo

// Se true, usa simulação. Se false, lê da porta serial.

boolean usarSimulacao = true;

// =================== SERIAL ===================

Serial myPort;

String porta    = "COM7";

int    baudrate = 115200;

char   parity   = 'E';

int    databits = 7;

float  stopbits = 1.0;

// =================== DADOS DO JOGO ===================

int posicaoCm     = 400;  // distância ao sensor

int variacaoCm    = 0;    // variação ACUMULADA enquanto o sinal está vermelho (cm)

int velocidadeCms = 0;    // cm/s (usado na simulação)

boolean temDados  = false;

final int DIST_MAX = 400;

final int DIST_MIN = 0;

// semáforo: 0 = vermelho (pare), 1 = verde (anda)

int semaforo = 1;

// estados do jogo

final int JOGANDO = 0;

final int VENCEU  = 1;

final int PERDEU  = 2;

int estadoJogo = JOGANDO;

// campos do protocolo

char momento = 'O';   // 'E' = começar movimento (verde), 'O' = parar (vermelho)

char flagFinal = 'J'; // 'G' = ganhou, 'P' = perdeu, 'J' = jogando

// === modos de simulação ===

// 0 = normal (anda/para com semáforo alternando)

// 1 = roteiro de vitória (vence sempre)

// 2 = roteiro de derrota (perde no vermelho)

int modoSimulacao = 0;

// controle da simulação

int etapaTeste  = 0; 

int frameEtapa  = 0;

int contadorSemaforo = 0;

// fonte

PFont fonte;

// histórico texto

ArrayList<String> historico = new ArrayList<String>();

final int MAX_LINHAS = 5;

// histórico gráfico

ArrayList<Float> histPos = new ArrayList<Float>();

ArrayList<Float> histVar = new ArrayList<Float>();

// CORES

final int COR_VERDE_ESCURO = color(10, 70, 25);

final int COR_VERDE_CAMPO  = color(60, 180, 90);

final int COR_VERMELHO     = color(230, 60, 60);

// =================== MODO PLANILHA (CSV) ===================

boolean modoPlanilha = false;   // tecla 'X' liga/desliga logging contínuo

PrintWriter csv = null;         // writer do CSV de logging contínuo

String csvPath = "";            // caminho do arquivo CSV atual

int amostraSeq = 0;             // contador sequencial das amostras logadas

void setup() {

  size(960, 600);

  smooth();

  fonte = createFont("Comic Sans MS", 18);

  textFont(fonte);

  if (!usarSimulacao) {

    myPort = new Serial(this, porta, baudrate, parity, databits, stopbits);

    myPort.bufferUntil('#');

  }

  resetJogoParaSimulacao();

}

void draw() {

  desenharCeu();

  desenharTitulo();

  desenharSemaforo();

  if (usarSimulacao) {

    gerarSimulacao();

  }

  desenharChao();

  desenharInicio();

  desenharArvores();

  desenharSol();

  desenharGuardiao();

  desenharJogador();

  desenharPainel();

  desenharHistorico();

}

void dispose() {

  fecharPlanilha(); // garante fechamento do arquivo ao encerrar o sketch

}

// ================== RESET PARA CADA CENÁRIO ==================

void resetJogoParaSimulacao() {

  posicaoCm = DIST_MAX;

  variacaoCm = 0;

  velocidadeCms = 0;

  semaforo = 1;

  estadoJogo = JOGANDO;

  etapaTeste = 0;

  frameEtapa = 0;

  contadorSemaforo = 0;

  temDados = false;

  momento = 'O';

  flagFinal = 'J';

  historico.clear();

  histPos.clear();

  histVar.clear();

  amostraSeq = 0;

}

void keyPressed() {

  if (key == '0') {

    modoSimulacao = 0;

    resetJogoParaSimulacao();

  } else if (key == '1') {

    modoSimulacao = 1;

    resetJogoParaSimulacao();

  } else if (key == '2') {

    modoSimulacao = 2;

    resetJogoParaSimulacao();

  } else if (key == 'X' || key == 'x') {

    // liga/desliga logging contínuo

    if (!modoPlanilha) abrirPlanilha();

    else fecharPlanilha();

    modoPlanilha = !modoPlanilha;

  } else if (key == 'S' || key == 's') {

    // snapshot imediato do histórico atual em CSV independente do modoPlanilha

    salvarSnapshotHistorico();

  } else if (key == 'J' || key == 'j') {

    novoJogo(); // reset rápido

  }

}

// Reinicia animação e dados; se estiver logando, grava separador no CSV

void novoJogo() {

  if (modoPlanilha && csv != null) {

    long t = millis();

    csv.println("# -------- NOVO_JOGO -------- " + t + " ms");

    csv.flush();

  }

  resetJogoParaSimulacao();

}

// -----------------------------------------------------------------------------

//                               DESENHO VISUAL

// -----------------------------------------------------------------------------

void desenharCeu() {

  background(135, 206, 235);

}

void desenharTitulo() {

  fill(255);

  textAlign(LEFT, BASELINE);

  textSize(28);

  text("Guardião do Paredão", 20, 50);

  textSize(16);

  text("(alcance o guardião sem ser pego!)", 22, 72);

  text("Distância máxima: 4,00 m (400 cm)", 22, 94);

  // indicador do modo planilha + atalhos

  textSize(14);

  fill(modoPlanilha ? color(0,200,0) : color(255));

  String status = modoPlanilha ? "MODO PLANILHA: LIGADO" : "MODO PLANILHA: DESLIGADO";

  text(status, 22, 114);

  fill(255);

  text("Snapshot: S | Planilha: X | Jogar (reset): J", 22, 132);

}

void desenharSemaforo() {

  pushStyle();

  float cxRed = width/2 - 80;

  float cxGreen = width/2 + 80;

  float cy = 105;

  float r = 50;

  rectMode(CENTER);

  noStroke();

  fill(0);

  rect((cxRed + cxGreen)/2, cy - 15, 340, 100, 30);

  stroke(0);

  strokeWeight(4);

  // vermelho (mais vivo quando ativo)

  fill(semaforo == 0 ? color(255,70,70) : color(120,40,40));

  ellipse(cxRed, cy, r, r);

  // verde (mais vivo quando ativo)

  fill(semaforo == 1 ? color(70,220,90) : color(40,80,40));

  ellipse(cxGreen, cy, r, r);

  fill(255);

  textAlign(CENTER, CENTER);

  textSize(20);

  text("PARE", cxRed, cy - r);

  text("ANDA", cxGreen, cy - r);

  popStyle();

}

void desenharSol() {

  noStroke();

  fill(255, 236, 120);

  ellipse(width - 90, 80, 80, 80);

}

void desenharChao() {

  stroke(0, 80, 0);

  strokeWeight(3);

  line(0, 240, width, 240);

  noStroke();

  fill(COR_VERDE_ESCURO);

  rect(0, 240, width, height - 240);

}

void desenharArvores() {

  noStroke();

  for (int x = 250; x <= 750; x += 120) {

    fill(80, 50, 20);

    rect(x, 200, 15, 60);

    fill(40, 140, 60);

    ellipse(x - 5, 195, 55, 55);

    ellipse(x + 15, 205, 50, 50);

    ellipse(x + 5, 175, 45, 45);

  }

}

void desenharInicio() {

  stroke(COR_VERMELHO);

  strokeWeight(6);

  line(120, 210, 120, 240);

  fill(COR_VERMELHO);

  textAlign(CENTER, CENTER);

  textSize(24);

  text("INÍCIO", 120, 180);

  textAlign(LEFT, BASELINE);

}

void desenharGuardiao() {

  float yChao = 240;          // mesma linha do chão do jogador

  pushMatrix();

  pushStyle();

  translate(830, yChao);

  textAlign(CENTER, CENTER);

  textSize(20);

  fill(COR_VERDE_CAMPO);

  rectMode(CENTER);

  stroke(0);

  strokeWeight(2);

  // CORPO – altura 50, centro em -25 => pés na linha do chão

  fill(30, 120, 60);

  rect(0, -25, 32, 50, 8);

  // CABEÇA

  fill(230, 210, 190);

  ellipse(0, -55, 26, 26);

  // CAPACETE

  fill(20, 90, 40);

  arc(0, -58, 30, 22, PI, TWO_PI);

  // ROSTO (olhos + sorriso)

  fill(0);

  ellipse(-5, -56, 3, 3);

  ellipse( 5, -56, 3, 3);

  noFill();

  arc(0, -50, 10, 6, 0, PI);

  // BRAÇOS

  stroke(0);

  line(-12, -35, -24, -45);   // esquerdo

  line( 12, -35,  24, -25);   // direito “acenando”

  // PERNAS

  line(0, 0, -8, 18);

  line(0, 0,  8, 18);

  // Placa de vitória / derrota

  if (estadoJogo == VENCEU || estadoJogo == PERDEU) {

    float px = 70;

    float py = -80;

    fill(estadoJogo == VENCEU ? color(0, 170, 0) : color(200, 40, 40));

    rect(px, py, 110, 40, 6);

    fill(255);

    textSize(18);

    textAlign(CENTER, CENTER);

    text(estadoJogo == VENCEU ? "VENCEU!" : "PERDEU", px, py);

  }

  popStyle();

  popMatrix();

}

void desenharJogador() {

  if (!temDados) return;

  float xInicio = 120;

  float xSensor = 800;

  float posClamp = constrain(posicaoCm, DIST_MIN, DIST_MAX);

  float xJogador = map(posClamp, DIST_MAX, DIST_MIN, xInicio, xSensor);

  float yChao = 240;

  stroke(0);

  strokeWeight(3);

  fill(80,220,200);

  ellipse(xJogador, yChao - 35, 30, 30);

  line(xJogador, yChao - 20, xJogador, yChao + 10);

  line(xJogador, yChao + 10, xJogador - 10, yChao + 30);

  line(xJogador, yChao + 10, xJogador + 10, yChao + 30);

}

void desenharPainel() {

  fill(COR_VERDE_ESCURO);

  noStroke();

  rect(0, 260, width, 60);

  fill(255);

  textSize(20);

  text("Posição: " + posicaoCm + " cm", 20, 290);

  text("Variação vermelha: " + variacaoCm + " cm", 300, 290);

  text("Velocidade: " + velocidadeCms + " cm/s", 600, 290);

}

// ================= GRÁFICOS =================

void desenharHistorico() {

  fill(COR_VERDE_ESCURO);

  noStroke();

  rect(0, 320, width, 280);

  fill(255);

  textSize(16);

  text("Gráficos das últimas leituras", 60, 320);

  if (histPos.isEmpty()) return;

  float margemEsq = 60;

  float margemDir = 60;

  float topoPainel = 360;

  float basePainel = height - 40;

  float larguraTotal = width - margemEsq - margemDir;

  float gapX = 40;

  float larguraGraf = (larguraTotal - gapX) / 2.0;

  float rawMinPos = minList(histPos);

  float rawMaxPos = maxList(histPos);

  float minPos = max(0, rawMinPos - 10);

  float maxPos = min(DIST_MAX, rawMaxPos + 10);

  float rawMaxVar = maxList(histVar);

  if (rawMaxVar <= 0) rawMaxVar = 1;

  float minVar = 0;

  float maxVar = rawMaxVar * 1.1;

  float x0_1 = margemEsq;

  float x1_1 = x0_1 + larguraGraf;

  float x0_2 = x1_1 + gapX;

  float x1_2 = x0_2 + larguraGraf;

  float yTop = topoPainel;

  float yBot = basePainel;

  desenharGraficoSerie(histPos, "Posição (cm)",

      x0_1, x1_1, yTop, yBot, minPos, maxPos, color(255));

  desenharGraficoSerie(histVar, "Variação no vermelho (cm)",

      x0_2, x1_2, yTop, yBot, minVar, maxVar, color(255,230,80));

}

void desenharGraficoSerie(ArrayList<Float> serie, String titulo,

  float x0, float x1, float yTop, float yBot, float minVal, float maxVal, int corLinha) {

  int n = serie.size();

  if (n < 2) return;

  if (maxVal <= minVal) {

    maxVal = minVal + 1;

  }

  float rangeY = maxVal - minVal;

  float rawStepY = rangeY / 4.0;

  float stepY = niceStep(rawStepY);

  float yMinAxis = floor(minVal / stepY) * stepY;

  float yMaxAxis = ceil(maxVal / stepY) * stepY;

  if (yMaxAxis == yMinAxis) yMaxAxis = yMinAxis + stepY;

  stroke(255);

  noFill();

  rect(x0, yTop, x1 - x0, yBot - yTop);

  textAlign(RIGHT, CENTER);

  textSize(10);

  for (float v = yMinAxis; v <= yMaxAxis + 0.0001; v += stepY) {

    float y = map(v, yMinAxis, yMaxAxis, yBot, yTop);

    stroke(80,150,80);

    line(x0, y, x1, y);

    stroke(255);

    line(x0 - 4, y, x0, y);

    fill(255);

    noStroke();

    String label;

    if (abs(yMaxAxis - yMinAxis) <= 20) {

      label = nf(v,0,1);

    } else {

      label = str(round(v));

    }

    text(label, x0 - 6, y);

  }

  int numTicksX = 4;

  textAlign(CENTER, TOP);

  textSize(10);

  for (int i = 0; i <= numTicksX; i++) {

    float tNorm = i / (float) numTicksX;

    float x = lerp(x0, x1, tNorm);

    stroke(255);

    line(x, yBot, x, yBot + 4);

    int idx = round(tNorm * (n - 1));

    fill(255);

    text(idx, x, yBot + 6);

  }

  stroke(corLinha);

  strokeWeight(2);

  noFill();

  beginShape();

  for (int i = 0; i < n; i++) {

    float v = serie.get(i);

    float x = map(i, 0, n - 1, x0, x1);

    float y = map(v, yMinAxis, yMaxAxis, yBot, yTop);

    vertex(x, y);

  }

  endShape();

  fill(255);

  textAlign(CENTER, BOTTOM);

  textSize(14);

  text(titulo, (x0 + x1)/2, yTop - 4);

}

float minList(ArrayList<Float> lista) {

  float m = Float.MAX_VALUE;

  for (float v : lista) if (v < m) m = v;

  return m;

}

float maxList(ArrayList<Float> lista) {

  float m = -Float.MAX_VALUE;

  for (float v : lista) if (v > m) m = v;

  return m;

}

float niceStep(float rawStep) {

  if (rawStep <= 0) return 1;

  float exp = floor(log(rawStep)/log(10));

  float base = pow(10, exp);

  float frac = rawStep / base;

  float niceFrac;

  if      (frac <= 1.0) niceFrac = 1.0;

  else if (frac <= 2.0) niceFrac = 2.0;

  else if (frac <= 5.0) niceFrac = 5.0;

  else                  niceFrac = 10.0;

  return niceFrac * base;

}

// -----------------------------------------------------------------------------

//                          LÓGICA APÓS CADA LEITURA

// -----------------------------------------------------------------------------

void registrarLeitura() {

  temDados = true;

  historico.add(posicaoCm + " cm ; " + variacaoCm + " cm ; " + velocidadeCms + " cm/s");

  if (historico.size() > MAX_LINHAS) historico.remove(0);

  histPos.add((float)posicaoCm);

  histVar.add((float)abs(variacaoCm));

  // === LOGAR NA PLANILHA (se ativo) ===

  if (modoPlanilha) escreverLinhaCSV();

  if (usarSimulacao) verificarVitoriaOuDerrota();

}

void verificarVitoriaOuDerrota() {

  if (estadoJogo != JOGANDO) return;

  if (semaforo == 0 && abs(variacaoCm) > 10) {

    estadoJogo = PERDEU;

  }

  if (posicaoCm <= 5) {

    estadoJogo = VENCEU;

  }

}

// -----------------------------------------------------------------------------

//                                   SIMULAÇÃO

// -----------------------------------------------------------------------------

void gerarSimulacao() {

  if (modoSimulacao == 0) gerarSimulacaoNormal();

  else if (modoSimulacao == 1) gerarSimulacaoVence();

  else if (modoSimulacao == 2) gerarSimulacaoPerde();

}

// --- MODO 0: normal ---

void gerarSimulacaoNormal() {

  if (estadoJogo != JOGANDO) return;

  contadorSemaforo++;

  int duracaoVerde = 240;

  int duracaoVermelho = 180;

  int cicloTotal = duracaoVerde + duracaoVermelho;

  int fase = contadorSemaforo % cicloTotal;

  if (fase < duracaoVerde) {

    semaforo = 1;

    momento = 'E';

  } else {

    semaforo = 0;

    momento = 'O';

  }

  if (semaforo == 1) {

    int velocidadeAlvo = (int)random(5, 20);

    velocidadeCms = velocidadeAlvo;

    variacaoCm = -velocidadeCms;

    posicaoCm += variacaoCm;

    posicaoCm = constrain(posicaoCm, DIST_MIN, DIST_MAX);

  } else {

    variacaoCm = 0;

    velocidadeCms = 0;

  }

  registrarLeitura();

}

// --- MODO 1: roteiro de vitória ---

void gerarSimulacaoVence() {

  if (estadoJogo != JOGANDO) return;

  frameEtapa++;

  int passo = 10;

  if (etapaTeste == 0) {

    semaforo = 1; momento = 'E';

    velocidadeCms = passo;

    variacaoCm = -passo;

    posicaoCm += variacaoCm;

    if (posicaoCm <= 200) {

      posicaoCm = 200;

      etapaTeste = 1;

      frameEtapa = 0;

    }

  } else if (etapaTeste == 1) {

    semaforo = 0; momento = 'O';

    velocidadeCms = 0;

    int ruido = (int)random(-2, 3);

    variacaoCm = ruido;

    posicaoCm += variacaoCm;

    posicaoCm = constrain(posicaoCm, 190, 210);

    if (frameEtapa >= 30) {

      etapaTeste = 2;

      frameEtapa = 0;

    }

  } else if (etapaTeste == 2) {

    semaforo = 1; momento = 'E';

    velocidadeCms = passo;

    variacaoCm = -passo;

    posicaoCm += variacaoCm;

    if (posicaoCm <= 0) {

      posicaoCm = 0;

      etapaTeste = 3;

    }

  } else {

    semaforo = 1; momento = 'E';

    velocidadeCms = 0;

    variacaoCm = 0;

  }

  registrarLeitura();

}

// --- MODO 2: roteiro de derrota ---

void gerarSimulacaoPerde() {

  if (estadoJogo != JOGANDO) return;

  frameEtapa++;

  int passo = 10;

  if (etapaTeste == 0) {

    semaforo = 1; momento = 'E';

    velocidadeCms = passo;

    variacaoCm = -passo;

    posicaoCm += variacaoCm;

    if (posicaoCm <= 300) {

      posicaoCm = 300;

      etapaTeste = 1;

      frameEtapa = 0;

    }

  } else if (etapaTeste == 1) {

    semaforo = 0; momento = 'O';

    if (frameEtapa < 20) {

      velocidadeCms = 0;

      int ruido = (int)random(-2, 3);

      variacaoCm = ruido;

      posicaoCm += variacaoCm;

      posicaoCm = constrain(posicaoCm, 280, 320);

    } else if (frameEtapa == 20) {

      velocidadeCms = 15;

      variacaoCm = -15;

      posicaoCm += variacaoCm;

      etapaTeste = 2;

    } else {

      veloci
















## Diagramas e reprodução desta edição

Consulte os [diagramas explicativos](../DIAGRAMAS.md), os [objetivos pedagógicos](../OBJETIVOS_PEDAGOGICOS.md) e a [validação](../VALIDACAO.md). As figuras originais não foram republicadas. Os novos diagramas e os testes acompanham as implementações organizadas.

## Autoria e créditos

Luigi Scofano de Araujo · USP 13680334.

Créditos de participação constantes do material de origem: Lucas Lacerda, Paulo Henrique Mota de Oliveira.

## Reprodução e figuras desta edição

[Diagramas explicativos](../DIAGRAMAS.md) · [Validação](../VALIDACAO.md) · [Objetivos pedagógicos](../OBJETIVOS_PEDAGOGICOS.md).
