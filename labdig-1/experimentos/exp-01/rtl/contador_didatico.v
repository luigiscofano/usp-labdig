// Reimplementação didática: o relatório da experiência 1 estuda reset síncrono.
// A prioridade é reset, carga e incremento. O enable mantém o valor parado.
module contador_didatico(
    input clock,input reset,input carregar,input habilitar,
    input [3:0] dado,output reg [3:0] contagem
);
    always @(posedge clock) begin
        if(reset)contagem<=0;
        else if(carregar)contagem<=dado;
        else if(habilitar)contagem<=contagem+1'b1;
    end
endmodule
