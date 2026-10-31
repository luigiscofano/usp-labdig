`timescale 1ns/1ps
module tb_uart;
  reg clock=0;always #5 clock=~clock;
  reg reset=0,start=0;reg [6:0] dado=0;wire pronto,tx;
  serial_tx_7e1 #(.CLK_HZ(100),.BAUD(10)) dut(clock,reset,start,dado,pronto,tx);
  integer n,i;reg paridade;reg [6:0] recebido;
  initial begin
    #1;reset=1;#11;reset=0;
    // Verifica o quadro físico, não apenas o registrador interno da paridade.
    for(n=0;n<128;n=n+1)begin
      wait(pronto===1);@(negedge clock);dado=n;start=1;
      @(negedge clock);start=0;
      @(negedge tx);#50;
      if(tx!==0)$fatal(1,"Start");
      for(i=0;i<7;i=i+1)begin #100;recebido[i]=tx;end
      #100;paridade=tx;
      if(recebido!==dado||((^recebido)^paridade)!==0)$fatal(1,"Quadro UART %0d",n);
      #100;if(tx!==1)$fatal(1,"Stop");#100;
    end
    // Reset durante transmissão retorna a linha para idle alto.
    @(negedge clock);start=1;@(negedge clock);start=0;
    wait(tx===0);reset=1;#1;
    if(tx!==1||pronto!==1)$fatal(1,"Reset UART");
    $display("PASS UART 128 caracteres, paridade par, stop e reset");$finish;
  end
  initial begin #200000;$fatal(1,"Timeout UART");end
endmodule
