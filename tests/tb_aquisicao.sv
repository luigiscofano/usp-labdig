`timescale 1ns/1ps
module tb_aquisicao;
  reg clock=0;always #5 clock=~clock;
  reg zera=0,recebe=0;reg [9:0] valor=0;wire [9:0] media;wire vazio;
  media_bin media_dut(clock,zera,recebe,valor,media,vazio);
  reg reset=0,enable=0,echo=0;wire timeout;
  time_out_hcsr04 #(.TIMEOUT(3)) timeout_dut(clock,reset,enable,echo,timeout);
  integer i,soma;reg [11:0] bcd;wire valida;
  checa_medida validador(bcd,valida);
  task passo;begin @(posedge clock);#1;end endtask
  initial begin
    #1;zera=1;reset=1;#2;zera=0;reset=0;passo();
    if(!vazio||media!==0)$fatal(1,"Media vazia");
    soma=0;
    for(i=1;i<=4;i=i+1)begin
      @(negedge clock);valor=i*100;recebe=1;soma=soma+i*100;passo();recebe=0;
      if(media!==soma/i||vazio)$fatal(1,"Media %0d",i);
    end
    @(negedge clock);enable=1;
    repeat(4)passo();if(timeout!==1)$fatal(1,"Timeout ausente");
    @(negedge clock);echo=1;passo();if(timeout!==0)$fatal(1,"Echo nao limpa timeout");
    @(negedge clock);echo=0;enable=0;passo();if(timeout!==0)$fatal(1,"Desabilitado");
    bcd=12'h599;#1;if(valida!==1)$fatal(1,"599 valido");
    bcd=12'h600;#1;if(valida!==0)$fatal(1,"600 invalido");
    bcd=12'h0A0;#1;if(valida!==0)$fatal(1,"BCD invalido");
    $display("PASS media de 1 a 4 amostras, timeout e validacao BCD");$finish;
  end
endmodule
