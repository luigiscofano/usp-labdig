`timescale 1ns/1ps

module tb_checa_medida();

    reg  [11:0] medida_bcd;
    wire medida_valida;

    // DUT
    checa_medida dut (
        .medida_bcd(medida_bcd),
        .medida_valida(medida_valida)
    );

    task testa_valor(input [11:0] bcd);
    begin
        medida_bcd = bcd;
        #1; // espera 1ns para estabilizar
        $display("BCD = %1x %1x %1x  -> medida_valida = %b",
                  bcd[11:8], bcd[7:4], bcd[3:0], medida_valida);
    end
    endtask

    initial begin
        $display("===== INÍCIO DO TESTE =====");

        // ---------- VALORES VÁLIDOS ----------
        testa_valor(12'h000); // 000
        testa_valor(12'h123); // 123
        testa_valor(12'h259); // 259
        testa_valor(12'h399); // 399
        testa_valor(12'h400); // > 3xx

        // ---------- CENTENA INVÁLIDA ----------
        testa_valor(12'h800); // > 3xx
        testa_valor(12'hA00); // > 3xx

        // ---------- DEZENA INVÁLIDA ----------
        testa_valor(12'h1A8); // dezena A (inválida)

        // ---------- UNIDADE INVÁLIDA ----------
        testa_valor(12'h18B); // unidade B (inválida)

        // ---------- TODAS INVÁLIDAS ----------
        testa_valor(12'hABC);

        $display("===== FIM DO TESTE =====");
    end

endmodule
