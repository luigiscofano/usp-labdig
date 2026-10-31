# Aceitação da edição em bancada

**Situação: não executada.** Este roteiro registra como obter as evidências físicas que a simulação não fornece. Preencha os campos com resultados reais; um item sem evidência continua pendente.

## Identificação da execução

| Campo | Registro |
| --- | --- |
| Commit testado | A preencher |
| Responsável e data | A preencher |
| Placa e FPGA | A preencher |
| Versão Quartus e pacote do dispositivo | A preencher |
| Alvo e top-level | A preencher |
| Sensor, servo e adaptadores | A preencher |
| Clock e alimentação medidos | A preencher |
| QSF e SDC usados | Anexar arquivos da montagem |

## Critérios e evidências

| Etapa | Critério de aceitação | Evidência a anexar | Estado |
| --- | --- | --- | --- |
| Síntese | Top e dispositivo corretos; ausência de erros e latches não intencionais | Relatórios de Analysis & Synthesis | Pendente |
| Pinagem | Todos os sinais atribuídos e compatíveis com o esquema da montagem | QSF e esquema revisado | Pendente |
| Timing | Clocks e caminhos relevantes restritos; setup/hold sem violação | Relatório Timing Analyzer e lista de caminhos não restritos | Pendente |
| Reset | Retorno ao estado inicial durante repouso, aquisição e transmissão | Captura ou vídeo identificado | Pendente |
| PWM | Período e oito larguras coerentes com os parâmetros; posições calibradas | Oscilogramas e tabela ângulo/largura | Pendente |
| HC-SR04 | Distâncias comparadas a régua em vários pontos e repetições | Tabela de referência, leituras e erro | Pendente |
| Falha do sensor | Registrar comportamento sem eco e com echo travado | Captura e decisão de recuperação | Pendente |
| UART | 115200, 7E1 e quadros completos coerentes com a leitura | Captura do analisador e texto recebido | Pendente |
| Processing físico | Receber a porta real, desenhar leituras e salvar CSV | Log, CSV e captura da janela | Pendente |
| Guardião | Vitória, derrota, tolerância 10/11 cm e reinício consistentes | Roteiro executado e resultados | Pendente |
| Math Genius | Operações, respostas corretas/incorretas e níveis exercitados | Tabela de casos e resultados | Pendente |

Não há pinagem universal: os treze alvos têm portas distintas. Confira manual da placa e esquema antes de atribuir pinos. O gerador inclui apenas dispositivo, fontes, top e clock básico; não declara restrições de E/S específicas da montagem.

## Objetivos pedagógicos desta verificação

- Relacionar requisito, estímulo, medição e critério de aprovação.
- Distinguir compilação, simulação, síntese, temporização e comportamento físico.
- Explicar erro de medição, quantização e calibração em vez de apenas observar o jogo funcionar.
- Registrar falhas e justificar alterações por evidências reproduzíveis.

Os objetivos de aprendizagem dos jogadores continuam sendo intenções de projeto. Sua avaliação exige atividades com participantes e instrumentos próprios; passar nos testes eletrônicos não demonstra eficácia pedagógica ou clínica.
