// Reimplementação desta edição: enquadra uma medida BCD e, opcionalmente,
// o ângulo do sonar. Os dados ficam estáveis durante todo o pacote UART.
module telemetria_ascii #(
    parameter COM_ANGULO = 0,
    parameter CLK_HZ = 50_000_000,
    parameter BAUD = 115_200
)(
    input clock, input reset, input iniciar,
    input [11:0] medida_bcd, input [7:0] angulo,
    output tx, output pronto
);
    localparam OCIOSO=0, DISPARA=1, ESPERA_OCUPADO=2, ESPERA_LIVRE=3;
    localparam ULTIMO = COM_ANGULO ? 7 : 3;
    reg [1:0] estado;
    reg [3:0] indice;
    reg [11:0] medida;
    reg [7:0] angulo_salvo;
    reg [6:0] caractere;
    wire uart_pronto;
    assign pronto = (estado == OCIOSO);
    serial_tx_7e1 #(.CLK_HZ(CLK_HZ),.BAUD(BAUD)) uart(
        .clock(clock),.reset(reset),.start(estado==DISPARA),
        .data7(caractere),.pronto(uart_pronto),.tx(tx)
    );
    always @(*) begin
        caractere = 7'h23; // '#' encerra a mensagem.
        if(COM_ANGULO) begin
            case(indice)
                0:caractere=7'h30+angulo_salvo/100;
                1:caractere=7'h30+(angulo_salvo/10)%10;
                2:caractere=7'h30+angulo_salvo%10;
                3:caractere=7'h2c;
                4:caractere=7'h30+medida[11:8];
                5:caractere=7'h30+medida[7:4];
                6:caractere=7'h30+medida[3:0];
                default:caractere=7'h23;
            endcase
        end else begin
            case(indice)
                0:caractere=7'h30+medida[11:8];
                1:caractere=7'h30+medida[7:4];
                2:caractere=7'h30+medida[3:0];
                default:caractere=7'h23;
            endcase
        end
    end
    always @(posedge clock or posedge reset) begin
        if(reset)begin estado<=OCIOSO;indice<=0;medida<=0;angulo_salvo<=0;end
        else case(estado)
            OCIOSO:if(iniciar)begin
                medida<=medida_bcd;angulo_salvo<=angulo;indice<=0;estado<=DISPARA;
            end
            DISPARA:estado<=ESPERA_OCUPADO;
            ESPERA_OCUPADO:if(!uart_pronto)estado<=ESPERA_LIVRE;
            ESPERA_LIVRE:if(uart_pronto)begin
                if(indice==ULTIMO)estado<=OCIOSO;
                else begin indice<=indice+1'b1;estado<=DISPARA;end
            end
            default:estado<=OCIOSO;
        endcase
    end
endmodule
