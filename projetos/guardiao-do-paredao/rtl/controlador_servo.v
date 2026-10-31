module controlador_servo (
    input clock,
    input reset,
    input olha_frente,
    input guarda_pos,
    output pwm
);
    wire [2:0] s_largura;
    registrador_n #(.N(3)) reg_olha_frente (
        .clock (clock),
        .clear (reset),
        .enable(guarda_pos),
        .D     (olha_frente ? 3'b111 : 3'b000),
        .Q     ()
    );

    circuito_pwm pwm_servo (
        .clock   (clock),
        .reset   (reset),
        .largura (s_largura),
        .pwm     (pwm),
        .db_pwm  ()
    );
    
endmodule