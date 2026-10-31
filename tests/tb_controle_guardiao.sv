`timescale 1ns/1ps
module tb_controle_guardiao;
  reg clock=0;always #5 clock=~clock;
  reg reset=0,iniciar=0,fim_1s=0,fim_3s=0,fim_5s=0,pronto_medida=0,mexeu=0,flag_ganhou=0,fim_tx=0,sensibilidade_luz=0;
  wire [4:0] estado;wire [1:0] jogo;wire verde,vermelho;
  guardiao_uc dut(.clock(clock),.reset(reset),.iniciar(iniciar),.fim_1s(fim_1s),.fim_3s(fim_3s),.fim_5s(fim_5s),.pronto_medida(pronto_medida),.mexeu(mexeu),.flag_ganhou(flag_ganhou),.fim_tx(fim_tx),.sensibilidade_luz(sensibilidade_luz),.db_estado(estado),.estado_jogo(jogo),.luz_verde(verde),.luz_vermelha(vermelho));
  task passo;begin @(posedge clock);#1;end endtask
  task esperar(input [4:0] alvo);
    integer t;begin
      t=0;while(estado!==alvo&&t<30)begin passo();t=t+1;end
      if(estado!==alvo)$fatal(1,"Estado esperado %0d encontrado %0d",alvo,estado);
    end
  endtask
  task partida;begin
    reset=1;#2;reset=0;iniciar=1;passo();iniciar=0;
    fim_1s=1;fim_3s=1;fim_5s=1;pronto_medida=1;fim_tx=0;
    esperar(5'h06);
  end endtask
  initial begin
    // Movimento excessivo perde, proximidade sem movimento vence.
    mexeu=1;flag_ganhou=0;partida();passo();
    if(estado!==5'h0C||jogo!==2'b10)$fatal(1,"Derrota");
    esperar(5'h0D);fim_tx=1;esperar(0);
    mexeu=0;flag_ganhou=1;partida();passo();
    if(estado!==5'h0B||jogo!==2'b01)$fatal(1,"Vitoria");
    esperar(5'h0D);fim_tx=1;esperar(0);
    mexeu=0;flag_ganhou=0;partida();fim_tx=1;esperar(5'h09);
    if(verde!==1||vermelho!==0)$fatal(1,"Sinal verde");
    sensibilidade_luz=1;#1;
    if(verde!==0||vermelho!==0)$fatal(1,"Opcao de luz");
    $display("PASS controle: vitoria, derrota, continuidade e luz");$finish;
  end
  initial begin #10000;$fatal(1,"Timeout controle");end
endmodule
