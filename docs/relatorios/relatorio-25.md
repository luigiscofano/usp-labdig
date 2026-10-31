# Documento sem título


Versão revisada para consulta pública. A disposição gráfica foi substituída por texto, tabelas e diagramas novos. Dados pessoais de terceiros e referências privadas foram retirados. Os créditos foram preservados.

module rom4 (clock, address, data_out);

input            clock;

input      [5:0] address;

output reg [15:0] data_out;

always @ (posedge clock)

begin

    case (address)

        6'b000000: data_out = 16'b1111110011101101;  // 126 - 109

        6'b000001: data_out = 16'b1110111001100110;  // 119 + 102

        6'b000010: data_out = 16'b00011011001001101  // 13 * 13

        6'b000011: data_out = 16'b0100101001100110;  // 37 + 102

        6'b000100: data_out = 16'b1101111001000111;  // 111 + 71

        6'b000101: data_out = 16'b0001101100001101;  // 13 * 13

        6'b000110: data_out = 16'b1101100110000110;  // 108 / 6

        6'b000111: data_out = 16'b0010001010000100;  // 17 - 4

        6'b001000: data_out = 16'b0010000001110110;  // 16 + 118

        6'b001001: data_out = 16'b1111110110000110;  // 126 / 6

        6'b001010: data_out = 16'b1111000011011011;  // 120 - 91

        6'b001011: data_out = 16'b1110100011010001;  // 116 - 81

        6'b001100: data_out = 16'b1101001001110000;  // 105 + 112

        6'b001101: data_out = 16'b0100010100011001;  // 34 * 25

        6'b001110: data_out = 16'b0100111001100010;  // 39 + 98

        6'b001111: data_out = 16'b0000010101010100;  // 2 * 84

        6'b010000: data_out = 16'b1001111100000011;  // 79 * 3

        6'b010001: data_out = 16'b1110000011001100;  // 112 - 76

        6'b010010: data_out = 16'b1101111011101110;  // 111 - 110

        6'b010011: data_out = 16'b1010111010100000;  // 87 - 32

        6'b010100: data_out = 16'b0010110100001001;  // 22 * 9

        6'b010101: data_out = 16'b0001000100111001;  // 8 * 57

        6'b010110: data_out = 16'b1111110110001001;  // 126 / 9

        6'b010111: data_out = 16'b0001100100100111;  // 12 * 39

        6'b011000: data_out = 16'b0010101100010010;  // 21 * 18

        6'b011001: data_out = 16'b1010011100000010;  // 83 * 2

        6'b011010: data_out = 16'b00001111001010100  // 7 * 52

        6'b011011: data_out = 16'b0001000101010110;  // 8 * 86

        6'b011100: data_out = 16'b0010011100101110;  // 19 * 46

        6'b011101: data_out = 16'b1111000110001100;  // 120 / 12

        6'b011110: data_out = 16'b0000011101001100;  // 3 * 76

        6'b011111: data_out = 16'b0000111100110100;  // 7 * 52

        6'b100000: data_out = 16'b0010010100000101;  // 18 * 5

        6'b100001: data_out = 16'b0010011100110010;  // 19 * 50

        6'b100010: data_out = 16'b0100101100001010;  // 37 * 10

        6'b100011: data_out = 16'b0010101110010101;  // 21 / 21

        6'b100100: data_out = 16'b1101110100001000;  // 110 * 8

        6'b100101: data_out = 16'b0111110100000100;  // 62 * 4

        6'b100110: data_out = 16'b1010001110000011;  // 81 / 3

        6'b100111: data_out = 16'b0000011101111111;  // 3 * 127

        6'b101000: data_out = 16'b0001110100001111;  // 14 * 15

        6'b101001: data_out = 16'b0010011100101100;  // 19 * 44

        6'b101010: data_out = 16'b0110000110010000;  // 48 / 16

        6'b101011: data_out = 16'b1101001110000011;  // 105 / 3

        6'b101100: data_out = 16'b1100100110110010;  // 100 / 50

        6'b101101: data_out = 16'b0001101110001101;  // 13 / 13

        6'b101110: data_out = 16'b1010100110000100;  // 84 / 4

        6'b101111: data_out = 16'b1111100110011111;  // 124 / 31  

        6'b110000: data_out = 16'b1111011110000011;  // 123 / 3

        6'b110001: data_out = 16'b1110000110010000;  // 112 / 16

        6'b110010: data_out = 16'b1111101111111101;  // 125 / 125

        6'b110011: data_out = 16'b0110111100101000;  // 55 * 8

        6'b110100: data_out = 16'b1001110110100111;  // 78 / 39

        6'b110101: data_out = 16'b1101001110000101;  // 105 / 5

        6'b110110: data_out = 16'b1010101110000101;  // 85 / 5

        6'b110111: data_out = 16'b1110101110100111;  // 117 / 39

        6'b111000: data_out = 16'b0110000110010000;  // 48 / 16

        6'b111001: data_out = 16'b1000010110010110;  // 66 / 22

        6'b111010: data_out = 16'b0110110110110110;  // 54 / 54

        6'b111011: data_out = 16'b1001000100100100;  // 72 * 4

        6'b111100: data_out = 16'b1110000110010000;  // 112 / 16

        6'b111101: data_out = 16'b0111011100101110;  // 59 * 14

        6'b111110: data_out = 16'b0101000110000101;  // 40 / 5

        6'b111111: data_out = 16'b1010100110000110;  // 84 / 6

    endcase

end

endmodule


## Diagramas e reprodução desta edição

Consulte os [diagramas explicativos](../DIAGRAMAS.md), os [objetivos pedagógicos](../OBJETIVOS_PEDAGOGICOS.md) e a [validação](../VALIDACAO.md). As figuras originais não foram republicadas. Os novos diagramas e os testes acompanham as implementações organizadas.

## Autoria e créditos

Luigi Scofano de Araujo · USP 13680334.

## Reprodução e figuras desta edição

[Diagramas explicativos](../DIAGRAMAS.md) · [Validação](../VALIDACAO.md) · [Objetivos pedagógicos](../OBJETIVOS_PEDAGOGICOS.md).
