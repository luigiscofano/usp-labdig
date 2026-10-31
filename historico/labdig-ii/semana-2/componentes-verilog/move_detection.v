module move_dection (
    input [11:0] medida0,
    input [11:0] medida1,
    output       mexeu
);
    wire [9:0] medida0_bin, medida1_bin;
    wire [9:0] diferenca;

    conversor_bcd_2_bin converter_medida1(
        .num_bcd   (medida0),
        .num_bin   (medida0_bin)
    );

    conversor_bcd_2_bin converter_medida2(
        .num_bcd   (medida1),
        .num_bin   (medida1_bin)
    );

    assign diferenca = (medida0_bin > medida1_bin) ?  (medida0_bin - medida1_bin) : 
                                                        (medida1_bin - medida0_bin);

    assign mexeu = (diferenca > 10'd10) ? 1'b1 : 1'b0;
    
endmodule