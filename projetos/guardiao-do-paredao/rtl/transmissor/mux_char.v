module mux_char (
    input [11:0] medida1,
    input [11:0] variacao_vermelha,
    input estado_semaforo,
	 input [1:0] estado_jogo,
    input [3:0] sel_char,
    output reg [6:0] caractere_ascii
);
    /* 0000 - centena posição
     * 0001 - dezena posição
     * 0010 - unidade posição
     * 0011 - vírgula
     * 0100 - centena variacao_vermelha
     * 0101 - dezena variacao_vermelha
     * 0110 - unidade variacao_vermelha
     * 0111 - vírgula
     * 1000 - dezena velocidade
     * 1001 - unidade velocidade
     * 1010 - vírgula
     * 1011 - estado semáforo
     * 1100 - cerquilha
     * 13 caracteres no total  */
    parameter VIRGULA = 7'h2C; // ','
    parameter CERQUILHA = 7'h23; // '#'
    always @(*) begin
        case (sel_char)
				4'h0: caractere_ascii = estado_semaforo ? 7'h45 : 7'h4F; //E ou O
            4'h1: caractere_ascii = VIRGULA;
            4'h2: caractere_ascii = medida1[11:8] + 7'h30;
            4'h3: caractere_ascii = medida1[7:4] + 7'h30;
            4'h4: caractere_ascii = medida1[3:0] + 7'h30;
            4'h5: caractere_ascii = VIRGULA;
            4'h6: caractere_ascii = variacao_vermelha[11:8] + 7'h30;
            4'h7: caractere_ascii = variacao_vermelha[7:4]  + 7'h30;
            4'h8: caractere_ascii = variacao_vermelha[3:0]  + 7'h30;
            4'h9: caractere_ascii = VIRGULA;
				4'hA: begin
				  case (estado_jogo)
						2'b00: caractere_ascii = 7'h4A; // J
						2'b01: caractere_ascii = 7'h47; // G
						2'b10: caractere_ascii = 7'h50; // P
						2'b11: caractere_ascii = 7'h7E; // ~
				  endcase
			   end
            4'hB: caractere_ascii = CERQUILHA;
            default: caractere_ascii = 7'h21; // '!'
        endcase
    end
    
endmodule