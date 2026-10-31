// Reimplementação baseada no relatório: uma varredura de oito posições,
// de 20 a 160 graus, com estabilização, medição e mensagem "aaa,ddd#".
module sonar #(
    parameter ESTABILIZACAO_CICLOS=25_000_000
)(
    input clock,input reset,input iniciar,input echo,
    output trigger,output tx,output pwm,output pronto,
    output [7:0] angulo_atual,output [11:0] medida_bcd
);
    localparam OCIOSO=0, ESTABILIZA=1, INICIA_MEDIDA=2, MEDINDO=3,
               INICIA_TX=4, TRANSMITINDO=5, PROXIMA=6;
    reg [2:0] estado,posicao;reg [31:0] espera;
    wire fim_medida,tx_pronto;
    assign pronto=(estado==OCIOSO);
    assign angulo_atual=8'd20+posicao*8'd20;
    circuito_pwm servo(.clock(clock),.reset(reset),.largura(posicao),.pwm(pwm),.db_pwm());
    medidor_distancia sensor(.clock(clock),.reset(reset),.iniciar(estado==INICIA_MEDIDA),
        .echo(echo),.trigger(trigger),.medida_final(medida_bcd),.pronto(fim_medida),.hex_db_estado());
    telemetria_ascii #(.COM_ANGULO(1)) transmissor(.clock(clock),.reset(reset),
        .iniciar(estado==INICIA_TX),.medida_bcd(medida_bcd),.angulo(angulo_atual),.tx(tx),.pronto(tx_pronto));
    always @(posedge clock or posedge reset) begin
        if(reset)begin estado<=OCIOSO;posicao<=0;espera<=0;end
        else case(estado)
            OCIOSO:if(iniciar)begin posicao<=0;espera<=0;estado<=ESTABILIZA;end
            ESTABILIZA:if(espera>=ESTABILIZACAO_CICLOS-1)estado<=INICIA_MEDIDA;
                       else espera<=espera+1'b1;
            INICIA_MEDIDA:estado<=MEDINDO;
            MEDINDO:if(fim_medida)estado<=INICIA_TX;
            INICIA_TX:estado<=TRANSMITINDO;
            TRANSMITINDO:if(tx_pronto)estado<=PROXIMA;
            PROXIMA:if(posicao==7)estado<=OCIOSO;
                    else begin posicao<=posicao+1'b1;espera<=0;estado<=ESTABILIZA;end
            default:estado<=OCIOSO;
        endcase
    end
endmodule
