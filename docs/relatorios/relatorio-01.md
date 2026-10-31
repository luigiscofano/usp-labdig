# PCS3645-T5BA6-relato1


Versão revisada para consulta pública. A disposição gráfica foi substituída por texto, tabelas e diagramas novos. Dados pessoais de terceiros e referências privadas foram retirados. Os créditos foram preservados.

Relato da experiência 1

Laboratório Digital II - PCS3645

Professor: Reginaldo - Turma 5 

Grupo: 



Luigi Scofano (13680334)



Bancada A6

Experimento: Controle de um Servo Motor

01/09/2025

——————————————————

Nosso grupo da bancada A6 iniciou a exploração do projeto partindo da leitura do material teórico sobre servomotores e sinais PWM. A partir dessa base, entendemos que o controle de posição do servo depende da largura do pulso enviado em um sinal periódico de 20 ms, variando tipicamente entre 1 ms e 2 ms para definir ângulos de 0° a 180°. Revisamos também a noção de duty cycle, que representa a razão entre o tempo em nível lógico alto e o período do sinal, sendo fundamental para o controle de intensidade em LEDs e de posição em servos.

Na etapa prática, abrimos o Quartus e configuramos o ambiente para simular o circuito responsável pela geração do PWM. Com isso, revisamos conceitos de laboratório digital que já havíamos trabalhado em projetos anteriores, como a definição de clocks, resets e entradas de controle. A simulação nos permitiu visualizar claramente os sinais variando no tempo, identificando como o parâmetro de largura de pulso influencia diretamente na saída pwm_out. Essa visualização foi essencial para reforçar a relação entre teoria e prática.

Durante a análise dos sinais no simulador, conseguimos perceber a formação das ondas PWM em diferentes larguras, observando os efeitos e comparando com os exemplos do material de apoio. Esse processo nos ajudou a relembrar a lógica por trás do Quartus, incluindo a forma de interpretar os diagramas de tempo e os resultados das simulações. Assim, consolidamos o entendimento de como o circuito gera os pulsos necessários para controlar corretamente o servomotor e avançamos na familiarização com o ambiente de desenvolvimento.

No começo dos testes, percebemos que havia um erro nos parâmetros do PWM. Por causa disso, o servomotor não ficava parado em uma posição fixa, mas mantinha a hélice girando sem parar. Esse erro mostrou como detalhes pequenos na configuração podem mudar totalmente o comportamento do circuito.

Depois, corrigimos os valores de entrada para que os pulsos ficassem dentro da faixa certa, entre. Com isso, o servo passou a responder corretamente, parando em posições definidas em vez de girar continuamente.

Por fim, testamos tudo novamente usando o Analog Discovery e o ModelSim. Assim conseguimos ver as formas de onda do PWM e confirmar que o sinal estava estável. Esses testes nos deram certeza de que o circuito estava funcionando da forma correta.

No fim, conseguimos consertar a configuração e a hélice passou a funcionar corretamente, parando nas posições fixas como esperado. Fizemos todos os testes novamente tanto no ModelSim quanto no Analog Discovery, e confirmamos que agora o sinal PWM está estável e o circuito está funcionando sem problemas. Tudo certo com o projeto.












## Diagramas e reprodução desta edição

Consulte os [diagramas explicativos](../DIAGRAMAS.md), os [objetivos pedagógicos](../OBJETIVOS_PEDAGOGICOS.md) e a [validação](../VALIDACAO.md). As figuras originais não foram republicadas. Os novos diagramas e os testes acompanham as implementações organizadas.

## Autoria e créditos

Luigi Scofano de Araujo · USP 13680334.

Créditos de participação constantes do material de origem: Lucas Lacerda, Paulo Henrique Mota de Oliveira.

## Reprodução e figuras desta edição

[Diagramas explicativos](../DIAGRAMAS.md) · [Validação](../VALIDACAO.md) · [Objetivos pedagógicos](../OBJETIVOS_PEDAGOGICOS.md).
