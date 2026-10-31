`timescale 1ns/1ps
module tb_pwm_contador;
  reg clock=0;always #5 clock=~clock;
  reg reset=0,carregar=0,habilitar=0;reg [3:0] dado=0;wire [3:0] contagem;
  contador_didatico contador(clock,reset,carregar,habilitar,dado,contagem);
  reg [2:0] largura=0;wire pwm;
  circuito_pwm #(.conf_periodo(20),.largura_000(0),.largura_001(2),.largura_010(4),.largura_011(6),.largura_100(8),.largura_101(10),.largura_110(12),.largura_111(14)) servo(.clock(clock),.reset(reset),.largura(largura),.pwm(pwm),.db_pwm());
  integer i,j,altos;
  task passo;begin @(posedge clock);#1;end endtask
  initial begin
    reset=1;passo();reset=0;
    if(contagem!==0)$fatal(1,"Reset contador");
    @(negedge clock);carregar=1;dado=15;passo();carregar=0;
    if(contagem!==15)$fatal(1,"Carga contador");
    habilitar=1;passo();habilitar=0;if(contagem!==0)$fatal(1,"Retorno modulo 16");
    repeat(3)passo();if(contagem!==0)$fatal(1,"Enable contador");
    for(i=0;i<8;i=i+1)begin
      @(negedge clock);largura=i;reset=1;passo();reset=0;
      repeat(40)passo();altos=0;
      for(j=0;j<20;j=j+1)begin passo();if(pwm)altos=altos+1;end
      if(altos!=i*2)$fatal(1,"PWM posicao %0d largura %0d",i,altos);
    end
    $display("PASS contador e oito larguras PWM");$finish;
  end
endmodule
