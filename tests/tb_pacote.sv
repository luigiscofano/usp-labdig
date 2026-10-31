`timescale 1ns/1ps
module tb_pacote;
  reg clock=0;always #10 clock=~clock;
  reg reset=0,iniciar=0;wire tx,fim;
  tratar_tx_dados dut(.clock(clock),.reset(reset),.iniciar_tx(iniciar),.estado_semaforo(1'b0),.estado_jogo(2'b10),.variacao_vermelha(12'h045),.medida_atual(12'h123),.saida_serial(tx),.fim_tx(fim));
  localparam integer BIT_NS=434*20;
  integer i,j;reg [6:0] byte_rx;reg parity;reg [95:0] mensagem;
  initial begin
    #1;reset=1;#50;reset=0;
    @(negedge clock);iniciar=1;@(negedge clock);iniciar=0;
    for(i=0;i<12;i=i+1)begin
      @(negedge tx);#(BIT_NS/2);
      if(tx!==0)$fatal(1,"Start pacote");
      for(j=0;j<7;j=j+1)begin #(BIT_NS);byte_rx[j]=tx;end
      #(BIT_NS);parity=tx;
      if(((^byte_rx)^parity)!==0)$fatal(1,"Paridade pacote");
      #(BIT_NS);if(tx!==1)$fatal(1,"Stop pacote");
      mensagem[8*(11-i)+:8]={1'b0,byte_rx};
    end
    if(mensagem!=="O,123,045,P#")$fatal(1,"Mensagem recebida: %s",mensagem);
    wait(fim===1);$display("PASS pacote UART integrado: %s",mensagem);$finish;
  end
  initial begin #2000000;$fatal(1,"Timeout pacote");end
endmodule
