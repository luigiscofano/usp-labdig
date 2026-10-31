# Procedência das implementações

Os arquivos recuperados foram mantidos no acervo de preparação, separado da edição pública. Esta edição acrescenta cópias de trabalho e implementações identificadas abaixo. Nenhuma reimplementação é apresentada como entrega histórica do grupo.

| Conjunto | Procedência | O que mudou nesta edição |
| --- | --- | --- |
| LabDig I, exp. 01 | Relatório sobre contador e reset | Novo `contador_didatico`, com reset síncrono, carga, enable e retorno módulo 16 |
| LabDig I, exp. 02 | Arquivo denominado PARCIAL e componentes recuperados | Remoção de espaço não separável que impedia o parser e reunião das dependências |
| LabDig I, exp. 03–06 | Fontes Verilog recuperados | Seleção de conjuntos de compilação independentes |
| Math Genius | Versão recuperada em OL25/03 | Correções de barramentos e conexões dos displays |
| LabDig II, exp. 01 | Controle de servo recuperado | Reunião de dependências e adaptação dos nomes dos parâmetros PWM |
| LabDig II, exp. 02 | Fontes de UART recuperados | Conjunto de compilação independente |
| LabDig II, exp. 03 | Sensor recuperado do projeto final | Novo wrapper `interface_ultrassonica` para expor a interface do experimento |
| LabDig II, exp. 04 | Relatório da trena com envio ASCII | Novo `trena_serial` e formatador `telemetria_ascii` |
| LabDig II, exp. 05 | Relatório do sonar com oito posições | Novo `sonar`, com estabilização, aquisição e envio de ângulo e distância |
| Guardião | Fontes de Semana final e documento do Processing | Correções descritas em CORRECOES.md e verificação automática |

## Dependências compartilhadas

Os experimentos 3–5 de LabDig II usam os componentes recuperados de `projetos/guardiao-do-paredao/rtl`. Isso mantém uma única cópia corrigida da interface e da UART. O script de verificação reúne essas dependências explicitamente. `biblioteca/rtl/telemetria_ascii.v` é uma implementação nova, compartilhada pela trena e pelo sonar.

## Alcance das novas versões

A trena realiza uma aquisição por solicitação e transmite `ddd#`. O sonar realiza uma varredura de oito posições, de 20 a 160 graus, e transmite `aaa,ddd#`. Essas versões implementam o núcleo descrito nos relatórios. Os desafios adicionais e os arquivos Quartus históricos continuam no acervo e não foram considerados equivalentes sem comparação em bancada.

O `.qar` conserva uma revisão Quartus. Sua presença não significa que todos os fontes internos foram extraídos ou que aquela revisão passou pelos novos testes. Para comparar a versão histórica com a organizada, restaure o QAR no Quartus e confira os módulos e parâmetros.

## Testes novos

Os arquivos `tests/tb_*.sv` e `tests/GuardiaoLogicTest.java` foram escritos nesta edição. Usam critérios explícitos de aprovação e falham quando uma condição esperada não é atendida. Os testbenches históricos permanecem nos originais.

## Materiais equivalentes para publicação

Os 31 relatórios receberam versões em Markdown sem números USP dos colegas ou links privados. Capturas históricas foram substituídas pelos diagramas explicativos desta edição e pelos testes reproduzíveis. O script `scripts/gerar_quartus.tcl` cria projetos portáteis a partir dos fontes, oferecendo uma alternativa aos arquivos QAR históricos. Ele exige verificação no Quartus e definição da pinagem antes do ensaio físico.
