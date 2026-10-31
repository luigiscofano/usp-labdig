module test_medidor_distancia (
    input        clock,
    input        reset,

    input        iniciar,     

    // sensor HC-SR04
    input        echo,
    output       trigger,

    // saída final
    output        db_pronto,
    output [6:0]  hex_db_estado,
    output [6:0]   hex_medida_c,
    output [6:0]   hex_medida_d,
    output [6:0]   hex_medida_u
);

    wire pulso_iniciar;
    edge_detector ed_test (
        .clock(clock),
        .reset(reset),
        .sinal(iniciar),
        .pulso(pulso_iniciar)
    );
    
	 wire [11:0] medida;
	 wire pronto;
    medidor_distancia u_md (
        .clock(clock),
        .reset(reset),

        .iniciar(pulso_iniciar),     

        .echo(echo),
        .trigger(trigger),

        .medida_final(medida),
        .pronto(pronto),
        .hex_db_estado(hex_db_estado)
    );
	 
	hexa7seg cent_disp (
		.hexa(medida[11:8]),
		.display(hex_medida_c)
    );

	hexa7seg dez_disp (
		.hexa(medida[7:4]),
		.display(hex_medida_d)
    );

	hexa7seg uni_disp (
		.hexa(medida[3:0]),
		.display(hex_medida_u)
    );
	 
	  registrador_n reg_pronto (
        .clock(clock),
        .clear(reset),
        .enable(pronto),
        .D(pronto),
        .Q(db_pronto)
    );
    
endmodule