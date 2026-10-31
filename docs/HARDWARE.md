# Reprodução em bancada

## Ferramentas e arquivos

- Quartus Prime com suporte à FPGA da DE0-CV.
- ModelSim/Questa ou Icarus Verilog para simulação.
- Processing em modo Java para a interface do Guardião.
- Placa, fonte, sensor HC-SR04, servo e circuito de comunicação conforme a montagem documentada.

Os QARs preservam projetos históricos completos. Restaure cada arquivo em uma pasta vazia. As versões podem conter top-level, parâmetros e pinagem diferentes. A edição organizada não gera automaticamente um QSF unificado, pois o material contém experimentos e revisões distintos.

## Sequência de reprodução

1. Selecionar a experiência ou projeto e ler seu relatório.
2. Restaurar o QAR e conferir o dispositivo e o top-level no Quartus.
3. Conferir cada pino no manual da DE0-CV e no relatório escolhido.
4. Comparar os fontes restaurados com a cópia organizada antes de aplicar correções.
5. Executar análise, síntese e análise temporal.
6. Conferir alimentação, terra comum e adaptação de níveis antes de conectar periféricos.
7. Programar a placa e testar cada periférico isoladamente.
8. Integrar o jogo e registrar resultados e falhas observadas.

## Interfaces elétricas

Não conecte diretamente um sinal de nível incompatível ao GPIO. O relatório do HC-SR04 discute alimentação de 5 V e interface com a FPGA. Confira a tensão real de echo e a adaptação de nível prevista para sua montagem. Uma UART lógica e uma porta RS-232 não têm os mesmos níveis elétricos. O circuito MAX3232 aparece nos materiais como adaptação para a comunicação utilizada no laboratório.

O servo deve usar alimentação adequada à corrente do dispositivo. Confira sua especificação e o compartilhamento de referência de terra. Os valores de PWM são parâmetros da versão selecionada e não comprovam calibração mecânica de um servo específico.

## Evidências que ainda precisam ser registradas

- Relatório de síntese e dispositivo correto.
- Resultado de timing para o clock e restrições efetivamente utilizados.
- Medições de período e largura de PWM.
- Distância medida comparada a uma referência.
- Captura de quadro UART no equipamento.
- Vídeo da edição corrigida em execução.

O vídeo histórico preservado demonstra a montagem registrada pelo grupo, não a validação física das correções desta edição.

## Projeto Quartus portátil desta edição

Execute `quartus_sh -t scripts/gerar_quartus.tcl guardiao` a partir da raiz. O script aceita os treze alvos descritos em seu cabeçalho, reúne as dependências e cria QPF, QSF e uma restrição básica de clock de 50 MHz em `build/quartus/`. A pinagem e as restrições de E/S devem ser conferidas para a montagem escolhida. O script não foi executado no Quartus nesta sessão.
