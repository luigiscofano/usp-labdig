# Componentes compartilhados

`rtl/telemetria_ascii.v` formata e transmite medidas em ASCII usando a UART recuperada do Guardião. Com `COM_ANGULO=0`, envia `ddd#`. Com `COM_ANGULO=1`, envia `aaa,ddd#`.

O módulo captura os dados no início do pacote para impedir que uma mudança de entrada altere uma mensagem em andamento. `pronto=1` significa que aceita uma nova solicitação. A UART tem sua própria confirmação de ocupado e de fim de caractere.

**Objetivo pedagógico:** entender a diferença entre uma informação disponível no circuito e uma mensagem consistente transmitida ao longo de vários ciclos. O teste `tb_telemetria` altera a entrada durante a transmissão para verificar essa propriedade.
