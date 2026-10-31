module media_bcd (
    input  wire        clock,
    input  wire        zera_media,
    input  wire        pegar_medida,   // pulso que indica que chegou uma medida nova
    input  wire [11:0] medida_bcd,     // entrada em BCD de 3 dígitos (ex: 0–999)

    output wire [11:0] medida_final_bcd, // saída final também em BCD
    output wire        zero_medidas      // indica que nenhuma medida válida foi recebida
);

    wire [9:0] medida_bin;

    conversor_bcd_2_bin bcd_pra_bin (
        .num_bcd (medida_bcd),
        .num_bin (medida_bin)
    );

    wire [9:0] medida_media;

    media_bin u_media (
        .clock          (clock),
        .zera           (zera_media),
        .recebeu_medida (pegar_medida),
        .valor_medida   (medida_bin),
        .medida_media   (medida_media),
        .zero_medidas   (zero_medidas)
    );


    conversor_bin_2_bcd bin_para_bcd (
        .num_bin (medida_media),
        .num_bcd (medida_final_bcd)
    );

endmodule
