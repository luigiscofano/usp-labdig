`timescale 1ns/1ps
module tb_telemetria;
  reg clock=0;always #5 clock=~clock;
  reg reset=0,iniciar0=0,iniciar1=0,escolha=0;
  reg [11:0] medida=12'h123;wire tx0,tx1,p0,p1;
  wire tx=escolha?tx1:tx0;
  telemetria_ascii #(.CLK_HZ(100),.BAUD(10)) trena(clock,reset,iniciar0,medida,8'd0,tx0,p0);
  telemetria_ascii #(.COM_ANGULO(1),.CLK_HZ(100),.BAUD(10)) sonar(clock,reset,iniciar1,medida,8'd120,tx1,p1);
  integer i,j;reg [6:0] c;reg paridade;reg [63:0] recebido;
  task receber(input integer total);
    begin
      recebido=0;
      for(i=0;i<total;i=i+1)begin
        @(negedge tx);#50;
        for(j=0;j<7;j=j+1)begin #100;c[j]=tx;end
        #100;paridade=tx;if(((^c)^paridade)!==0)$fatal(1,"Paridade telemetria");
        #100;if(tx!==1)$fatal(1,"Stop telemetria");
        recebido=(recebido<<8)|c;
      end
    end
  endtask
  initial begin
    #1;reset=1;#11;reset=0;
    @(negedge clock);iniciar0=1;@(negedge clock);iniciar0=0;
    // Alterar entrada durante o envio não pode corromper o pacote já capturado.
    fork begin #100;medida=12'h999;end receber(4);join
    if(recebido!=="123#")$fatal(1,"Trena: %s",recebido);
    wait(p0);medida=12'h017;escolha=1;
    @(negedge clock);iniciar1=1;@(negedge clock);iniciar1=0;
    receber(8);
    if(recebido!=="120,017#")$fatal(1,"Sonar: %s",recebido);
    wait(p1);$display("PASS telemetria trena e sonar com captura atomica");$finish;
  end
  initial begin #30000;$fatal(1,"Timeout telemetria");end
endmodule
