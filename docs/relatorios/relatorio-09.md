# Código do processing


Versão revisada para consulta pública. A disposição gráfica foi substituída por texto, tabelas e diagramas novos. Dados pessoais de terceiros e referências privadas foram retirados. Os créditos foram preservados.

Código da interface do processing:



//-------------------------- Guardião do Paredão (4 m) --------------------------

// V0 - versão com gráficos + MODO PLANILHA (CSV para Excel) + tecla J (Jogar/reset)

import processing.serial.*;

import java.util.*;

import java.text.*; // para timestamp no nome do arquivo

// Se true, usa simulação. Se false, lê da porta serial.

boolean usarSimulacao = true;

// =================== SERIAL ===================

Serial myPort;

String porta = "COM7";

int baudrate = 115200;

char parity = 'E';

int databits = 7;

float stopbits = 1.0;

// =================== DADOS DO JOGO ===================

int posicaoCm = 400; // distância ao sensor

int variacaoCm = 0; // variação ACUMULADA enquanto o sinal está vermelho (cm)

int velocidadeCms = 0; // cm/s (usado na simulação)

boolean temDados = false;

final int DIST_MAX = 400;

final int DIST_MIN = 0;

// semáforo: 0 = vermelho (pare), 1 = verde (anda)

int semaforo = 1;

// estados do jogo

final int JOGANDO = 0;

final int VENCEU = 1;

final int PERDEU = 2;

int estadoJogo = JOGANDO;

// campos do protocolo

char momento = 'O'; // 'E' = começar movimento (verde), 'O' = parar (vermelho)

char flagFinal = 'J'; // 'G' = ganhou, 'P' = perdeu, 'J' = jogando

// === modos de simulação ===

// 0 = normal (anda/para com semáforo alternando)

// 1 = roteiro de vitória (vence sempre)

// 2 = roteiro de derrota (perde no vermelho)

int modoSimulacao = 0;

// controle da simulação

int etapaTeste = 0;

int frameEtapa = 0;

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

final int COR_VERDE_CAMPO = color(60, 180, 90);

final int COR_VERMELHO = color(230, 60, 60);

// =================== MODO PLANILHA (CSV) ===================

boolean modoPlanilha = false; // tecla 'X' liga/desliga logging contínuo

PrintWriter csv = null; // writer do CSV de logging contínuo

String csvPath = ""; // caminho do arquivo CSV atual

int amostraSeq = 0; // contador sequencial das amostras logadas

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

// DESENHO VISUAL

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

float yChao = 240; // mesma linha do chão do jogador

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

line(-12, -35, -24, -45); // esquerdo

line( 12, -35, 24, -25); // direito “acenando”

// PERNAS

line(0, 0, -8, 18);

line(0, 0, 8, 18);

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

if (frac <= 1.0) niceFrac = 1.0;

else if (frac <= 2.0) niceFrac = 2.0;

else if (frac <= 5.0) niceFrac = 5.0;

else niceFrac = 10.0;

return niceFrac * base;

}

// -----------------------------------------------------------------------------

// LÓGICA APÓS CADA LEITURA

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

// SIMULAÇÃO

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

velocidadeCms = 0;

variacaoCm = 0;

}

} else {

semaforo = 0; momento = 'O';

velocidadeCms = 0;

variacaoCm = 0;

}

registrarLeitura();

}

// -----------------------------------------------------------------------------

// LEITURA DA SERIAL

// -----------------------------------------------------------------------------

void serialEvent(Serial p) {

if (usarSimulacao) return;

String data = p.readStringUntil('#');

if (data == null) return;

data = trim(data.replace("#", ""));

if (data.length() == 0) return;

String[] partes = splitTokens(data, ",");

if (partes.length < 4) return;

try {

String mStr = trim(partes[0]);

if (mStr.length() > 0) momento = mStr.charAt(0);

String fStr = trim(partes[3]);

if (fStr.length() > 0) flagFinal = fStr.charAt(0);

if (flagFinal == 'G') estadoJogo = VENCEU;

else if (flagFinal == 'P') estadoJogo = PERDEU;

else estadoJogo = JOGANDO;

if (momento == 'E') {

semaforo = 1;

// em 'E' (verde) não vem posição/variação, então só registra mudança de estado

registrarLeitura();

return;

}

if (momento == 'O') {

semaforo = 0;

posicaoCm = constrain(int(partes[1]), DIST_MIN, DIST_MAX);

variacaoCm = int(partes[2]);

velocidadeCms = 0;

registrarLeitura();

}

} catch (Exception e) {

println("Erro serial: " + data);

e.printStackTrace();

}

}

