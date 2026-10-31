# Validação da edição organizada

Data: 31/10/2026. Ferramentas: Icarus Verilog 12.0 e OpenJDK 17. A checagem do sketch usa Processing Core 3.3.7, Serial 3.3.7 e JSSC 2.8.0. As dependências de teste têm versões e SHA-256 fixados.

## Resultados confirmados

| Verificação | Cobertura | Resultado |
| --- | --- | --- |
| Compilação RTL | Treze alvos independentes | Aprovada |
| Conversões | Todos os valores de 0 a 999 em binário e BCD | Aprovada |
| Movimento e ASCII | Simetria da diferença, limites 10/11 cm e quatro estados | Aprovada |
| UART | 128 caracteres, sete bits, paridade par, stop e reset durante envio | Aprovada |
| Controle do Guardião | Vitória, derrota, continuidade e opção de luz | Aprovada |
| Pacote do Guardião | Recepção serial completa de `O,123,045,P#` | Aprovada |
| Aquisição | Média de 1 a 4 amostras, timeout e validação de BCD | Aprovada |
| Telemetria nova | Pacotes da trena e sonar, preservação dos dados durante envio | Aprovada |
| Sonar integrado | Oito ângulos, sensor comportamental e recepção UART | Aprovada |
| Contador e PWM | Reset, carga, enable, retorno e oito larguras | Aprovada |
| Processing, sem janela | Compilação da adaptação Java e testes de lógica | Aprovada |
| Processing gráfico | Janela Java2D no Xvfb, jogo/vitória/derrota, reset, CSV e snapshot | Aprovada |
| Gerador Quartus | Tcl real com API simulada: 13 alvos, fontes, top, clock e alvo inválido | Aprovada |

Os treze alvos são Math Genius, Guardião, experiências 1–6 de LabDig I e experiências 1–5 de LabDig II. O sensor sintético no teste do sonar emite eco de aproximadamente 17 cm. A distância recebida deve estar entre 16 e 18 cm e os ângulos devem seguir 20, 40, 60, 80, 100, 120, 140 e 160 graus. Esse teste confirma integração digital sob esses estímulos, sem substituir calibração real.

## Reprodução

```bash
python scripts/verificar.py
python scripts/verificar_processing.py --classpath "$(python scripts/baixar_dependencias_processing.py)"
```

O segundo comando requer JDK 17 (`java` e `javac` no PATH). No PowerShell, armazene primeiro a saída do script de dependências em uma variável e passe essa string a `--classpath`.

O verificador de Processing faz uma adaptação explícita do sketch para Java, compila contra as bibliotecas reais e executa testes de lógica sem janela. Ele não invoca o preprocessor oficial do Processing, nem verifica dispositivo serial físico. O teste gráfico adicional abre uma janela real de Processing/Java2D em display virtual e salva capturas; usa a mesma adaptação Java explícita.

```bash
# Linux, com Xvfb e JDK 17
xvfb-run -a python scripts/verificar_processing.py --grafico --classpath "$(python scripts/baixar_dependencias_processing.py)"
# Python com tkinter (Ubuntu: python3-tk)
python tests/test_gerador_quartus.py
```

As três telas são salvas em `build/processing/telas/`. O teste aciona os handlers de teclado e verifica criação e conteúdo do CSV; não simula cliques humanos. A inspeção visual também identificou e corrigiu sobreposição entre semáforo e título. O teste Tcl substitui as chamadas da API do Quartus por coletores de argumentos; não prova que o Quartus aceita o projeto nem produz QPF/QSF reais.

## Evidências

- [Resultados RTL e simulação](validacao/resultados-verilog.json).
- [Correções aplicadas](CORRECOES.md).
- [Procedência das implementações](IMPLEMENTACOES.md).


## Limites e pendências

- Síntese Quartus, análise temporal, pinagem e programação de FPGA não foram executadas.
- A interface foi aberta em display virtual; a recepção de uma porta serial física continua pendente.
- Os arquivos QAR não foram restaurados nesta sessão nem republicados. O script de geração de projetos Quartus oferece uma alternativa baseada nos fontes e precisa ser conferido no Quartus.
- O conjunto de testes não cobre todas as combinações de entradas nem todas as partidas do Math Genius e jogos de memória.
- Os módulos homônimos históricos podem ter interfaces incompatíveis. Os conjuntos selecionados devem ser compilados separadamente.
- A aquisição histórica repete tentativas quando nenhuma amostra é válida. Falhas persistentes e echo travado ainda exigem uma política global de recuperação e ensaio específico.
- Os parâmetros de tempo e PWM precisam ser conferidos para o dispositivo real. A simulação acelerada não valida o tempo físico de estabilização do servo.
- As intenções pedagógicas dos jogos não equivalem a uma avaliação com participantes.

O GitHub Actions repete os testes digitais e gráficos e publica logs e capturas como artefatos. Consulte a execução do commit em análise para confirmar seu resultado. A aceitação física segue o [roteiro de bancada](ACEITACAO_BANCADA.md), sem resultados preenchidos artificialmente.

Os anexos históricos permanecem fora desta edição pública.
