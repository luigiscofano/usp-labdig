# PCS3635-T2BA6-RelatoGeral


Versão revisada para consulta pública. A disposição gráfica foi substituída por texto, tabelas e diagramas novos. Dados pessoais de terceiros e referências privadas foram retirados. Os créditos foram preservados.


1. INTRODUÇÃO

O Projeto Math Genius tem como objetivo desenvolver um serious game focado em crianças com Transtorno do Espectro Autista (TEA), utilizando tecnologia digital para estimular capacidades cognitivas como foco, memória, coordenação motora e velocidade de raciocínio. O sistema proposto consiste em uma interface lúdica e interativa que oferece desafios baseados em sequências de operações matemáticas, que devem ser resolvidas corretamente pelos usuários.

A proposta do jogo é evolutiva: à medida que a criança apresenta melhor desempenho, a dificuldade aumenta progressivamente. Por isso, uma parte essencial do projeto é a implementação de um sistema que permita selecionar a dificuldade do jogo de forma controlada e segura, o que evita alterações abruptas e garante uma experiência de aprendizado consistente. Além disso, o jogo também visa permitir coleta de dados relevantes sobre o desempenho do usuário para análise futura por terapeutas e educadores.

2. CRONOGRAMA

| Semana | Frente de Trabalho | Atividade |
| --- | --- | --- |
| Semana 1 | Definição do Projeto | Levantamento de requisitos, definição da proposta pedagógica e divisão modular do sistema. |
| Semana 2 | Sistema Digital | Implementação do registrador de dificuldade e estrutura com múltiplas ROMs. |
| Semana 2 | Interface e Comunicação | Planejamento da comunicação serial e dos canais de coleta de dados via UART. |
| Semana 2 | Testes e Simulações | Simulações com diferentes níveis de dificuldade e verificação da transição de dados. |
| Semana 3 | Integração da Interface com o Jogo | Conexão entre registrador de resposta e displays de sete segmentos; controle de fluxo. |
| Semana 3 | Coleta de Dados | Implementação de saída serial com pyserial para geração de logs de desempenho. |
| Semana 4 | Consolidação | Testes completos de usabilidade e feedback com usuários; preparação da entrega final. |

3. DESCRIÇÃO DO PROJETO

3.1 Fluxo de Dados (FD)

O Fluxo de Dados (FD) do projeto Math Genius é o núcleo que processa as operações matemáticas, seleciona os dados das ROMs, recebe a entrada do jogador e valida a resposta. O FD foi modelado modularmente e é composto por blocos como:

Detectores de borda para captar os pulsos dos botões físicos (addC, addD, addU, subC, subD, subU);

InputControl, responsável por codificar os botões pressionados em um valor de 8 bits que representa a resposta do usuário;

Registrador de Resposta, que armazena essa resposta temporariamente;

Contador de endereços, que define qual operação da ROM está sendo acessada;

ROMs, contendo as operações pré-definidas com operandos e operadores separados;

Operador e comparador, que processam a operação e verificam se a resposta inserida pelo jogador é correta.

A imagem abaixo ilustra o diagrama interno do FD:

3.2 Unidade de Controle (UC)

A Unidade de Controle (UC) é a responsável por coordenar todo o sistema, decidindo em qual momento cada bloco do FD deve atuar. Ela é baseada em uma Máquina de Estados Finitos (FSM), que transita por estados como:

inicial – sistema parado aguardando início;

prep – preparação para nova rodada;

mostra_eq – apresentação da equação;

espera – aguarda resposta do jogador;

salvaJog – armazena resposta inserida;

comparacao – compara a resposta com o valor esperado;

addAcerto – incrementa acertos se a resposta estiver correta;

prepProx – prepara para próxima rodada;

fim – finaliza o jogo quando limite é atingido.

O gráfico de estados da FSM e a tabela de transições foram construídos conforme os sinais de entrada acerto, fimJogo, enter, jogar e reset.

3.3 Top-Level do Projeto

No nível top-level, o projeto foi particionado entre a unidade de controle (UC) e o fluxo de dados (FD), com conexões organizadas conforme os sinais de controle. Entradas como clock, reset, jogar e botões de operação são processadas pela UC, que emite sinais como zeraCtrl, regEnable, enableCtrl, entre outros. Esses sinais são enviados ao FD, que responde com dados como acertoJog e respostaOut, usados de volta pela UC para decidir as transições.

3.4 Seleção Semi-Aleatória do Início da ROM

Uma das melhorias mais importantes no funcionamento do Math Genius é a introdução de um mecanismo semi-aleatório para definir o ponto de partida na ROM. Embora as operações armazenadas nas ROMs sejam acessadas sequencialmente, o endereço inicial da ROM será alterado de forma não determinística a cada nova execução, aumentando a variedade de desafios e reduzindo padrões previsíveis.

Justificativa Pedagógica

Essa abordagem é especialmente útil para evitar memorização repetitiva, promovendo melhor desenvolvimento cognitivo. Crianças com TEA se beneficiam de padrões com certa previsibilidade, mas a leve introdução de aleatoriedade permite trabalhar flexibilidade mental e adaptabilidade de forma segura.

Estrutura da Solução

Com base na consultoria da Júlia Muniz (Monitora de LabDig), foram consideradas várias alternativas para gerar essa pseudo aleatoriedade:

