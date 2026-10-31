# Comece aqui

## Para conhecer o portfólio

Leia os [objetivos pedagógicos](OBJETIVOS_PEDAGOGICOS.md), abra [Math Genius](../projetos/math-genius/README.md) e [Guardião](../projetos/guardiao-do-paredao/README.md). A [apresentação](../apresentacoes/README.md) oferece uma visão geral para exposição oral.

## Para estudar sistemas digitais

Comece por [LabDig I](../labdig-1/README.md), avance para [LabDig II](../labdig-2/README.md) e use os relatórios de cada experimento para relacionar teoria e montagem. As transcrições em Markdown facilitam busca e leitura. As figuras estão ao final de cada transcrição e os originais mantêm a disposição original.

## Para executar código

Instale Icarus Verilog e Python 3. Execute `python scripts/verificar.py` na raiz. Os oito alvos usam conjuntos de fontes independentes. Os novos testes usam SystemVerilog, enquanto as cópias históricas são compiladas em modo Verilog 2005, evitando tratar `sequence` dos testbenches antigos como palavra reservada de SystemVerilog.

Para abrir um arquivo `.qar`, use o recurso de restauração de projeto do Quartus, em uma pasta própria para cada versão. Para projetos `.qpf`, abra o projeto e confira se os caminhos do `.qsf` existem na sua máquina. Nunca misture arquivos de revisões diferentes por semelhança do nome.

## Para montar em FPGA

Use o [guia de bancada](HARDWARE.md), confira a placa e a pinagem do projeto escolhido e restaure seu arquivo Quartus. As cópias organizadas passaram por compilação digital, mas ainda precisam de síntese e ensaio no hardware após as correções. Não foram gerados arquivos `.sof` novos neste trabalho.

## Situação dos arquivos

`historico/` mantém os fontes Verilog recuperados. Os relatórios revisados estão em `docs/relatorios/`. `projetos/` e os diretórios `rtl/` das disciplinas contêm cópias selecionadas para estudo e compilação. [CORRECOES.md](CORRECOES.md) explica as alterações. Modelos vazios e tentativas parciais continuam no histórico, sem serem apresentados como solução final.
