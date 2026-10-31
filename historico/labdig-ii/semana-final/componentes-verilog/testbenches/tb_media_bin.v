`timescale 1ns/1ps

module tb_media_bin();

    reg clock;
    reg zera;
    reg recebeu_medida;
    reg [9:0] valor_medida;

    wire [9:0] medida_media;
    wire zero_medidas;

    // Instância do DUT
    media_bin dut (
        .clock(clock),
        .zera(zera),
        .recebeu_medida(recebeu_medida),
        .valor_medida(valor_medida),
        .medida_media(medida_media),
        .zero_medidas(zero_medidas)
    );

    // Clock 10ns
    always #5 clock = ~clock;

    // Procedimento de envio de medida
    task envia_medida(input [9:0] val);
    begin
        valor_medida = val;
        recebeu_medida = 1;
        #10;
        recebeu_medida = 0;
        #10;
    end
    endtask

    initial begin
        $display("===== INÍCIO DO TESTE =====");
        clock = 0;
        zera = 1;
        recebeu_medida = 0;
        valor_medida = 0;

        #20;
        zera = 0;

        // Testa zero_medidas
        #10;
        $display("[0 medidas] media=%d  zero_medidas=%b (esperado 1)", 
                  medida_media, zero_medidas);

        // 1ª medida
        envia_medida(10'd20);
        $display("[1 medida] media=%d  (esperado 20)", medida_media);

        // 2ª medida
        envia_medida(10'd40);   // soma=60
        $display("[2 medidas] media=%d  (esperado 30)", medida_media);

        // 3ª medida
        envia_medida(10'd50);   // soma=110
        $display("[3 medidas] media=%d  (esperado 36)", medida_media);

        // 4ª medida
        envia_medida(10'd90);   // soma=200
        $display("[4 medidas] media=%d  (esperado 50)", medida_media);

        zera = 1;
        #10;
        zera = 0;
        envia_medida(10'd120);
        envia_medida(10'd140);
        envia_medida(10'd160);
        envia_medida(10'd180);

        $display("===== FIM DO TESTE =====");
    end

endmodule
