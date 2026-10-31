# Cópia de Cópia de PCS3635-T2BA6-relatorioP1


Versão revisada para consulta pública. A disposição gráfica foi substituída por texto, tabelas e diagramas novos. Dados pessoais de terceiros e referências privadas foram retirados. Os créditos foram preservados.


Introdução

Este relatório documenta a execução das atividades realizadas durante a 1ª semana de projeto da disciplina PCS3635 - Laboratório Digital I, no primeiro quadrimestre de 2025. O objetivo foi modificar e aprimorar o circuito da experiência 7 de modo a desenvolver um jogo que auxilie em algum aspecto didático ou social de crianças diagnosticadas com transtorno de TEA.

O jogo será desenvolvido em Verilog, utilizando conceitos fundamentais de sistemas digitais, como contadores, registradores e comparadores. A FPGA será programada para controlar a lógica do jogo, assegurando que cada rodada ocorra conforme especificado. Esse planejamento inclui a definição dos componentes necessários, as interações entre eles e os critérios de teste para validar o funcionamento correto do jogo.

Descrição do Projeto

O jogo consiste em um quiz matemático básico para crianças em torno de 6 a 8 anos que visa auxiliar na sua alfabetização matemática. O modo de operação do brinquedo segue a seguinte descrição:

O jogador escolhe um dos quatro modos de jogo: Jogo da Adição, Jogo da Subtração, Jogo da Multiplicação ou jogo da Divisão. Após a seleção do modo de jogo, o brinquedo vai propor uma sequência de operações para que o usuário selecione o resultado correto de modo que, para vencer o jogo, seja necessário que o usuário acerte todas as operações propostas.

O jogo conta com diversos estímulos sensoriais, como buzzers e leds que pretendem incentivar a memória visual e auditiva da criança, de modo a maximizar seu aprendizado.

Detalhamento do Projeto Lógico

Este capítulo do relatório tem a finalidade de descrever detalhes do projeto lógico desenvolvido na presente experiência.

Projeto do Fluxo de Dados

Detalhar o projeto do fluxo de dados.

O Fluxo de dados pode ser descrito em duas partes: 

Contador e Comparador para controle do limite de cada sequência da rodada.

Dois registradores, contador, quatro memórias ROM, comparador e Timer que controlam o funcionamento de cada uma das rodadas.

Módulo de contas que realiza as operações do jogo.

2.2 Projeto da Unidade de Controle

O projeto da unidade de controle ainda é provisório, ao longo da semana 1 ainda serão feitas algumas análises para definição, de fato, da UC a ser utilizada. Portanto o preenchimento da tabela a seguir será realizado na semana que vem.

| Nome do Estado | Descrição do Estado | Próximo Estado | Condições e Justificativas para a Transição entre Estados |
| --- | --- | --- | --- |
|  |  |  |  |
|  |  |  |  |

Projeto do Sistema Digital

A integração entre fluxo de dados e unidade de controle ocorre por meio de sinais de controle e condição, garantindo a sincronização do jogo. O sistema é projetado para operar de maneira eficiente, minimizando atrasos e evitando conflitos de sinalização.

Os componentes digitais devem ser implementados com base em práticas otimizadas de projeto digital. A arquitetura modular possibilita a reutilização de partes do circuito em futuras versões do jogo. Essa abordagem também permite a depuração facilitada e a execução de testes de forma independente.

Atividade da semana 1 - Desenvolvimento de um módulo de contas

As operações matemáticas que o usuário deve realizar também são realizadas por um módulo dentro do brinquedo que fornece um output usado como gabarito do resultado expresso pelo jogador. 







## Diagramas e reprodução desta edição

Consulte os [diagramas explicativos](../DIAGRAMAS.md), os [objetivos pedagógicos](../OBJETIVOS_PEDAGOGICOS.md) e a [validação](../VALIDACAO.md). As figuras originais não foram republicadas. Os novos diagramas e os testes acompanham as implementações organizadas.

## Autoria e créditos

Luigi Scofano de Araujo · USP 13680334.

Créditos de participação constantes do material de origem: Lucas Lacerda, Paulo Henrique Mota de Oliveira.

## Reprodução e figuras desta edição

[Diagramas explicativos](../DIAGRAMAS.md) · [Validação](../VALIDACAO.md) · [Objetivos pedagógicos](../OBJETIVOS_PEDAGOGICOS.md).
