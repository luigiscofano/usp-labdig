# Laboratório Digital I e II · Circuitos, jogos e FPGA

> Acervo de Verilog da Poli-USP: 11 experiências e dois projetos integradores, com simulação, controle e fluxo de dados, sensores, UART, interface Processing e objetivos pedagógicos.

[![Verificação](https://github.com/luigiscofano/usp-labdig/actions/workflows/verificacao.yml/badge.svg?branch=main)](https://github.com/luigiscofano/usp-labdig/actions/workflows/verificacao.yml)

[O que faz](#o-que-este-projeto-faz) · [Módulos](#funcionalidades-e-módulos) · [Executar](#como-executar) · [Aprendizagem](#o-que-desenvolvi-e-aprendi) · [Estado atual](#estado-atual) · [Documentação](#documentação-e-navegação)

## O que este projeto faz

Reúne experimentos e projetos de **Laboratório Digital I e II da Poli-USP**. Há circuitos que contam, comparam, controlam sequências, medem distância, movimentam servo e transmitem dados; os projetos Math Genius e Guardião do Paredão integram essas ideias em jogos físicos.

Verilog descreve o comportamento de um circuito, em vez de ser um aplicativo comum para executar no terminal. Um **testbench** fornece sinais simulados e confere resultados. A **FPGA** é o dispositivo reconfigurável que pode receber o circuito depois de síntese e configuração de placa. É possível começar pelas simulações sem possuir a FPGA.

## Qual problema resolve

O acervo conecta especificação, máquina de estados, fluxo de dados e evidência de funcionamento. A organização separa **13 alvos independentes** de suas versões históricas, evitando misturar módulos homônimos que pertencem a circuitos diferentes. Os relatórios explicam decisões; os testes permitem reproduzir parte das verificações.

## Funcionalidades e módulos

### 1. LabDig I — fundamentos e jogos sequenciais

| Experiência | O que o circuito estuda | Objetivo observável |
| --- | --- | --- |
| [01 · Contadores](labdig-1/experimentos/exp-01/README.md) | Clock, carga, enable e reset | Prever o valor a cada borda |
| [02 · Comparação](labdig-1/experimentos/exp-02/README.md) | Contador, comparador e sinais de magnitude | Relacionar valor contado e condição de término |
| [03 · Controle](labdig-1/experimentos/exp-03/README.md) | Estados, captura e ROM | Explicar qual ação ocorre em cada estado |
| [04 · Entradas físicas](labdig-1/experimentos/exp-04/README.md) | Sinais externos e controle periódico | Distinguir pulso, nível e sequência de controle |
| [05 · Sequência](labdig-1/experimentos/exp-05/README.md) | Jogadas e comparação com memória | Acompanhar uma rodada |
| [06 · Memória](labdig-1/experimentos/exp-06/README.md) | Apresentação e resposta em rodadas cumulativas | Justificar avanço, erro e reinício |

### 2. Math Genius — desafios aritméticos

Projeto independente em que ROMs armazenam operações e os controles físicos permitem construir uma resposta. Unidade de controle e fluxo de dados coordenam dificuldade, confirmação, comparação e feedback. O objetivo do jogador é exercitar cálculo e revisão da resposta; o do desenvolvedor é representar a regra em circuitos síncronos.

A cópia selecionada **compila** no verificador. Não há teste completo de todas as partidas nem validação física das revisões desta edição. [Código, arquitetura e guia](projetos/math-genius/README.md).

### 3. LabDig II — comunicação e medição

| Experiência | Componentes | O que observar |
| --- | --- | --- |
| [01 · Servo](labdig-2/experimentos/exp-01/README.md) | PWM | Período e largura de pulso |
| [02 · Serial](labdig-2/experimentos/exp-02/README.md) | UART | Start, dados, paridade e stop |
| [03 · Ultrassom](labdig-2/experimentos/exp-03/README.md) | HC-SR04 | Duração do echo e conversão em distância |
| [04 · Trena](labdig-2/experimentos/exp-04/README.md) | Sensor, BCD e ASCII | Medição e transmissão coerentes |
| [05 · Sonar](labdig-2/experimentos/exp-05/README.md) | Servo, sensor e UART | Associação entre ângulo e medida |

### 4. Guardião do Paredão — avançar e parar

O circuito alterna sinais para movimento e espera, mede a posição por ultrassom, compara deslocamentos e transmite a rodada. Integra sensor, média de amostras, controle de servo, sinalização e UART. O protocolo e as regras estão no [guia do Guardião](projetos/guardiao-do-paredao/README.md).

A interface Processing no computador mostra o estado do jogo, histórico e exportação CSV. Ela também tem simulação, permitindo experimentar vitória e derrota sem placa. As intenções de atenção, espera e regulação do movimento são **objetivos de design educacional**, sem comprovação terapêutica ou de eficácia com participantes.

### 5. Biblioteca, ferramentas e acervo

Os componentes reutilizáveis apoiam os experimentos; o gerador Tcl prepara projetos Quartus a partir dos fontes públicos. O histórico reúne **210 fontes Verilog recuperados**, incluindo variantes e rascunhos. Os **31 relatórios revisados** e as apresentações oferecem contexto técnico. Não são versões equivalentes de um único circuito: escolha um alvo e siga suas dependências.

## Como executar

### Simular, sem FPGA

**Requisitos:** Python 3, Icarus Verilog 12 (`iverilog` e `vvp` no PATH) e Git. No Ubuntu/WSL, as ferramentas podem ser instaladas pelo gerenciador de pacotes; no Windows, WSL é uma opção para usar o mesmo fluxo de Linux.

```sh
git clone https://github.com/luigiscofano/usp-labdig.git
cd usp-labdig
```

```sh
iverilog -V
vvp -V
python scripts/verificar.py
```

O resultado deve listar `PASS` para os alvos e testbenches. O relatório estruturado fica em `build/resultados.json`. Se seu sistema usa `python3`, substitua o nome do comando. Para apenas compilar os 13 circuitos, use:

```sh
python scripts/verificar.py --somente-compilar
```

Não compile todos os `.v` do repositório juntos: há versões diferentes com os mesmos nomes de módulo. O script seleciona cada conjunto e seu top-level.

### Experimentar a interface do Guardião

Instale o Processing com suporte Java/Serial, abra `projetos/guardiao-do-paredao/processing/Guardiao/Guardiao.pde` e execute o sketch. A opção `usarSimulacao` começa em `true`.

| Tecla | Função |
| --- | --- |
| 0 / 1 / 2 | Simulação normal / vitória / derrota |
| J | Reiniciar |
| X | Ativar ou desativar registro CSV |
| S | Salvar snapshot do histórico |

Para compilar a adaptação Java e testar sua lógica, é necessário JDK 17. No Linux/macOS:

```sh
python scripts/verificar_processing.py --classpath "$(python scripts/baixar_dependencias_processing.py)"
```

No PowerShell, use uma variável para o classpath:

```powershell
$classpathProcessing = python scripts/baixar_dependencias_processing.py
python scripts/verificar_processing.py --classpath "$classpathProcessing"
```

### Preparar uso em placa

Com Quartus instalado, `quartus_sh -t scripts/gerar_quartus.tcl guardiao` prepara arquivos em `build/quartus/`. É preciso conferir dispositivo, clock, pinagem, níveis elétricos e temporização antes de programar a FPGA. Para serial física, configure a porta real e o protocolo **115200, 7E1**. Os roteiros de [hardware](docs/HARDWARE.md) e [aceitação em bancada](docs/ACEITACAO_BANCADA.md) descrevem essas etapas.

## O que desenvolvi e aprendi

O portfólio reúne trabalhos em grupo, organização dos fontes e relatórios, correções e implementações de apoio documentadas. As competências incluem máquinas de estados, separação entre controle e dados, comunicação, sensor/atuador, testes com asserções e rastreabilidade entre requisitos e sinais. [IMPLEMENTACOES.md](docs/IMPLEMENTACOES.md) identifica a origem das partes desta edição.

**Objetivo pedagógico central:** explicar uma rodada ou medição do começo ao fim, indicar o sinal que causa cada transição e reproduzir uma falha com um testbench. O [guia pedagógico](docs/OBJETIVOS_PEDAGOGICOS.md) também diferencia objetivos do estudante e objetivos dos jogos.

## Estado atual

| Verificação | Situação |
| --- | --- |
| Treze alvos independentes | Compilação verificada |
| Conversões, UART, Guardião, aquisição, telemetria, sonar, PWM | Cenários simulados com asserções |
| Interface Processing | Adaptação Java compilada; lógica e janela em display virtual testadas |
| Gerador Quartus | Tcl testado com API do Quartus simulada |
| FPGA e periféricos reais | Síntese, timing, pinagem e aceitação física ainda precisam ser executados |
| Math Genius e jogos de memória | Sem cobertura completa de partidas |

## Validação e limites

Simulação digital não certifica montagem, ruído de sensor, servo físico ou comunicação serial real. A aquisição ainda exige análise de falhas persistentes e echo travado. Os resultados, comandos e limites específicos estão em [VALIDACAO.md](docs/VALIDACAO.md). Os objetivos dos jogos não equivalem a avaliação clínica ou pedagógica com participantes.

## Documentação e navegação

| Caminho | Conteúdo |
| --- | --- |
| [LabDig I](labdig-1/README.md) / [LabDig II](labdig-2/README.md) | Percursos e experimentos |
| [Math Genius](projetos/math-genius/README.md) / [Guardião](projetos/guardiao-do-paredao/README.md) | Projetos independentes |
| [Biblioteca](biblioteca/README.md) / [testes](tests/README.md) | Componentes e critérios de aprovação |
| [Documentos](docs/DOCUMENTOS.md) / [histórico](historico/README.md) | Relatórios e versões recuperadas |
| [Apresentações](apresentacoes/README.md) | Roteiro e versão HTML |
| [Comece aqui](docs/COMECE_AQUI.md) / [documentação](docs/README.md) | Índices, diagramas, correções e guias |

## Autoria, referências e licença

Organização do portfólio: **Luigi Scofano de Araujo · USP 13680334**. Os projetos e componentes mantêm os créditos de seus grupos e autores. A documentação diferencia fontes históricos, correções e implementações novas, sem aplicar uma licença geral nova aos materiais de terceiros. Consulte [acervo](docs/ACERVO.md) e [procedência](docs/IMPLEMENTACOES.md).


## Tópicos do repositório

`verilog` · `systemverilog` · `fpga` · `digital-design` · `finite-state-machine` · `uart` · `pwm` · `icarus-verilog` · `processing` · `educational-games` · `usp`
