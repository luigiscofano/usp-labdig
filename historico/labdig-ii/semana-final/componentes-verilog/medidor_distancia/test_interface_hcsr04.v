module test_interface_hcsr04 (
    input          clock,
    input          reset,
    input          medir,
    input          echo,
    output         trigger,
    output         pronto,
    output wire    abandono,   // NOVO: 1 se leitura foi abandonada
    output [6:0]   hex_db_estado,
    output [6:0]   hex_medida_c,
    output [6:0]   hex_medida_d,
    output [6:0]   hex_medida_u,
    output         db_abandono,
    output         db_pronto
);
	 wire [2:0] db_estado;

    wire pulso_iniciar;
    edge_detector ed_test (
        .clock(clock),
        .reset(reset),
        .sinal(medir),
        .pulso(pulso_iniciar)
    );
    registrador_n reg_to (
        .clock(clock),
        .clear(reset),
        .enable(abandono),
        .D(abandono),
        .Q(db_abandono)
    );

    registrador_n reg_pronto (
        .clock(clock),
        .clear(reset),
        .enable(pronto),
        .D(pronto),
        .Q(db_pronto)
    );
    wire [11:0] medida;
    interface_hcsr04 interface_hcsr04 (
        .clock(clock),
        .reset(reset),
        .medir(pulso_iniciar),
        .echo(echo),
        .trigger(trigger),
        .medida(medida),
        .pronto(pronto),
        .abandono(abandono),
        .db_estado(db_estado),

    );
	 
	hexa7seg estado_disp (
		.hexa({1'b0, db_estado}),
		.display(hex_db_estado)
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
endmodule