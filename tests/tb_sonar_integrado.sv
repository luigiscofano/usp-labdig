`timescale 1ns/1ps
module tb_sonar_integrado;
  reg clock=0;always #10 clock=~clock;
  reg reset=0,iniciar=0,echo=0;wire trigger,tx,pwm,pronto;
  wire [7:0] angulo;wire [11:0] medida;
  sonar #(.ESTABILIZACAO_CICLOS(3)) dut(clock,reset,iniciar,echo,trigger,tx,pwm,pronto,angulo,medida);
  localparam integer BIT_NS=434*20;
  integer i,j,k,ang_rx,dist_rx;reg [6:0] c;reg parity;reg [63:0] pacote;
  // Modelo comportamental do sensor: eco de aproximadamente 17 centímetros.
  initial forever begin
    @(negedge trigger);#2000;echo=1;#(17*2941*20);echo=0;
  end
  initial begin
    #1;reset=1;#50;reset=0;
    @(negedge clock);iniciar=1;@(negedge clock);iniciar=0;
    for(k=1;k<=8;k=k+1)begin
      pacote=0;
      for(i=0;i<8;i=i+1)begin
        @(negedge tx);#(BIT_NS/2);
        for(j=0;j<7;j=j+1)begin #(BIT_NS);c[j]=tx;end
        #(BIT_NS);parity=tx;if(((^c)^parity)!==0)$fatal(1,"Paridade sonar");
        #(BIT_NS);if(tx!==1)$fatal(1,"Stop sonar");
        pacote=(pacote<<8)|c;
      end
      ang_rx=(pacote[63:56]-48)*100+(pacote[55:48]-48)*10+pacote[47:40]-48;
      dist_rx=(pacote[31:24]-48)*100+(pacote[23:16]-48)*10+pacote[15:8]-48;
      if(ang_rx!=k*20||pacote[39:32]!==","||pacote[7:0]!=="#")$fatal(1,"Pacote sonar: %s",pacote);
      if(dist_rx<16||dist_rx>18)$fatal(1,"Distancia sintetica %0d",dist_rx);
    end
    wait(pronto);$display("PASS sonar integrado: 8 angulos, sensor sintetico e UART");$finish;
  end
  initial begin #100000000;$fatal(1,"Timeout sonar integrado");end
endmodule