Clock Divider: utilizado para reduzir a frequência de 50 MHz da FPGA para algo mais lento e controlável. Essa frequência diferenciada serve como base para o funcionamento de shift registers e contadores pseudo aleatórios.

Shift Register com Flip-Flops: estrutura composta por uma cadeia de flip-flops que deslocam bits em sequência. Com uma configuração como:

ff0: Q7 => Q0

ff1: Q0 => Q1

...

ff7: Q6 => Q7

É possível gerar padrões binários que, apesar de não serem verdadeiramente aleatórios, são suficientemente variados para o propósito do jogo.

Contador com inversão de sinal: a cada ciclo completo do contador, inverte-se o sinal de saída, criando um clock alternado que pode ser usado como entrada de sampling.

Mapeamento para a ROM

Duas opções principais foram avaliadas:

Um único shift register de 50 bits, onde cada estado representa uma posição da ROM. A saída seria conectada a um encoder que traduz esse estado em um valor de 6 bits (endereçamento binário);

Seis shift registers independentes, onde cada um representa um bit do endereço final. A concatenação das saídas gera o endereço final de acesso.

Ambas as soluções podem ser utilizadas dependendo dos recursos disponíveis na FPGA e da complexidade desejada no projeto.

Conexão com o Projeto

No contexto do Math Genius, esse endereço inicial gerado aleatoriamente será usado como base para começar a sequência de contas matemáticas em cada nova rodada. O restante do jogo continua sequencial, garantindo organização e progressão adequada, mas com um início inesperado.

Essa funcionalidade foi incluída para garantir maior envolvimento do usuário e promover uma experiência mais rica e desafiadora.

No nível top-level, o projeto foi particionado entre a unidade de controle (UC) e o fluxo de dados (FD), com conexões organizadas conforme os sinais de controle. Entradas como clock, reset, jogar e botões de operação são processadas pela UC, que emite sinais como zeraCtrl, regEnable, enableCtrl, entre outros. Esses sinais são enviados ao FD, que responde com dados como acertoJog e respostaOut, usados de volta pela UC para decidir as transições.

4. TESTES

4.1 Estratégia de Testes

As simulações foram realizadas no ModelSim com foco nos seguintes pontos:

Corretude na seleção da ROM baseada no registrador RegDif;

Transição correta de estado na UC;

Resposta do sistema à mudança de dificuldade;

Validação das saídas contaReal e resposta do jogador.

4.2 Resultados Obtidos

As simulações realizadas no ModelSim buscaram verificar o funcionamento completo do sistema, desde a geração de uma operação matemática até a validação da resposta inserida pelo usuário. Os testes incluíram diferentes valores de dificuldade e simulações de partidas completas. Abaixo, descrevemos o que cada imagem representa:

Simulação 1: Verifica a inicialização do sistema, com avanço correto dos estados da UC, apresentação da operação e transição para os estados de resposta. Também mostra como os sinais de controle (como regEnable, zeraCtrl, esperado, acertou?) são ativados de forma coordenada.

Simulação 2: Foca na entrada do jogador. Os sinais inputUsuario e respostaOut mudam com base nos botões pressionados. A UC reconhece o enter e passa para o estado de comparação. Podemos observar a verificação do acerto e avanço de endereço na ROM.

Simulação 3: Testa o fluxo completo com múltiplas contas sendo apresentadas. O contador de endereços e os dados vindos da ROM (operação, addROM) evoluem conforme o esperado. Mostra também respostas certas e erradas, validando os caminhos de acerto e fimJogo.

Essas simulações confirmam a robustez do controle de fluxo e a fidelidade do sistema à lógica implementada na FSM e no fluxo de dados.

As simulações realizadas no ModelSim geraram os seguintes sinais de interesse: Estado, Resposta, Operação, Endereço, Acerto, Input do usuário, entre outros. As imagens abaixo ilustram essas transições:

| Teste | Valor de dificuldade | ROM esperada | Valor de contaReal | Resultado Esperado | Resultado Obtido |
| --- | --- | --- | --- | --- | --- |
| 1 | 2'b00 | romInicial | valor de conta1 | correto | correto |
| 2 | 2'b01 | romFacil | valor de conta2 | correto | correto |
| 3 | 2'b10 | romMedia | valor de conta3 | correto | correto |
| 4 | 2'b11 | romDificil | valor de conta4 | correto | correto |
| 5 | Mudança durante jogo | - | sem alteração | dificuldade travada | dificuldade travada |

5. CONTRIBUIÇÕES PEDAGÓGICAS

O projeto Math Genius foi idealizado com o propósito de ser mais do que uma simples implementação digital: sua essência está enraizada no campo da educação especial, oferecendo suporte ao desenvolvimento cognitivo de crianças com Transtorno do Espectro Autista (TEA). A partir da integração entre engenharia digital e princípios pedagógicos, o Math Genius posiciona-se como um serious game com valor terapêutico e educacional, especialmente desenhado para ambientes clínicos, escolares e domiciliares.

5.1 Estímulo das Funções Executivas

O jogo atua diretamente no fortalecimento das chamadas funções executivas, um conjunto de habilidades cognitivas responsáveis pela autorregulação, planejamento e resolução de problemas. Tais competências são, frequentemente, comprometidas em crianças com TEA. O Math Genius contribui para esse desenvolvimento ao propor tarefas matemáticas organizadas em sequência, com tempo de resposta limitado e controle rigoroso de feedbacks.

