/* --------------------------------------------------------------------------
 * Módulo : timeout_hcsr04
 * Função: gera timeout se echo não subir em tempo máximo permitido
 * Clock : 50 MHz
 * -------------------------------------------------------------------------- */

module time_out_hcsr04 #(
    parameter TIMEOUT = 2_500_000   // ~50ms @ 50MHz
)(
    input  wire clock,
    input  wire reset,        // reset do sistema
    input  wire enable,       // ativo somente no estado espera_echo
    input  wire echo,         // echo do sensor
    output reg  timeout       // 1 se estourou o tempo
);

    reg [31:0] cont;

    always @(posedge clock or posedge reset) begin
        if (reset) begin
            cont    <= 0;
            timeout <= 0;
        end else begin

            if (!enable) begin
                cont    <= 0;
                timeout <= 0;
            end 
            else begin
                if (echo) begin
                    cont    <= 0;
                    timeout <= 0;
                end else begin
                    if (cont >= TIMEOUT) begin
                        timeout <= 1;
                    end else begin
                        cont <= cont + 1;
                    end
                end
            end

        end
    end

endmodule
