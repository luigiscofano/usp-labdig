# Protocolo de comunicação

O formatador da versão selecionada envia 12 caracteres ASCII de 7 bits:

```text
m,ppp,vvv,f#
```

| Campo | Significado |
| --- | --- |
| `m` | `E` para indicação de movimento ou `O` para indicação de parada, conforme interpretação do sketch |
| `ppp` | Posição decimal, três dígitos em centímetros |
| `vvv` | Magnitude da diferença de posição, três dígitos |
| `f` | `J` jogando, `G` ganhou, `P` perdeu |
| `#` | Terminador |

Exemplo: `E,123,045,J#`. A UART usa start baixo, sete bits LSB-first, paridade par e um stop alto. A transmissão nominal é 115200 bauds para clock de 50 MHz.

## Limites da revisão

A documentação histórica discute uma variação com sinal. O RTL selecionado transmite a magnitude absoluta, sem campo de sinal. Portanto, ele não permite deduzir sozinho o sentido do deslocamento pelo campo `vvv`. A correspondência temporal entre `E`/`O`, LED, postura e momento da aquisição precisa ser confirmada em teste de integração: nomes internos como `TX_FIM_MOV` não devem ser usados isoladamente como especificação do significado recebido.

O teste `tb_componentes` verifica todos os caracteres para os quatro códigos de estado. `tb_uart` verifica os 128 valores de sete bits, paridade, stop e reset. A paridade par foi corrigida em relação ao original.