Essas tarefas exigem da criança:

Memória de trabalho: ao reter temporariamente os números exibidos para realizar o cálculo.


Inibição comportamental: ao aguardar o momento certo de pressionar o botão.


Flexibilidade cognitiva: ao se adaptar a diferentes tipos de operações matemáticas e níveis de dificuldade.


Planejamento e monitoramento: ao organizar mentalmente a resposta e verificar sua coerência.


5.2 Ambiente Controlado com Feedback Positivo

A estrutura do Math Genius foi cuidadosamente pensada para proporcionar um ambiente previsível, mas estimulante. Por meio de FSMs bem definidas, o jogo segue uma lógica de estados clara e compreensível, o que é fundamental para usuários com TEA, que frequentemente apresentam desconforto diante de ambientes imprevisíveis.

Além disso, o sistema oferece feedback visual positivo em situações de sucesso. A implementação da mensagem comemorativa "Uhuull" ao final do jogo é um exemplo de reforço positivo, mecanismo psicopedagógico comumente empregado em contextos terapêuticos. Esse tipo de estímulo contribui para o fortalecimento da autoestima, engajamento e associação positiva com a atividade proposta.

5.3 Adaptação Progressiva do Desafio

Outro diferencial pedagógico importante do Math Genius está em sua capacidade de adaptação. O jogo incorpora um registrador de dificuldade que permite selecionar entre quatro níveis distintos (inicial, fácil, médio e difícil), cada um representado por uma ROM específica com operações matemáticas progressivamente mais exigentes.

Esse modelo possibilita:

Personalização do jogo para cada usuário, respeitando seu nível atual de desempenho;


Progressão gradual do desafio, que é essencial para evitar frustrações e manter o engajamento;


Monitoramento da evolução, já que a coleta de dados permite comparar o desempenho da criança ao longo do tempo.


5.4 Coleta de Dados e Monitoramento por Terapeutas

Uma das contribuições mais relevantes do Math Genius está na sua capacidade de gerar dados objetivos de desempenho do usuário. As respostas do jogador são armazenadas e transmitidas via comunicação serial (UART) para um computador, onde podem ser processadas por terapeutas ou educadores.

Esses dados incluem:

Número de acertos por sessão;


Tempo de resposta entre apresentação da operação e entrada do jogador;


Frequência de erros por tipo de operação;


Histórico de evolução entre sessões.


A coleta automatizada desses indicadores permite:

Realizar avaliações diagnósticas mais precisas;


Adaptar a estratégia terapêutica com base em dados concretos;


Compartilhar os resultados com familiares e demais profissionais da rede de apoio da criança.


Importante ressaltar que, para preservar o caráter lúdico da experiência, essas métricas não são visíveis ao jogador. A contagem de acertos, por exemplo, é enviada exclusivamente ao orientador. Esse cuidado evita que a criança se sinta pressionada por desempenho ou se frustre ao cometer erros.

5.5 Inclusão Digital e Empoderamento

O Math Genius também contribui com a inclusão digital ao permitir que crianças com TEA tenham contato com tecnologias modernas como FPGAs e sistemas interativos. A experiência de sucesso em jogos educacionais como este pode aumentar a confiança da criança, reforçar sua autonomia e fomentar o interesse por atividades de raciocínio lógico.

Além disso, o jogo pode ser utilizado como ferramenta de vinculação pedagógica, servindo como ponte entre o profissional de apoio e a criança. A participação ativa da criança no jogo pode revelar aspectos comportamentais que não seriam evidenciados em atividades convencionais.

6. HARDWARE E ESTRATÉGIA INICIAL DE IMPLEMENTAÇÃO

6.1 Utilização da FPGA

A FPGA atua como núcleo central do Math Genius. Sua arquitetura permite controle determinístico de estados e precisão temporal elevada, o que é essencial para garantir previsibilidade e confiabilidade ao jogo.

6.2 Displays Integrados e Adicionais

A placa FPGA já dispõe de displays de sete segmentos integrados, os quais serão utilizados para mostrar resultados e mensagens. Para representar operandos e operadores, foram adquiridos dois displays adicionais, conectados via GPIOs, permitindo a visualização direta da operação em curso (ex: 5 + 2).

6.3 Comunicação com o Computador

Dois métodos serão utilizados:

Quartus e Waveforms: para simulação e depuração do sistema digital;

Analog Discovery com UART: para transmissão de dados em tempo real, integrando com o pyserial para análise computacional dos dados.

6.4 Diagrama de Interligação

Os componentes serão conectados por meio de um mapeamento padronizado de pinos, respeitando as capacidades elétricas e lógicas da placa. Um diagrama detalhado será elaborado para auxiliar na implementação física e em futuras manutenções.

Essa arquitetura modular permite que cada elemento seja substituído ou aprimorado de forma independente, o que garante escalabilidade para futuras versões do Math Genius.

imagem geral do Hardware: Displays e conexões com a FPGA

Imagem dos displays representando uma conta e sua resposta correta.

7. TABELA DE PINOS

