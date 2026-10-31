# PCS3645-T5BA7-P1


Versão revisada para consulta pública. A disposição gráfica foi substituída por texto, tabelas e diagramas novos. Dados pessoais de terceiros e referências privadas foram retirados. Os créditos foram preservados.


Atividade 1) Síntese, montagem e teste do circuito.

A primeira questão consistiu na síntese e montagem física do projeto na FPGA. O projeto funcionou conforme o previsto e o professor realizou as verificações cabíveis. Após a verificação inicial, dois pontos foram levantados para uma arguição mais detalhada:

Mostrar como o circuito processa o sinal echo do sensor HC-SR04 para obtenção da medida em cm:

Esse procedimento consiste em medir a largura do pulso de echo devolvido pelo sensor à FPGA e dividindo o valor por 58,82, convertendo a medição para a distância em cm.

Explique a função do circuito integrado MAX3232.

Esse circuito é responsável por converter a tensão do sinal de transmissão serial emitido pela FPGA (3,3V) para a tensão ideal a ser recebida pelo computador.

Atividade 2) Monitoramento de sinais.

A segunda questão consistiu na deburação dos sinais relacionados à transmissão serial da FPGA para o computador. Os dois principais aspectos solicitados na hora da prova eram:

Forma de onda do sinal de transmissão serial

Sinal que aponta o fim da transmissão para o computador.

Os sinais solicitados podem ser observados na imagem a seguir em que o canal 1 (laranja) representa a transmissão serial e o canal 2 (azul) representa o final da transmissão serial. O canal dois apresenta um pouco de ruído mas é perceptível que ao final da onda laranja o valor do canal dois atinge em torno de 3,1V, indicando o fim da transmissão. Isso ocorre porque a placa FPGA trabalha na ordem de 3,3V.

Atividade 3) Projeto Lógico da Modificação.

A terceira questão consistiu no desenvolvimento de uma modificação denominada modo de proximidade cujo funcionamento está descrito no enunciado da prova. Para atender a todos os requisitos foram pensadas as seguintes modificações:

Unidade de Controle

Inserção de um sinal en_proximidade que vai permitir com que o módulo emite_proximidade (explicado no campo do fluxo de dados) transmita os caracteres “+”, ”-” ou ”*”. O en_proximidade seria enviado mais especificamente no estado “TRANSMITIR”  onde já existiria um valor numérico para a medida do sensor e, na sequência, o sinal seria transmitido.

Nota 1) O sinal en_proximidade corresponde a uma chave física na FPGA que só seria passado adiante para o FD no estado “TRANSMITIR”, a fim de evitar mal funcionamento caso ele seja acionado em momentos inoportunos na máquina de estados. Se o sinal passado no estado “TRANSMITIR” for “ 1 o enable permite que a transmissão do caractere adicional ocorra, caso contrário ele impede a transmissão do caractere adicional.

Nota 2) Posteriormente seria ideal mudar o nome desse estado para algo do tipo “preparar_transmissão” onde ele ficasse em ciclo nesse estado enquanto o módulo do emite_proximidade não terminou a sua operção. Essa Modificação pode vir a ser necessária a depender da lógica implementada no módulo emite_proximidade.

Fluxo de dados

A maior modificação do fluxo de dados consiste na criação de um módulo emite_proximidade que, dados dois inputs en_proximidade e medida, transmite o respectivo caractere desejado em ASCII para o módulo que realiza a transmissão serial. Se o enable estiver desativado o módulo corta a transmissão para o transmissor serial.









## Diagramas e reprodução desta edição

Consulte os [diagramas explicativos](../DIAGRAMAS.md), os [objetivos pedagógicos](../OBJETIVOS_PEDAGOGICOS.md) e a [validação](../VALIDACAO.md). As figuras originais não foram republicadas. Os novos diagramas e os testes acompanham as implementações organizadas.

## Autoria e créditos

Luigi Scofano de Araujo · USP 13680334.

Créditos de participação constantes do material de origem: Paulo Henrique Mota de Oliveira.

## Reprodução e figuras desta edição

[Diagramas explicativos](../DIAGRAMAS.md) · [Validação](../VALIDACAO.md) · [Objetivos pedagógicos](../OBJETIVOS_PEDAGOGICOS.md).
