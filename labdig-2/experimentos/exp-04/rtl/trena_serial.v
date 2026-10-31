// Reimplementação baseada no relatório da trena: mede e transmite "ddd#".
// O medidor e a UART vêm dos componentes recuperados e corrigidos do Guardião.
module trena_serial(
    input clock,input reset,input iniciar,input echo,
    output trigger,output tx,output pronto,output [11:0] medida_bcd
);
    localparam OCIOSO=0, INICIA_MEDIDA=1, MEDINDO=2, INICIA_TX=3, TRANSMITINDO=4;
    reg [2:0] estado;wire fim_medida,tx_pronto;
    medidor_distancia sensor(.clock(clock),.reset(reset),.iniciar(estado==INICIA_MEDIDA),
        .echo(echo),.trigger(trigger),.medida_final(medida_bcd),.pronto(fim_medida),.hex_db_estado());
    telemetria_ascii transmissor(.clock(clock),.reset(reset),.iniciar(estado==INICIA_TX),
        .medida_bcd(medida_bcd),.angulo(8'd0),.tx(tx),.pronto(tx_pronto));
    assign pronto=(estado==OCIOSO);
    always @(posedge clock or posedge reset) begin
        if(reset)estado<=OCIOSO;
        else case(estado)
            OCIOSO:if(iniciar)estado<=INICIA_MEDIDA;
            INICIA_MEDIDA:estado<=MEDINDO;
            MEDINDO:if(fim_medida)estado<=INICIA_TX;
            INICIA_TX:estado<=TRANSMITINDO;
            TRANSMITINDO:if(tx_pronto)estado<=OCIOSO;
            default:estado<=OCIOSO;
        endcase
    end
endmodule
