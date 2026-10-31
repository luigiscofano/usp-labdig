`timescale 1ns/1ns

module tb_media_bcd;

    reg clock = 0;
    reg zera_media = 0;
    reg pegar_medida = 0;
    reg [11:0] medida_bcd = 0;

    wire [11:0] medida_final_bcd;

    // DUT
    media_bcd dut (
        .clock(clock),
        .zera_media(zera_media),
        .pegar_medida(pegar_medida),
        .medida_bcd(medida_bcd),
        .medida_final_bcd(medida_final_bcd)
    );

    // Gera clock
    always #5 clock = ~clock;

    initial begin
        // Zera média no começo
        zera_media = 1;
        #20;
        zera_media = 0;

        // ---------------------------------------
        // Envia a primeira medida (136 BCD)
        // ---------------------------------------
        medida_bcd = 12'h136;
        pegar_medida = 1;
        #10;
        pegar_medida = 0;
        #40;

        // ---------------------------------------
        // Segunda medida (152 BCD)
        // ---------------------------------------
        medida_bcd = 12'h152;
        pegar_medida = 1;
        #10;
        pegar_medida = 0;
        #40;

        // ---------------------------------------
        // Terceira medida (092 BCD)
        // ---------------------------------------
        medida_bcd = 12'h092;
        pegar_medida = 1;
        #10;
        pegar_medida = 0;
        #40;

        // ---------------------------------------
        // Quarta medida (044 BCD)
        // ---------------------------------------
        medida_bcd = 12'h044;
        pegar_medida = 1;
        #10;
        pegar_medida = 0;
        #40;

        //Tem que acabar aparecendo a média: (136 + 152 + 92 + 44) / 4 = 106 BCD
        $stop;
    end

endmodule
