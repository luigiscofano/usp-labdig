module controle_servo (
 input wire clock,
 input wire reset,
 input wire [1:0] posicao,
 output wire controle,
 output wire db_controle
);


 circuito_pwm #(           // instanciado com valores default
	  .conf_periodo(1000000),  // T=20ms
	  .largura_000  (0   ),  // pulso=0
	  .largura_001  (50000  ),  // pulso de 1ms
	  .largura_010  (75000 ),  // pulso de 1,5ms
	  .largura_011  (100000)   // pulso de 2ms
 ) dut (
	  .clock   (clock  ),
	  .reset   (reset  ),
	  .largura ({1'b0, posicao}),
	  .pwm     (controle   ),
	  .db_pwm  (db_controle   )
 );
 
 endmodule