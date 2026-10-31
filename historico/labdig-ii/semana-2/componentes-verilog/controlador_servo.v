module controlador_servo (
    input clock,
    input olha_frente,
    input reset,
    output pwm
);
    circuito_pwm pwm_servo (
        .clock   (clock),
        .reset   (reset),
        .largura (olha_frente ? 3'b111 : 3'b000),
        .pwm     (pwm),
        .db_pwm  ()
    );
    
endmodule