// -----------------------------------------------------------------------------

// FUNÇÕES DE PLANILHA (CSV compatível Excel)

// -----------------------------------------------------------------------------

void abrirPlanilha() {

fecharPlanilha(); // garante fechar se existir

// Nome do arquivo com timestamp

String stamp = new SimpleDateFormat("yyyy-MM-dd_HH-mm-ss").format(new Date());

csvPath = sketchPath("logs_" + stamp + ".csv");

try {

csv = createWriter(csvPath);

// Cabeçalho

csv.println("timestamp_ms;amostra_seq;momento;flagFinal;semaforo;posicao_cm;variacao_cm;velocidade_cm_s;estado");

csv.flush();

println("[PLANILHA] Logging ON -> " + csvPath);

} catch(Exception ex) {

println("[PLANILHA] ERRO ao abrir arquivo: " + ex.getMessage());

csv = null;

}

}

void fecharPlanilha() {

if (csv != null) {

try {

csv.flush();

csv.close();

println("[PLANILHA] Logging OFF -> arquivo fechado: " + csvPath);

} catch(Exception ex) {

println("[PLANILHA] ERRO ao fechar arquivo: " + ex.getMessage());

}

csv = null;

csvPath = "";

}

}

void escreverLinhaCSV() {

if (csv == null) return;

try {

long t = millis();

amostraSeq++;

// mapeia estado para string

String estadoStr = (estadoJogo == JOGANDO) ? "JOGANDO" : (estadoJogo == VENCEU) ? "VENCEU" : "PERDEU";

// Usa ';' como separador (Excel PT-BR costuma abrir bem)

csv.println(

t + ";" +

amostraSeq + ";" +

momento + ";" +

flagFinal + ";" +

semaforo + ";" +

posicaoCm + ";" +

variacaoCm + ";" +

velocidadeCms + ";" +

estadoStr

);

csv.flush();

} catch(Exception ex) {

println("[PLANILHA] ERRO ao escrever linha: " + ex.getMessage());

}

}

// Snapshot único do histórico atual (sem depender do modoPlanilha)

void salvarSnapshotHistorico() {

String stamp = new SimpleDateFormat("yyyy-MM-dd_HH-mm-ss").format(new Date());

String path = sketchPath("snapshot_" + stamp + ".csv");

try {

PrintWriter snap = createWriter(path);

snap.println("idx;posicao_cm;variacao_cm_abs");

for (int i = 0; i < histPos.size(); i++) {

float p = histPos.get(i);

float v = histVar.get(i);

snap.println(i + ";" + nf(p,0,2) + ";" + nf(v,0,2));

}

snap.flush();

snap.close();

println("[SNAPSHOT] Arquivo gerado: " + path);

} catch(Exception ex) {

println("[SNAPSHOT] ERRO ao salvar: " + ex.getMessage());

}

}


## Diagramas e reprodução desta edição

Consulte os [diagramas explicativos](../DIAGRAMAS.md), os [objetivos pedagógicos](../OBJETIVOS_PEDAGOGICOS.md) e a [validação](../VALIDACAO.md). As figuras originais não foram republicadas. Os novos diagramas e os testes acompanham as implementações organizadas.

## Autoria e créditos

Luigi Scofano de Araujo · USP 13680334.

## Reprodução e figuras desta edição

[Diagramas explicativos](../DIAGRAMAS.md) · [Validação](../VALIDACAO.md) · [Objetivos pedagógicos](../OBJETIVOS_PEDAGOGICOS.md).
