# Semana0.2_T2BA6_Spec


Versão revisada para consulta pública. A disposição gráfica foi substituída por texto, tabelas e diagramas novos. Dados pessoais de terceiros e referências privadas foram retirados. Os créditos foram preservados.


Introdução

	Nessa atividade foi realizada a definição de requisitos e a descrição do mesmo para o projeto.

================================================================

Relato da Atividade Extensionista

Tabela 1 – Relato da Atividade Extensionista

| Relato da Atividade e de seus Resultados |
| --- |
| 	Para o nosso projeto, foi pensado em dois requisitos não funcionais como guias para o planejamento: ensino de operações matemáticas por uma forma gamificada, e o uso de estímulos sonoros para  estimular o acerto das operações. A partir disso, o maior desafio apresentado foi em como será feita a interação do usuário com a FPGA para números de mais de um dígito. Inicialmente a ideia foi de utilizar um teclado numérico, entretanto, a ideia foi logo advertida pelo professor como difícil de ser implementada, dada a imprevisibilidade de mapeamento de cada teclado. Então, a ideia que predominou foi de utilizar uma forma de joystick que possa aumentar ou diminuir o número a ser enviado para FPGA. Embora seja uma forma difícil de utilização, foi entendido que seria uma boa proposta, dado o caráter de Minimal Viable Product do projeto e o curto prazo de desenvolvimento. |
| Lista de Referências (se aplicável; caso contrário, marcar como “Não Aplicável”) |
| Não aplicável |

| Código: INPUT | ☑ Funcional         ◻ Não Funcional |
| --- | --- |
| Requisito: Forma de colocar entrada | Requisito: Forma de colocar entrada |
| Descrição: O sistema deve ter algum tipo de lógica de teclado com o qual o usuário vai interagir para digitar o resultado. | Descrição: O sistema deve ter algum tipo de lógica de teclado com o qual o usuário vai interagir para digitar o resultado. |
| Prioridade:          ☑ Alta           ◻ Média           ◻ Baixa | Prioridade:          ☑ Alta           ◻ Média           ◻ Baixa |
| Estabilidade:      ◻ Alta           ☑ Média           ◻ Baixa | Estabilidade:      ◻ Alta           ☑ Média           ◻ Baixa |
| Rationale:  Possibilitar a interação do usuário com o jogo. | Rationale:  Possibilitar a interação do usuário com o jogo. |
| Requisitos associados:  | Requisitos associados:  |

| Código: NÍVEL | ☑Funcional         ◻Não Funcional |
| --- | --- |
| Requisito: Presença de vários níveis | Requisito: Presença de vários níveis |
| Descrição: O sistema deve ter possibilidades de diferentes níveis para o usuário escolher, da mais fácil até a mais difícil, podendo envolver diferentes operações. | Descrição: O sistema deve ter possibilidades de diferentes níveis para o usuário escolher, da mais fácil até a mais difícil, podendo envolver diferentes operações. |
| Prioridade:          ◻ Alta           ☑ Média           ◻ Baixa | Prioridade:          ◻ Alta           ☑ Média           ◻ Baixa |
| Estabilidade:      ◻ Alta           ☑ Média           ◻ Baixa | Estabilidade:      ◻ Alta           ☑ Média           ◻ Baixa |
| Rationale: Como cada usuário terá um diferente nível de habilidade e conforto na realização de operações matemáticas, deve-se ter a possibilidade de escolher o nível de dificuldade. | Rationale: Como cada usuário terá um diferente nível de habilidade e conforto na realização de operações matemáticas, deve-se ter a possibilidade de escolher o nível de dificuldade. |
| Requisitos associados: OPERAÇÕES | Requisitos associados: OPERAÇÕES |

| Código: OPERAÇÕES | ☑ Funcional         ◻Não Funcional |
| --- | --- |
| Requisito: Possibilidade de realizar adição, subtração, divisão e multiplicação. | Requisito: Possibilidade de realizar adição, subtração, divisão e multiplicação. |
| Descrição: O sistema deve ter diferentes operações que podem ser realizadas.  | Descrição: O sistema deve ter diferentes operações que podem ser realizadas.  |
| Prioridade:          ☑ Alta           ◻ Média           ◻ Baixa | Prioridade:          ☑ Alta           ◻ Média           ◻ Baixa |
| Estabilidade:      ◻Alta           ☑ Média           ◻ Baixa | Estabilidade:      ◻Alta           ☑ Média           ◻ Baixa |
| Rationale: Como cada usuário terá um diferente nível de habilidade e conforto na realização de operações matemáticas, deve-se ter a possibilidade de escolher os tipos de operação dependendo do conhecimento do mesmo. | Rationale: Como cada usuário terá um diferente nível de habilidade e conforto na realização de operações matemáticas, deve-se ter a possibilidade de escolher os tipos de operação dependendo do conhecimento do mesmo. |
| Requisitos associados: NÍVEL | Requisitos associados: NÍVEL |