Em projetos com FPGA, a tabela de pinos desempenha um papel fundamental ao estabelecer a correspondência entre os sinais lógicos definidos no código (em Verilog) e os terminais físicos da placa. Essa associação é essencial para garantir que entradas e saídas digitais, como botões, switches, displays e LEDs, estejam corretamente conectados aos pinos disponíveis no hardware. Sem essa definição precisa, o projeto pode funcionar em simulação, mas falhar completamente na implementação física.

Além de garantir a funcionalidade, a tabela de pinos também atua como instrumento de documentação e segurança. Ela evita conflitos elétricos e possibilita que o projeto seja replicado por outros usuários, pois documenta exatamente como os sinais devem ser ligados. Em ambientes educacionais e terapêuticos como o do projeto Math Genius, esse controle é ainda mais crucial, pois assegura que o comportamento observado na interface física corresponda fielmente à lógica implementada, preservando a confiabilidade da experiência do usuário.

Segue a tabela de Pinos do projeto Math Genius:

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
| dif_input | switch 0 | U13 | - |
| dif_input | switch 1 | V13 | - |
| acertoJog | LED R0 | AA2 | - |
| db_fim | LED R1 | AA1 | - |
| resposta (dígito 0) | HEX 30 | Y16 | - |
| resposta (dígito 0) | HEX 31 | W16 | - |
| resposta (dígito 0) | HEX 32 | Y17 | - |
| resposta (dígito 0) | HEX 33 | V16 | - |
| resposta (dígito 0) | HEX 34 | U17 | - |
| resposta (dígito 0) | HEX 35 | V18 | - |
| resposta (dígito 0) | HEX 36 | V19 | - |
| resposta (dígito 1) | HEX 40 | U20 | - |
| resposta (dígito 1) | HEX 41 | Y20 | - |
| resposta (dígito 1) | HEX 42 | V20 | - |
| resposta (dígito 1) | HEX 43 | U16 | - |
| resposta (dígito 1) | HEX 44 | U15 | - |
| resposta (dígito 1) | HEX 45 | Y15 | - |
| resposta (dígito 1) | HEX 46 | P9 | - |
| resposta (dígito 2) | HEX 50 | N9 | - |
| resposta (dígito 2) | HEX 51 | M8 | - |
| resposta (dígito 2) | HEX 52 | T14 | - |
| resposta (dígito 2) | HEX 53 | P14 | - |
| resposta (dígito 2) | HEX 54 | C1 | - |
| resposta (dígito 2) | HEX 55 | C2 | - |
| resposta (dígito 2) | HEX 56 | W19 | - |
| db_ESTADO | HEX 20 | Y19 // C15 | - |
| db_ESTADO | HEX 21 | AB17 // E15 | - |
| db_ESTADO | HEX 22 | AA10 // F14 | - |
| db_ESTADO | HEX 23 | Y14 //  F13 | - |
| db_ESTADO | HEX 24 | V14 // G16 | - |
| db_ESTADO | HEX 25 | AB22 // G13 | - |
| db_ESTADO | HEX 26 | AB21 // J17 | - |
| contagem_acertos  / (dígito 0) | HEX 00 | U21 | - |
| contagem_acertos  / (dígito 0) | HEX 01 | V21 | - |
| contagem_acertos  / (dígito 0) | HEX 02 | W22 | - |
| contagem_acertos  / (dígito 0) | HEX 03 | W21 | - |
| contagem_acertos  / (dígito 0) | HEX 04 | Y22 | - |
| contagem_acertos  / (dígito 0) | HEX 05 | Y21 | - |
| contagem_acertos  / (dígito 0) | HEX 06 | AA22 | - |
| contagem_acertos  / (dígito 1) | HEX 10 | AA20 | - |
| contagem_acertos  / (dígito 1) | HEX 11 | AB20 | - |
| contagem_acertos  / (dígito 1) | HEX 12 | AA19 | - |
| contagem_acertos  / (dígito 1) | HEX 13 | AA18 | - |
| contagem_acertos  / (dígito 1) | HEX 14 | AB18 | - |
| contagem_acertos  / (dígito 1) | HEX 15 | AA17 | - |
| contagem_acertos  / (dígito 1) | HEX 16 | U22 | - |
| DP (controla o ponto, =0) | GPIO_0_D35 | T15 | - |
| Ds(1) | GPIO_0_D28 | R15 | - |
| Ds(2) | GPIO_0_D30 | R16 | - |
| Ds(3) | GPIO_0_D32 | T19 | - |
| Ds(4) | GPIO_0_D34 | T17 | - |
| Caixa1 | GPIO_0_D0 #G | N16 | - |
| Caixa1 | GPIO_0_D2 #F | M16 | - |
| Caixa1 | GPIO_0_D4 #E | D17 | - |
| Caixa1 | GPIO_0_D6 #D | K21 | - |
| Caixa1 | GPIO_0_D8 #C | M20 | - |
| Caixa1 | GPIO_0_D10 #B | N21 | - |
| Caixa1 | GPIO_0_D12 #A | R21 | - |
| Caixa 2 | GPIO_0_D1 | B16 | - |
| Caixa 2 | GPIO_0_D3 | C16 | - |
| Caixa 2 | GPIO_0_D5 C | K20 | - |
| Caixa 2 | GPIO_0_D7 | K22 | - |
| Caixa 2 | GPIO_0_D9 C | M21 | - |
| Caixa 2 | GPIO_0_D11 | R22 | - |
| Caixa 2 | GPIO_0_D13 | T22 | - |
| o_ledacerto | GPIO_0_D31 | T20 | - |
| o_lederro | GPIO_0_D33 | T18 | - |

