# PCS3635-T2BA6-relato1.pdf


Versão revisada para consulta pública. A disposição gráfica foi substituída por texto, tabelas e diagramas novos. Dados pessoais de terceiros e referências privadas foram retirados. Os créditos foram preservados.

Relato da experiência 1

Laboratório Digital I - PCS3635

Professor: Reginaldo - Turma 2 

Grupo: 



Luigi Scofano (13680334)



Bancada A6

Experimento: Contador

06/01/2025

——————————————————

Atividade 1:

Foi executado a tabela 3 da apostila:

Teste 1: Foi acionado o RESET de maneira avulsa e não houve o reinício da contagem. Foi constatado que, ao acionar o RESET simultaneamente ao botão B1 (borda de subida do clock do contador), a contagem foi reiniciada, evidenciando o caráter síncrono do reset.

Teste 2: Foi executado o teste conforme o enunciado e o resultado obtido foi como o esperado.

Teste 3: Foi executado o teste conforme o enunciado e o resultado obtido foi como o esperado.

Teste 4:Foi executado o teste conforme o enunciado e o resultado obtido foi como o esperado.

Teste 5: Foi executado o teste conforme o enunciado e o resultado obtido foi como o esperado.

Teste 6: Foi executado o teste conforme o enunciado e o resultado obtido foi como esperado.

Teste 7: Ao apertar CLR(ao mesmo tempo do clock, para garantir a operação, de fato, reset), o contador retorna 0. Em seguida, apertando o botão de clock duas vezes , foi apresentado Q = 0010 (2) e RCO = 0; portanto, o clock foi acionado três vezes durante o teste.

OBS: Se o CLR fosse acionado de maneira isolada (sem a borda de subida do CLK), a contagem não reiniciaria e o resultado seria Q = 0001 e RCO = 0.

Adcionalmente, foi constatado no início do experimento que chave CH1 funciona como o enable do contador. Quando ativada, habilita o funcionamento do contador, permitindo que este altere o estado dos displays de 7 segmentos. O botão B1, por sua vez, incrementa o valor do contador em uma unidade hexadecimal, desde que o enable esteja ativo.

O sistema possui dois displays de 7 segmentos, conectados a linhas de pinos específicas. Quando os fios são desconectados desses pinos, os displays não recebem sinais (nível lógico 0). Contudo, devido à tecnologia TTL (Transistor-Transistor Logic), ocorre uma inversão de nível lógico, e o nível baixo é interpretado como alto. Isso faz com que os displays exibam o caractere F.

Esse comportamento destaca a importância de conexões corretas para a exibição adequada dos valores no contador.

-------------------------------------------------------------------------------------------------------------

Atividade 2:

Foi executado a tabela 6 da apostila:

Teste 1: Foi executado o teste conforme o enunciado e o resultado obtido foi como esperado.

Teste 2: Foi executado o teste conforme o enunciado e o resultado obtido foi como esperado.

Teste 3: Foi executado o teste conforme o enunciado e o resultado obtido foi como esperado.

Teste 4: Foi executado o teste conforme o enunciado e o resultado obtido foi como esperado.

Teste 5: Foi executado o teste conforme o enunciado e o resultado foi coerente com os testes anteriores. O LED que representa que o contador é menor que o display (LD5) fica aceso do 2 ao 8 do contador. Quando o contador chega no 9 o LD5 apaga e o LD6 acende (LED que representa que o valor representado no display é o mesmo do contador).

Teste 6: Foi executado o teste conforme o enunciado e o resultado foi coerente com os testes anteriores. Ao mudar o contador para 1111 (15 em base decimal), o LED LD7 acende, pois ele representa que o valor do contador é maior que o valor representado no display. Além disso, após apertar o CLOCK 6 vezes, o display representa 5, o que é coerente com o LED LD5 passar a acender, pois 5 em decimal é menor que 15 em decimal.

Teste 7: Foi executado o teste conforme o enunciado e o resultado foi coerente com os testes anteriores. Ao desativar o ENT (enable) não há nenhuma mudança de estado no contador e, consequentemente, nada é alterado no comparador.

Teste 8: Foi executado o teste conforme o enunciado e o resultado foi coerente com os testes anteriores. O contador, neste caso, totaliza 11 em decimal (B em hexadecimal) e é comparado com o 9 em decimal (DADO = 1001) e, como consequência, o LD7 acende.









## Diagramas e reprodução desta edição

Consulte os [diagramas explicativos](../DIAGRAMAS.md), os [objetivos pedagógicos](../OBJETIVOS_PEDAGOGICOS.md) e a [validação](../VALIDACAO.md). As figuras originais não foram republicadas. Os novos diagramas e os testes acompanham as implementações organizadas.

## Autoria e créditos

Luigi Scofano de Araujo · USP 13680334.

Créditos de participação constantes do material de origem: Lucas Lacerda, Paulo Henrique Mota de Oliveira.

## Reprodução e figuras desta edição

[Diagramas explicativos](../DIAGRAMAS.md) · [Validação](../VALIDACAO.md) · [Objetivos pedagógicos](../OBJETIVOS_PEDAGOGICOS.md).
