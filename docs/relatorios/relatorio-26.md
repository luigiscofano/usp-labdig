# Tabela


Versão revisada para consulta pública. A disposição gráfica foi substituída por texto, tabelas e diagramas novos. Dados pessoais de terceiros e referências privadas foram retirados. Os créditos foram preservados.

| Sinal |  Pino na Placa DE0-CV | Pino no FPGA | Analog Discovery |
| --- | --- | --- | --- |
| CLOCK | GPIO_1_D0 | H16 | DIO 15 |
| addU | GPIO_1_D1 | A12 | DIO 8 |
| addD | GPIO_1_D3 | B12 | DIO 9 |
| addC | GPIO_1_D5 | B13 | DIO 10 |
| subU | GPIO_1_D7 | D13 | DIO 0 |
| subD | GPIO_1_D9 | G17 | DIO 1 |
| subC | GPIO_1_D11 | J18 | DIO 2 |
| enter | GPIO_1_D13 | G11 | DIO 7 |
| jogar | GPIO_1_D15 | J11 | DIO 6 |
| reset | GPIO_1_D17 | A15 | DIO 14 |
| dif_input | switch 0 | U13 |  |
| dif_input | switch 1 | V13 |  |
| acertoJog | LED R0 | AA2 |  |
| db_fim | LED R1 | AA1 |  |
| resposta (dígito 0) | HEX 30 | Y16 |  |
| resposta (dígito 0) | HEX 31 | W16 |  |
| resposta (dígito 0) | HEX 32 | Y17 |  |
| resposta (dígito 0) | HEX 33 | V16 |  |
| resposta (dígito 0) | HEX 34 | U17 |  |
| resposta (dígito 0) | HEX 35 | V18 |  |
| resposta (dígito 0) | HEX 36 | V19 |  |
| resposta (dígito 1) | HEX 40 | U20 |  |
| resposta (dígito 1) | HEX 41 | Y20 |  |
| resposta (dígito 1) | HEX 42 | V20 |  |
| resposta (dígito 1) | HEX 43 | U16 |  |
| resposta (dígito 1) | HEX 44 | U15 |  |
| resposta (dígito 1) | HEX 45 | Y15 |  |
| resposta (dígito 1) | HEX 46 | P9 |  |
| resposta (dígito 2) | HEX 50 | N9 |  |
| resposta (dígito 2) | HEX 51 | M8 |  |
| resposta (dígito 2) | HEX 52 | T14 |  |
| resposta (dígito 2) | HEX 53 | P14 |  |
| resposta (dígito 2) | HEX 54 | C1 |  |
| resposta (dígito 2) | HEX 55 | C2 |  |
| resposta (dígito 2) | HEX 56 | W19 |  |
| db_ESTADO | HEX 20 | Y19 // C15 |  |
| db_ESTADO | HEX 21 | AB17 // E15 |  |
| db_ESTADO | HEX 22 | AA10 // F14 |  |
| db_ESTADO | HEX 23 | Y14 //  F13 |  |
| db_ESTADO | HEX 24 | V14 // G16 |  |
| db_ESTADO | HEX 25 | AB22 // G13 |  |
| db_ESTADO | HEX 26 | AB21 // J17 |  |
| contagem_acertos  / (dígito 0) | HEX 00 | U21 |  |
| contagem_acertos  / (dígito 0) | HEX 01 | V21 |  |
| contagem_acertos  / (dígito 0) | HEX 02 | W22 |  |
| contagem_acertos  / (dígito 0) | HEX 03 | W21 |  |
| contagem_acertos  / (dígito 0) | HEX 04 | Y22 |  |
| contagem_acertos  / (dígito 0) | HEX 05 | Y21 |  |
| contagem_acertos  / (dígito 0) | HEX 06 | AA22 |  |
| contagem_acertos  / (dígito 1) | HEX 10 | AA20 |  |
| contagem_acertos  / (dígito 1) | HEX 11 | AB20 |  |
| contagem_acertos  / (dígito 1) | HEX 12 | AA19 |  |
| contagem_acertos  / (dígito 1) | HEX 13 | AA18 |  |
| contagem_acertos  / (dígito 1) | HEX 14 | AB18 |  |
| contagem_acertos  / (dígito 1) | HEX 15 | AA17 |  |
| contagem_acertos  / (dígito 1) | HEX 16 | U22 |  |
| DP (controla o ponto, =0) | GPIO_0_D35 | T15 |  |
| Ds(1) | GPIO_0_D28 | R15 |  |
| Ds(2) | GPIO_0_D30 | R16 |  |
| Ds(3) | GPIO_0_D32 | T19 |  |
| Ds(4) | GPIO_0_D34 | T17 |  |
| Caixa1 | GPIO_0_D0 #G | N16 |  |
| Caixa1 | GPIO_0_D2 #F | M16 |  |
| Caixa1 | GPIO_0_D4 #E | D17 |  |
| Caixa1 | GPIO_0_D6 #D | K21 |  |
| Caixa1 | GPIO_0_D8 #C | M20 |  |
| Caixa1 | GPIO_0_D10 #B | N21 |  |
| Caixa1 | GPIO_0_D12 #A | R21 |  |
| Caixa 2 | GPIO_0_D1 | B16 |  |
| Caixa 2 | GPIO_0_D3 | C16 |  |
| Caixa 2 | GPIO_0_D5 C | K20 |  |
| Caixa 2 | GPIO_0_D7 | K22 |  |
| Caixa 2 | GPIO_0_D9 C | M21 |  |
| Caixa 2 | GPIO_0_D11 | R22 |  |
| Caixa 2 | GPIO_0_D13 | T22 |  |
| o_ledacerto | GPIO_0_D31 | T20 |  |
| o_lederro | GPIO_0_D33 | T18 |  |


## Diagramas e reprodução desta edição

Consulte os [diagramas explicativos](../DIAGRAMAS.md), os [objetivos pedagógicos](../OBJETIVOS_PEDAGOGICOS.md) e a [validação](../VALIDACAO.md). As figuras originais não foram republicadas. Os novos diagramas e os testes acompanham as implementações organizadas.

## Autoria e créditos

Luigi Scofano de Araujo · USP 13680334.

## Reprodução e figuras desta edição

[Diagramas explicativos](../DIAGRAMAS.md) · [Validação](../VALIDACAO.md) · [Objetivos pedagógicos](../OBJETIVOS_PEDAGOGICOS.md).
