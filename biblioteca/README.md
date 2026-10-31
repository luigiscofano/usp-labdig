# Componentes compartilhados

[Início](../README.md) · [Como executar](../README.md#como-executar) · [Aprendizagem](../README.md#o-que-desenvolvi-e-aprendi) · [Estado atual](../README.md#estado-atual)

> **Nesta área:** conteúdo da área “Componentes compartilhados” dentro de Laboratório Digital I e II · Circuitos, jogos e FPGA; use o guia inicial para localizar a execução e as relações entre módulos.

[Início](../README.md) · [Como executar](../README.md#como-executar) · [Aprendizagem](../README.md#o-que-desenvolvi-e-aprendi) · [Estado atual](../README.md#estado-atual)

> **Nesta área:** conteúdo da área “Componentes compartilhados” dentro de Laboratório Digital I e II · Circuitos, jogos e FPGA; use o guia inicial para localizar a execução e as relações entre módulos.

`rtl/telemetria_ascii.v` formata e transmite medidas em ASCII usando a UART recuperada do Guardião. Com `COM_ANGULO=0`, envia `ddd#`. Com `COM_ANGULO=1`, envia `aaa,ddd#`.

O módulo captura os dados no início do pacote para impedir que uma mudança de entrada altere uma mensagem em andamento. `pronto=1` significa que aceita uma nova solicitação. A UART tem sua própria confirmação de ocupado e de fim de caractere.

**Objetivo pedagógico:** entender a diferença entre uma informação disponível no circuito e uma mensagem consistente transmitida ao longo de vários ciclos. O teste `tb_telemetria` altera a entrada durante a transmissão para verificar essa propriedade.

---

**Projeto:** [Laboratório Digital I e II · Circuitos, jogos e FPGA](../README.md). Consulte a raiz para os requisitos e o primeiro comando; este guia aprofunda a área `biblioteca/`.

---

**Projeto:** [Laboratório Digital I e II · Circuitos, jogos e FPGA](../README.md). Consulte a raiz para os requisitos e o primeiro comando; este guia aprofunda a área `biblioteca/`.
