module move_dection (
    input  [11:0] medida0,
    input  [11:0] medida1,
    output [11:0] diferenca,
    output       mexeu
);
    wire [9:0] medida0_bin, medida1_bin;

    conversor_bcd_2_bin converter_medida1(
        .num_bcd   (medida0),
        .num_bin   (medida0_bin)
    );

    conversor_bcd_2_bin converter_medida2(
        .num_bcd   (medida1),
        .num_bin   (medida1_bin)
    );

    wire [9:0] diferenca_bin;
    assign diferenca_bin = (medida0_bin > medida1_bin) ?  (medida0_bin - medida1_bin) : 
                                                        (medida1_bin - medida0_bin);

    conversor_bin_2_bcd converter_diferenca (.num_bin(diferenca_bin), .num_bcd(diferenca));
    assign mexeu = (diferenca_bin > 10'd10) ? 1'b1 : 1'b0;
    
endmodule