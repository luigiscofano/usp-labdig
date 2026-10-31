// Integração desta edição a partir da interface recuperada do projeto final.
module interface_ultrassonica(
    input clock,input reset,input iniciar,input echo,
    output trigger,output [11:0] distancia_bcd,
    output pronto,output timeout
);
    interface_hcsr04 sensor(.clock(clock),.reset(reset),.medir(iniciar),
        .echo(echo),.trigger(trigger),.medida(distancia_bcd),
        .pronto(pronto),.abandono(timeout),.db_estado());
endmodule