8. IMPLEMENTAÇÃO NO HARDWARE

8.0 Visão Geral da Montagem Física do Projeto

A montagem física do projeto Math Genius consolidou todos os módulos lógicos implementados em Verilog em uma estrutura funcional sobre a placa FPGA Terasic DE10-Lite, utilizando uma protoboard externa para a conexão de periféricos. A implementação final é composta por múltiplos elementos de entrada, saída e controle, integrados de forma coesa para garantir uma experiência imersiva, confiável e educativa para o público-alvo.

Displays de 7 Segmentos

Funcionamento e Circuito com Resistores

Os displays de 7 segmentos utilizados no projeto possuem quatro dígitos, cada um com seus próprios segmentos (a a g e DP). Como se tratam de displays com multiplexação comum, cada um dos dígitos é ativado sequencialmente, enquanto os segmentos são controlados individualmente para formar o número correspondente. Essa multiplexação rápida cria a ilusão de que todos os dígitos estão acesos simultaneamente.

Para garantir o correto funcionamento dos segmentos e evitar a queima dos LEDs internos, foram utilizados resistores de 220 ohms em série com cada linha de segmento. Esses resistores limitam a corrente elétrica fornecida pela FPGA, preservando a integridade do display e assegurando que a tensão e corrente estejam dentro das especificações do componente.

A lógica de controle implementada no Verilog alterna os dígitos com base em um clock derivado, enquanto envia o valor binário correspondente ao caractere desejado. Isso permite o uso eficiente de pinos da FPGA e um consumo reduzido de energia, sem comprometer a clareza visual da informação apresentada ao jogador.

O sistema utiliza os displays de 7 segmentos já presentes na placa FPGA para exibir o resultado digitado pelo jogador. Adicionalmente, foram conectados dois displays externos à protoboard para exibir os operandos e o operador da operação matemática, compondo assim uma interface visual completa da equação. Esses displays são atualizados dinamicamente conforme o avanço dos estados da FSM, permitindo à criança acompanhar visualmente o desafio proposto.

Imagem Display de 7 Segmentos: Funcionamento

Protoboard e Fiação

A integração entre a FPGA, os botões, os displays externos e os LEDs foi realizada sobre uma protoboard. A fiação foi cuidadosamente organizada de acordo com a tabela de pinos estabelecida no projeto, garantindo a compatibilidade elétrica e o funcionamento seguro de todos os periféricos. Essa estrutura modular facilita a manutenção e a expansão do sistema, permitindo que novos periféricos sejam facilmente incorporados em versões futuras.

O conjunto montado demonstra a transição completa entre a lógica de simulação digital e a realidade física interativa, consolidando o Math Genius como um sistema aplicável e funcional em ambientes reais de ensino e terapia.

8.1 Feedback Visual com LEDs

Durante a montagem e testes físicos do projeto Math Genius, foi implementado um sistema adicional de sinalização visual com LEDs verdes e vermelhos conectados à FPGA. Os LEDs verdes acendem quando o jogador insere uma resposta correta, enquanto os LEDs vermelhos indicam respostas incorretas. Este feedback imediato tem papel fundamental no reforço positivo e na correção de erros, especialmente benéfico para o público-alvo com TEA, que tende a responder melhor a estímulos visuais claros e objetivos.

A implementação dos LEDs envolveu a associação de saídas lógicas da FSM diretamente a pinos configurados da placa FPGA, ligados a resistores e LEDs na protoboard. A sincronização com o ciclo de validação da resposta garante que o feedback seja apresentado instantaneamente após o processamento do cálculo.

 Imagem LEDs

Imagem do projeto Math Genius em funcionamento

8.2 Interface de Entrada com Botões (Analog Discovery)

Com o objetivo de otimizar a entrada de dados pelo jogador e evitar processos demorados de digitação, foi desenvolvida uma interface de entrada utilizando botões virtuais (WaveForms) conectados ao Analog Discovery. Esses botões permitem adicionar ou subtrair valores nas casas das centenas, dezenas e unidades, facilitando a composição do número final que representa a resposta à operação apresentada.

O sistema foi implementado com detectores de borda e codificadores que interpretam os sinais dos botões em incrementos ou decrementos direcionados ao registrador de resposta. Essa abordagem modulariza o processo de entrada, tornando-o acessível e intuitivo mesmo para usuários com baixa coordenação motora fina, promovendo fluidez na interação com o jogo.

Imagem Botões Analog Discovery

9. AVANÇOS DA SEMANA 4 (Semana Final)

Durante a quarta semana do projeto Math Genius, concluímos todas as etapas previstas no planejamento e finalizamos com sucesso a implementação completa do sistema. A seguir, detalhamos os avanços consolidados:

9.1 Funcionalidade Completa das Operações

Todas as contas matemáticas armazenadas nas ROMs foram testadas e estão sendo processadas corretamente pelo sistema. O fluxo de dados integrado com o operador e os comparadores garante que as operações sejam interpretadas e exibidas corretamente para o jogador, e que as respostas sejam devidamente validadas.

