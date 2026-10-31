module tratar_tx_dados_top_test (
    input clock,
    input reset,
    input iniciar_tx,
    output saida_serial,
    output fim_tx
);

    // Valores fixos
    localparam [11:0] MEDIDA_ANTIGA = 12'b0011_1001_0000; //390
    localparam [11:0] MEDIDA_ATUAL  = 12'b0011_0100_0000; //340

    tratar_tx_dados DUT (
        .clock(clock),
        .reset(reset),
        .iniciar_tx(iniciar_tx),
        .medida_antiga(MEDIDA_ANTIGA),
        .medida_atual(MEDIDA_ATUAL),
        .saida_serial(saida_serial),
        .fim_tx(fim_tx)
    );

endmodule
