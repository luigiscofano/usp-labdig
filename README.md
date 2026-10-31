<div align="center">

# Laboratório Digital · Poli-USP

### Sistemas digitais que viram experiências de aprendizagem

**Verilog · FPGA DE0-CV · Máquinas de estados · Processing · Serious games**

[Começar](docs/COMECE_AQUI.md) · [Objetivos pedagógicos](docs/OBJETIVOS_PEDAGOGICOS.md) · [Projetos](#projetos-em-destaque) · [Documentos](docs/ACERVO.md) · [Validação](docs/VALIDACAO.md)

</div>

Acervo organizado dos trabalhos de **Laboratório Digital I e II** da Escola Politécnica da USP. Reúne experimentos, código Verilog, testbenches, projetos Quartus, interface Processing e materiais de apresentação.

**Aprender construindo:** especificar um comportamento, dividi-lo em controle e fluxo de dados, simular seus casos de uso e confrontar a implementação com o que acontece no circuito físico.

## Objetivos pedagógicos

| Quem aprende | Objetivo | Evidência de aprendizagem |
| --- | --- | --- |
| Estudante de engenharia | Modelar sistemas síncronos e máquinas de estados | Explicar o estado atual, a transição e as saídas a cada ciclo |
| Estudante de engenharia | Integrar sensores, atuadores e comunicação | Demonstrar a medição, o PWM e um quadro UART válido |
| Estudante de engenharia | Verificar requisitos e depurar falhas | Produzir testes de fronteira e reproduzir um defeito antes da correção |
| Jogador do Math Genius | Exercitar operações aritméticas, atenção e revisão da resposta | Resolver desafios e explicar a estratégia adotada |
| Jogador do Guardião | Praticar seguir sinais, esperar e regular o movimento | Participar de rodadas com regras e feedback compreensíveis |

Os objetivos dos jogos são **intenções de design educacional**. Este acervo não apresenta avaliação clínica ou comprovação de ganho cognitivo. Acessibilidade exige adaptação e avaliação com os participantes, sem presumir necessidades iguais para todas as pessoas com TEA.

## Projetos em destaque

| Projeto | Experiência | Material |
| --- | --- | --- |
| **[Math Genius](projetos/math-genius/README.md)** | Desafios matemáticos com dificuldade selecionável, ROMs e resposta por controles físicos | RTL, guia, documentação e versões históricas |
| **[Guardião do Paredão](projetos/guardiao-do-paredao/README.md)** | Jogo de avançar e parar com sensor de distância, servo, sinalização e telemetria | RTL, Processing, protocolo, testes, relatórios e vídeo |

## Disciplinas e experimentos

- **[LabDig I](labdig-1/README.md):** contadores, comparação, unidade de controle, entradas físicas, jogos sequenciais e memória.
- **[LabDig II](labdig-2/README.md):** PWM, UART, sensor ultrassônico, trena digital e sonar.
- **[Documentos e relatórios](docs/DOCUMENTOS.md):** 31 relatórios revisados para publicação.
- **[Apresentação do acervo](apresentacoes/README.md):** roteiro em slides e versão HTML para exibir no navegador.
- **[Acervo complementar](docs/ACERVO.md):** situação dos relatórios e anexos.

## Executar as verificações

Instale Python 3 e Icarus Verilog (`iverilog` e `vvp` no PATH). No diretório do repositório:

```bash
python scripts/verificar.py
```

O primeiro comando compila treze alvos independentes e executa testes com asserções para conversões, movimento, mensagens ASCII, UART e controle do Guardião. Os resultados de simulação ficam em `build/resultados.json`.

**Limite da validação:** compilação e simulação digital não equivalem a síntese Quartus, fechamento temporal, ensaio elétrico ou execução da interface gráfica. Consulte o [relatório de validação](docs/VALIDACAO.md) antes de usar uma versão em bancada.

## Navegação do código

| Pasta | Uso |
| --- | --- |
| `projetos/` | Cópias de trabalho organizadas de Math Genius e Guardião |
| `labdig-1/` e `labdig-2/` | Guias dos experimentos e alvos de compilação |
| `tests/` | Testes automatizados com critérios explícitos de aprovação |
| `scripts/` | Verificação e integridade do acervo |
| `docs/` | Objetivos, guias, documentos, correções e inventário |
| `apresentacoes/` | Material de exposição do projeto |
| `originais/` | Histórico recuperado, sem aplicar correções aos fontes |

Compile cada projeto separadamente. Consulte a [procedência das implementações](docs/IMPLEMENTACOES.md) para identificar os códigos novos.

Módulos com o mesmo nome pertencem a versões diferentes e não devem entrar juntos em uma única compilação.

## Autoria e contexto

Organização do portfólio: **Luigi Scofano de Araujo · USP 13680334**. Os projetos nasceram em atividades de grupo do Laboratório Digital. Os componentes didáticos mantêm seus cabeçalhos e créditos. As correções e reimplementações desta edição estão documentadas.

Esta publicação contém código, guias e testes. Os [relatórios revisados](docs/DOCUMENTOS.md) preservam o conteúdo técnico e os créditos, com remoção dos dados pessoais de colegas e links privados. [Consulte as substituições](docs/ACERVO.md).
