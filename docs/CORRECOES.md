# Correções da edição organizada

As versões recuperadas foram mantidas no acervo de preparação, que ainda não integra esta publicação. As alterações abaixo se aplicam às cópias de trabalho.

- `projetos/guardiao-do-paredao/rtl/guardiao/guardiao.v`: Declara explicitamente o pulso de início.
- `projetos/guardiao-do-paredao/rtl/transmissor/mux_char.v`: Preserva os dois bits de estado, incluindo derrota (10).
- `projetos/guardiao-do-paredao/rtl/transmissor/tratar_tx_dados_fd.v`: Propaga reset ao transmissor UART para inicialização determinística.
- `projetos/guardiao-do-paredao/rtl/transmissor/serial_tx_7e1.v`: Corrige paridade par: XOR dos dados, sem inversão.
- `projetos/guardiao-do-paredao/rtl/transmissor/serial_tx_7e1.v`: Atualiza comentário da paridade.
- `projetos/guardiao-do-paredao/rtl/move_detection.v`: Calcula magnitude da diferença em binário antes de codificar BCD.
- `projetos/guardiao-do-paredao/rtl/move_detection.v`: Envia diferença em BCD ao formatador ASCII e mantém limiar em centímetros.
- `projetos/math-genius/rtl/MathGenius.v`: Declara barramentos que antes viravam fios implícitos de um bit.
- `projetos/math-genius/rtl/MathGenius.v`: Conecta operando A ao display.
- `projetos/math-genius/rtl/MathGenius.v`: Conecta operando B ao display.
- `projetos/math-genius/rtl/MathGenius.v`: Expande contador de seis para oito bits explicitamente.
- `projetos/math-genius/rtl/MathGenius.v`: Corrige diferença de maiúsculas no sinal do display do operador.
- `projetos/math-genius/rtl/MathGenius.v`: Expande estado para a largura de entrada do decodificador.

As correções de compilação e os testes de componentes não substituem síntese, análise temporal e ensaio da montagem física.

## Correções adicionais verificadas

- `controle_servo`: adaptação dos nomes de parâmetros e da largura de seleção ao PWM recuperado.
- `MathGenius`: operandos ligados aos displays, resposta com oito bits, extensão explícita dos barramentos de visualização e correção do nome `dispOP`.
- `medidor_distancia_fd`: o registrador de medida final passa a ser limpo pelo reset do sistema. A limpeza da média não pode apagar imediatamente o resultado concluído. O teste integrado do sonar reproduziu a falha anterior, que transmitia zero.
- Processing: importação explícita de `processing.serial.Serial` para evitar ambiguidade com `java.io.Serial` em Java 17.
- Processing: critério de vitória alinhado ao RTL (distância menor que 20 cm) e prioridade de derrota quando há movimento inválido.

As correções não foram aplicadas aos originais. As novas implementações são descritas em [IMPLEMENTACOES.md](IMPLEMENTACOES.md).
