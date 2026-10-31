module circuito_pwm #(
    parameter integer conf_periodo = 1_000_000,
    parameter integer largura_000  = 35_000,
    parameter integer largura_001  = 45_700,
    parameter integer largura_010  = 56_450,
    parameter integer largura_011  = 67_150,
    parameter integer largura_100  = 77_850,
    parameter integer largura_101  = 88_550,
    parameter integer largura_110  = 99_300,
    parameter integer largura_111  = 110_000
) (
    input        clock,
    input        reset,
    input  [2:0] largura,
    output wire  pwm,
    output wire  db_pwm
);
  reg [31:0] contagem;
  reg [31:0] largura_pwm;
  reg        s_pwm;

  // Por quê: reset deve carregar a LARGURA ATUAL, não forçar 000
  always @(posedge clock or posedge reset) begin
    if (reset) begin
      contagem <= 32'd0;
      s_pwm    <= 1'b0;
      case (largura)
        3'b000: largura_pwm <= largura_000;
        3'b001: largura_pwm <= largura_001;
        3'b010: largura_pwm <= largura_010;
        3'b011: largura_pwm <= largura_011;
        3'b100: largura_pwm <= largura_100;
        3'b101: largura_pwm <= largura_101;
        3'b110: largura_pwm <= largura_110;
        3'b111: largura_pwm <= largura_111;
        default: largura_pwm <= largura_000;
      endcase
    end else begin
      s_pwm <= (contagem < largura_pwm);

      if (contagem >= conf_periodo - 1) begin
        contagem <= 32'd0;
        case (largura)
          3'b000: largura_pwm <= largura_000;
          3'b001: largura_pwm <= largura_001;
          3'b010: largura_pwm <= largura_010;
          3'b011: largura_pwm <= largura_011;
          3'b100: largura_pwm <= largura_100;
          3'b101: largura_pwm <= largura_101;
          3'b110: largura_pwm <= largura_110;
          3'b111: largura_pwm <= largura_111;
          default: largura_pwm <= largura_000;
        endcase
      end else begin
        contagem <= contagem + 32'd1;
      end
    end
  end

  assign db_pwm = s_pwm;
  assign pwm    = s_pwm;
endmodule