9.2 Seleção e Troca de Dificuldade

O registrador de dificuldade está plenamente funcional, permitindo a escolha entre quatro ROMs distintas (Inicial, Fácil, Média e Difícil). A lógica de seleção através do sinal enableDif impede mudanças de dificuldade durante a execução de uma rodada, respeitando a integridade da partida. Essa mecânica foi testada em simulação e na prática, e funcionou conforme esperado.

Organização das ROMs e Sistema de Dificuldade

Um dos pontos centrais do projeto Math Genius foi o desenvolvimento de um sistema progressivo de dificuldade baseado em diferentes memórias ROM. Foram implementadas quatro ROMs distintas, correspondentes aos níveis: Inicial, Fácil, Médio e Difícil. Cada ROM contém uma série de operações matemáticas codificadas em 16 bits. A estrutura binária é organizada de forma padronizada, de modo que os bits mais significativos definem o operador, e os demais representam os operandos.

Essa organização permitiu uma seleção simples por meio de um registrador de dificuldade (RegDif), controlado via FSM. A escolha da ROM ativa determina qual conjunto de desafios será fornecido ao jogador, respeitando o nível selecionado no início da partida. O acesso à ROM ocorre por um contador de endereços, que avança a cada operação resolvida, partindo de um valor pseudoaleatório inicial para aumentar a variabilidade da experiência.

Exemplo de trecho do código da ROM Difícil (rom4):

6'b000000: data_out = 16'b1111110011101101;  // 126 - 109

6'b000001: data_out = 16'b1110111001100110;  // 119 + 102

6'b000010: data_out = 16'b00011011001001101; // 13 * 13

Esse fragmento mostra como operações de diferentes naturezas (adição, subtração, multiplicação e divisão) foram distribuídas nas ROMs. A ROM difícil contém operações mais complexas, como multiplicações entre números altos e divisões não triviais, desafiando o raciocínio lógico e a atenção do jogador.

Cada conta é apresentada visualmente em displays de sete segmentos, utilizando registradores internos que extraem os operandos e operadores do valor de 16 bits lido da ROM. O projeto garante, assim, uma experiência escalonada, clara e ajustável, essencial para os objetivos pedagógicos definidos para crianças com TEA.

9.3 Inserção Correta das Respostas

A entrada do jogador via botões físicos é processada por detectores de borda e pelo bloco InputControl, que codifica a resposta e a armazena temporariamente no registrador. Essa resposta é então comparada com a esperada, e o sistema realiza a verificação de acerto ou erro. Foram testados todos os tipos de operação (adição e subtração) com diferentes combinações de botões.

9.4 Montagem Física Finalizada

Todos os fios foram devidamente conectados na placa FPGA e na protoboard externa, incluindo os displays de 7 segmentos adicionais adquiridos para representar visualmente os operandos e operadores. A fiação foi feita com atenção à compatibilidade elétrica e ao mapeamento correto dos pinos. O sistema foi energizado e operou corretamente, com atualização visual coerente com os estados lógicos da UC.

9.5 Testes de Derrota e Vitória

Os critérios de vitória e derrota foram implementados e testados com sucesso. O contador de acertos e a verificação do número máximo de contas foram utilizados para validar os estados finais da UC, resultando nos sinais corretos de fimJogo, com transições para o estado fim. Foram simulados e realizados jogos completos com acertos e erros, confirmando a robustez do sistema de transição.

9.6 Pronto para Apresentação

Com todas as funções implementadas, testadas e integradas, o projeto Math Genius encontra-se completo e pronto para apresentação. O jogo está funcional tanto no ambiente de simulação quanto no ambiente físico com a FPGA, oferecendo uma experiência completa de interação, visualização e resposta.

Esse avanço marca o encerramento da fase de desenvolvimento e consolidação do trabalho da equipe, tornando possível agora a demonstração prática do jogo para professores, colegas e demais interessados.

10. EXPLICAÇÃO DOS MÓDULOS VERILOG

Nesta seção, explicamos os principais arquivos Verilog utilizados na implementação do projeto Math Genius. Cada um desses arquivos representa uma parte fundamental do sistema, desde o controle até o teste completo do projeto.

10.1 MathGenius.v (Top-Level)

Este é o módulo principal do projeto. Ele instancia e interconecta os dois blocos fundamentais: fluxo_dados e unidade_controle. Também conecta os sinais de entrada e saída utilizados na FPGA, incluindo botões de entrada, reset, clock, sinais de controle e os displays de sete segmentos.

Este módulo organiza a arquitetura do projeto e define a comunicação entre as unidades, como os sinais de resposta, acerto, operando1, operando2, operador, e outros. Serve como ponto de integração geral do sistema.

10.2 unidade_controle.v (FSM)

Este módulo representa a Unidade de Controle (UC) do sistema, baseada em uma Máquina de Estados Finitos. Define a lógica de transição entre os estados inicial, prep, mostra_eq, espera, salvaJog, comparacao, addAcerto, prepProx e fim, conforme discutido na seção 3.2.

Além disso, o arquivo define os sinais de controle enviados ao FD (como enableROM, zeraCtrl, regEnable, fimJogo, etc.) e recebe os sinais de entrada acerto, fim, enter, jogar, reset para tomar decisões de transição.

