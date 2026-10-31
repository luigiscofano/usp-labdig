module calculo_dados (
    input  [11:0] medida0,
    input  [11:0] medida1,
    output        sinal_diferenca,
    output [11:0] diferenca
);

    wire [9:0] medida0_bin, medida1_bin, diferenca_bin;
    conversor_bcd_2_bin conv0 (
        .num_bcd (medida0),
        .num_bin (medida0_bin)
    );
    conversor_bcd_2_bin conv1 (
        .num_bcd (medida1),
        .num_bin (medida1_bin)
    );
    assign diferenca_bin = (medida1_bin > medida0_bin) ? (medida1_bin - medida0_bin) : (medida1_bin - medida0_bin);
    assign sinal_diferenca = (medida1_bin > medida0_bin) ? 1'b1 : 1'b0;
    
    conversor_bin_2_bcd conv2 (
        .num_bin (diferenca_bin),
        .num_bcd (diferenca)
    );

    
endmodule