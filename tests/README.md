# Testes do Laboratório Digital

[Início](../README.md) · [Como executar](../README.md#como-executar) · [Aprendizagem](../README.md#o-que-desenvolvi-e-aprendi) · [Estado atual](../README.md#estado-atual)

> **Nesta área:** testes e seus critérios de aprovação; um resultado deve ser interpretado dentro da cobertura documentada.

## O que é verificado

O verificador da raiz compila 13 alvos separados e executa oito testbenches de integração. Os testes aplicam entradas conhecidas e encerram com erro quando uma asserção falha.

| Testbench | Responsabilidade |
| --- | --- |
| tb_componentes | Conversões, diferença de posição e componentes |
| tb_uart | Serial, caracteres, paridade, stop e reset |
| tb_controle_guardiao | Decisões de jogo, vitória, derrota e continuidade |
| tb_pacote | Pacote serial integrado do Guardião |
| tb_aquisicao | Média de amostras, timeout e representação |
| tb_telemetria | Formatação e preservação de dados da trena/sonar |
| tb_sonar_integrado | Ângulos, sensor comportamental e UART |
| tb_pwm_contador | Contagem, carga, enable e larguras de pulso |

## Como executar

Na raiz, com Icarus Verilog e Python no PATH, use `python scripts/verificar.py`. O resultado estruturado fica em `build/resultados.json`.

A verificação de Processing usa `scripts/verificar_processing.py`, com as dependências obtidas por `scripts/baixar_dependencias_processing.py`. Os comandos completos, inclusive display virtual, estão em [VALIDACAO.md](../docs/VALIDACAO.md). `test_gerador_quartus.py` verifica a geração Tcl com API simulada, não o Quartus real.

## Como interpretar

Os testes cobrem cenários definidos e não todas as partidas ou combinações de sinais. Síntese, timing, pinagem, sensor real, servo e serial física exigem validação em bancada. Para estudar, escolha uma asserção, preveja sua saída e acompanhe os sinais que justificam o resultado.

---

**Projeto:** [Laboratório Digital I e II · Circuitos, jogos e FPGA](../README.md). Consulte a raiz para os requisitos e o primeiro comando; este guia aprofunda a área `tests/`.