10.3 fluxo_dados.v (FD)

Este arquivo implementa o Fluxo de Dados do Math Genius. Ele contém os seguintes blocos:

Detectores de borda para os botões físicos;

Codificador InputControl;

Registrador de resposta;

Registrador de dificuldade;

Contador de endereços;

Quatro ROMs diferentes para cada nível de dificuldade;

Multiplexador que escolhe a saída da ROM com base na dificuldade;

Bloco que realiza a operação matemática e compara com a resposta do jogador.

O fluxo_dados é responsável por manipular e transformar os dados brutos em informações úteis que a UC utiliza para controle lógico do jogo.

10.4 tb_mathGenius.v (Testbench)

Este módulo é o testbench completo do sistema. Nele, foram simuladas todas as condições operacionais do projeto:

Variações no valor de dificuldade;

Sequência de partidas completas com entrada de botões;

Checagem de transições da UC;

Monitoramento dos sinais de resposta e controle;

Testes de vitória, derrota e reinício.

O testbench se mostrou essencial para depuração do projeto e garantiu o funcionamento esperado do sistema completo.

11. AJUSTES FINAIS

Com o sistema completamente funcional, realizamos alguns ajustes finais para tornar o jogo ainda mais intuitivo, visualmente amigável e alinhado com os objetivos pedagógicos do projeto Math Genius. A seguir, listamos as últimas melhorias implementadas:

11.1 Tela Preta entre Operações

Foi inserido um pequeno intervalo com tela preta entre a exibição de uma operação e a próxima. Esse tempo permite que a criança tenha um momento breve de respiro e prepare-se para o próximo desafio. Do ponto de vista técnico, esse intervalo foi implementado adicionando um estado intermediário na máquina de estados, ativando os displays com todos os segmentos apagados temporariamente.

11.2 Mensagem de Vitória "Uhuull"

Ao atingir a quantidade de acertos necessária para vencer, o sistema entra no estado final de vitória. Nesse momento, os displays de sete segmentos exibem a palavra "Uhuull" como uma comemoração visual, reforçando positivamente a conquista da criança. Esse efeito também pode ser acompanhado de um LED ou som adicional em versões futuras.

11.3 Sistema de Contagem de Acertos Reservado ao Orientador

Durante o jogo, o número de acertos é registrado internamente, mas não é exibido ao jogador. Essa decisão foi tomada com o intuito de preservar a experiência lúdica e evitar qualquer pressão desnecessária. O número de acertos é enviado via UART apenas para o orientador, terapeuta ou educador responsável. Com isso, é possível monitorar o progresso da criança de forma segura, permitindo análises e ajustes no plano pedagógico.

Esses ajustes tornam o Math Genius um jogo ainda mais refinado, sensível às necessidades de seu público-alvo e tecnicamente sofisticado.

12. CONCLUSÃO

O projeto Math Genius foi concebido e desenvolvido como uma ferramenta digital interativa para auxiliar no desenvolvimento cognitivo de crianças com Transtorno do Espectro Autista (TEA). Através de operações matemáticas simples, interface visual amigável e controle preciso via FPGA, o jogo proporciona um ambiente seguro, controlado e educativo.

Durante as quatro semanas de trabalho, a equipe conseguiu:

Estruturar o projeto com clareza modular (UC + FD);

Implementar múltiplas ROMs com dificuldade variável;

Criar um sistema de resposta via botões físicos;

Incorporar um contador de acertos oculto e acessível por UART;

Refatorar o fluxo com pausas visuais e mensagens de vitória;

Validar todo o sistema em simulação (ModelSim) e no hardware físico (FPGA + displays);

Integrar displays adicionais, entrada por botões físicos e lógica FSM refinada;

Trabalhar com práticas reais de engenharia: modularização, testes, simulação, e integração física.

O projeto também foi um exercício importante de cooperação em equipe e gestão de tempo. Desde a idealização até os testes finais, cada etapa foi desenvolvida com o compromisso de entregar um sistema funcional, robusto e que pudesse gerar impacto positivo na prática educacional e terapêutica.

O Math Genius está pronto para ser apresentado e utilizado em demonstrações práticas, e pode facilmente ser expandido com novas ROMs, funcionalidades adicionais (como operações de multiplicação e divisão), e conectividade mais avançada (por exemplo, com interfaces gráficas no computador ou dashboards de desempenho).

Finalizamos este planejamento com a sensação de dever cumprido: criamos um produto funcional, tecnicamente sólido e socialmente relevante. Esperamos que, com o devido acompanhamento, ele possa ser testado com usuários reais e aprimorado com base em suas experiências.

O projeto Math Genius foi concebido e desenvolvido como uma ferramenta digital interativa para auxiliar no desenvolvimento cognitivo de crianças com Transtorno do Espectro Autista (TEA). Através de operações matemáticas simples, interface visual amigável e controle preciso via FPGA, o jogo proporciona um ambiente seguro, controlado e educativo.

Durante as quatro semanas de trabalho, a equipe conseguiu:

Estruturar o projeto com clareza modular (UC + FD);

Implementar múltiplas ROMs com dificuldade variável;

Criar um sistema de resposta via botões físicos;

Incorporar um contador de acertos oculto e acessível por UART;

