# Experiência 02 · Transmissão UART

## Objetivo pedagógico

**Entender start, dados LSB-first, paridade e stop em 7N2 e 7E1.**

Evidência proposta de aprendizagem: Decodificar um quadro e identificar um erro de paridade.

## Materiais

- [Arquivos e documentos originais](../../../docs/ACERVO.md)
- [Índice de documentos](../../../docs/ACERVO.md)
- [Guia de bancada](../../../docs/HARDWARE.md)

## Verificação

Cópia RTL selecionada compila no verificador da raiz. Execute `python scripts/verificar.py` na raiz do repositório. A compilação não comprova todas as regras do experimento. Os testes históricos são material de consulta e podem precisar de parâmetros e ajustes específicos do simulador.

## Roteiro de estudo

1. Ler a especificação e anotar entradas, saídas e condição de término.
2. Identificar registradores e sinais da unidade de controle.
3. Antecipar a saída em um caso normal e um caso de fronteira.
4. Comparar a previsão com uma simulação.
5. Registrar o que depende de montagem física para ser confirmado.