| Código: LED_OPER | ◻ Funcional         ☑ Não Funcional |
| --- | --- |
| Requisito: Led que indica operação | Requisito: Led que indica operação |
| Descrição: O sistema deve ter um led que mostra qual operação sendo realizada. | Descrição: O sistema deve ter um led que mostra qual operação sendo realizada. |
| Prioridade:          ☑ Alta           ◻ Média           ◻ Baixa | Prioridade:          ☑ Alta           ◻ Média           ◻ Baixa |
| Estabilidade:      ☑ Alta           ◻ Média           ◻ Baixa | Estabilidade:      ☑ Alta           ◻ Média           ◻ Baixa |
| Rationale: É necessário um indicador de qual operação está sendo realizada para que o usuário possa entender o que está fazendo. | Rationale: É necessário um indicador de qual operação está sendo realizada para que o usuário possa entender o que está fazendo. |
| Requisitos associados: OPERAÇÕES | Requisitos associados: OPERAÇÕES |

| Código: BAIXA_LAT | ◻Funcional         ☑ Não Funcional |
| --- | --- |
| Requisito: Baixa latência | Requisito: Baixa latência |
| Descrição: Sistema deve ter baixa latência | Descrição: Sistema deve ter baixa latência |
| Prioridade:          ◻ Alta           ◻ Média           ◻ Baixa | Prioridade:          ◻ Alta           ◻ Média           ◻ Baixa |
| Estabilidade:      ◻ Alta           ◻ Média           ◻ Baixa | Estabilidade:      ◻ Alta           ◻ Média           ◻ Baixa |
| Rationale: Para manter o jogador constantemente intrigado pelo jogo, a baixa latência é necessária para que mantenha uma jogabilidade fluida e rápida. | Rationale: Para manter o jogador constantemente intrigado pelo jogo, a baixa latência é necessária para que mantenha uma jogabilidade fluida e rápida. |
| Requisitos associados:  | Requisitos associados:  |

| Código: BUZZER | ◻Funcional         ☑ Não Funcional |
| --- | --- |
| Requisito: Estímulo sonoro em acertos | Requisito: Estímulo sonoro em acertos |
| Descrição: Sistema deve ter um buzzer que possa comunicar acerto. | Descrição: Sistema deve ter um buzzer que possa comunicar acerto. |
| Prioridade:          ☑ Alta           ◻ Média           ◻ Baixa | Prioridade:          ☑ Alta           ◻ Média           ◻ Baixa |
| Estabilidade:      ◻ Alta           ◻ Média           ☑ Baixa | Estabilidade:      ◻ Alta           ◻ Média           ☑ Baixa |
| Rationale: O aspecto sensorial permite engajar mais facilmente jogadores com TEA. | Rationale: O aspecto sensorial permite engajar mais facilmente jogadores com TEA. |
| Requisitos associados:  | Requisitos associados:  |

| Código: REPET | ◻Funcional         ☑ Não Funcional |
| --- | --- |
| Requisito: Repetição de operações  | Requisito: Repetição de operações  |
| Descrição: Sistema deve repetir algumas das operações ocasionalmente | Descrição: Sistema deve repetir algumas das operações ocasionalmente |
| Prioridade:          ◻Alta           ◻ Média           ☑ Baixa | Prioridade:          ◻Alta           ◻ Média           ☑ Baixa |
| Estabilidade:      ◻ Alta           ◻ Média           ☑ Baixa | Estabilidade:      ◻ Alta           ◻ Média           ☑ Baixa |
| Rationale: A repetição de operações pode facilitar a aprendizagem de contas matemáticas, permitindo que o jogador fique cada vez mais rápido em raciociná-las. | Rationale: A repetição de operações pode facilitar a aprendizagem de contas matemáticas, permitindo que o jogador fique cada vez mais rápido em raciociná-las. |
| Requisitos associados:  | Requisitos associados:  |

================================================================

## Autoria e créditos

Luigi Scofano de Araujo · USP 13680334.

Créditos de participação constantes do material de origem: Lucas Lacerda, Paulo Henrique Mota de Oliveira.

## Reprodução e figuras desta edição

[Diagramas explicativos](../DIAGRAMAS.md) · [Validação](../VALIDACAO.md) · [Objetivos pedagógicos](../OBJETIVOS_PEDAGOGICOS.md).