Refatorar o fluxo com pausas visuais e mensagens de vitória;

Validar todo o sistema em simulação (ModelSim) e no hardware físico (FPGA + displays).

O resultado é um sistema digital robusto, testado e pronto para ser utilizado em ambiente terapêutico. O projeto não apenas cumpre os objetivos técnicos propostos, mas também contribui socialmente ao oferecer uma ferramenta acessível e sensível às demandas de crianças com TEA.

13. Considerações Finais

A realização do projeto de Laboratório Digital 1 representou uma experiência transformadora para o nosso grupo, tanto no aspecto técnico quanto humano. Desenvolver um serious game voltado para o público infantil com Transtorno do Espectro Autista (TEA) nos desafiou a pensar além dos circuitos e códigos, exigindo sensibilidade, empatia e um olhar atento às necessidades específicas dessas crianças. Ao longo do semestre, nos debruçamos sobre a criação de um sistema interativo, funcional e educativo, empregando conceitos sólidos de lógica digital, desde portas lógicas e FSMs até temporizações, tudo aplicado em Verilog. Mais do que cumprir requisitos acadêmicos, sentimos que nosso projeto carregava um propósito social real e significativo, o que tornou todo o processo ainda mais motivador.

Do ponto de vista técnico, o projeto nos proporcionou um aprendizado profundo e prático em ferramentas essenciais da engenharia digital. A utilização do Quartus Prime para síntese e simulação, juntamente com o ModelSim para testes e validações, solidificou nosso domínio das etapas de desenvolvimento e depuração de sistemas em hardware. Além disso, aprendemos a importância da documentação, organização modular e uso de boas práticas no desenvolvimento com Verilog. Essa vivência prática com FPGAs e demais instrumentos do laboratório foi crucial para que compreendêssemos, na prática, os conceitos estudados em aula, fortalecendo significativamente nossa base para disciplinas futuras e para desafios profissionais na área de sistemas embarcados e hardware digital.

A apresentação do projeto na feira foi outro ponto alto dessa trajetória. A oportunidade de mostrar nosso trabalho para colegas, professores e visitantes externos nos trouxe um sentimento de orgulho e realização. Percebemos, com alegria, o impacto positivo que um projeto acadêmico pode gerar, especialmente quando tem uma finalidade inclusiva e educativa. Foi gratificante ver as pessoas interagindo com o jogo e compreendendo nossa proposta. A feira não apenas reconheceu nossos esforços, mas também serviu como um espaço de troca riquíssimo, onde pudemos conhecer os trabalhos de outros grupos e aprender com suas abordagens e soluções criativas.

Por fim, não poderíamos concluir essa jornada sem agradecer profundamente a todos que tornaram essa experiência possível. Aos professores da disciplina, que guiaram nosso aprendizado com competência e entusiasmo, e aos monitores, sempre disponíveis para tirar dúvidas e oferecer direcionamento técnico. Mas um agradecimento especial vai para os técnicos Fátima e Daniel, cuja dedicação, carinho e atenção fizeram toda a diferença ao longo do semestre. Fátima e Daniel não apenas garantiram que o laboratório estivesse sempre em condições ideais de uso, mas também foram verdadeiros pilares de apoio — com conselhos, palavras de incentivo e uma presença constante que nos motivava a dar o nosso melhor. Sem eles, a experiência não teria sido tão rica e acolhedora. Nosso sincero muito obrigado!

14. REFERÊNCIAS

[1] American Psychiatric Association. Diagnostic and Statistical Manual of Mental Disorders (DSM-5®). 5th ed., American Psychiatric Publishing, 2013.

[2] Ordóñez, C. L., & Matias, M. A. (2017). Tecnologias digitais na educação de pessoas com TEA: contribuições dos jogos digitais. Revista Brasileira de Educação Especial, 23(1), 89–104.

[3] Muniz, Júlia. Aula sobre geração pseudoaleatória com flip-flops e aplicação em projetos lúdico-pedagógicos. Interpoli – Laboratório Digital I, Escola Politécnica da USP, março de 2025.

[4] Quartus Prime Lite Edition, versão 21.1.1, Intel Corporation.

[5] ModelSim Student Edition 10.4a, Mentor Graphics.

[6] Datasheets e manuais técnicos da placa FPGA Terasic DE10-Lite.

[7] WordPress. Frequency Scaling #4 - Multiply by 2. Disponível em: https://electrotrick.wordpress.com/2017/08/22/frequency-scaling-4-multiply-by-2/. Acesso em: março de 2025.



















## Diagramas e reprodução desta edição

Consulte os [diagramas explicativos](../DIAGRAMAS.md), os [objetivos pedagógicos](../OBJETIVOS_PEDAGOGICOS.md) e a [validação](../VALIDACAO.md). As figuras originais não foram republicadas. Os novos diagramas e os testes acompanham as implementações organizadas.

## Autoria e créditos

Luigi Scofano de Araujo · USP 13680334.

Créditos de participação constantes do material de origem: Lucas Lacerda, Paulo Henrique Mota de Oliveira.

## Reprodução e figuras desta edição

[Diagramas explicativos](../DIAGRAMAS.md) · [Validação](../VALIDACAO.md) · [Objetivos pedagógicos](../OBJETIVOS_PEDAGOGICOS.md).
