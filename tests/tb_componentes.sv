`timescale 1ns/1ps
module tb_componentes;
  reg [9:0] numero; wire [11:0] bcd; wire [9:0] volta;
  conversor_bin_2_bcd para_bcd(numero,bcd);
  conversor_bcd_2_bin para_bin(bcd,volta);
  reg [11:0] a,b;wire [11:0] diferenca;wire mexeu;
  move_dection movimento(a,b,diferenca,mexeu);
  reg semaforo;reg [1:0] estado;reg [3:0] seletor;wire [6:0] caractere;
  mux_char mensagem(a,b,semaforo,estado,seletor,caractere);
  reg [95:0] esperado;integer i,j,k;integer delta;
  function [11:0] codificar(input integer n);
    codificar=((n/100)<<8)|(((n/10)%10)<<4)|(n%10);
  endfunction
  initial begin
    // Todos os números decimais representáveis nos três dígitos.
    for(i=0;i<1000;i=i+1)begin
      numero=i;#1;
      if(bcd!==codificar(i)||volta!==i)$fatal(1,"Conversao falhou em %0d",i);
    end
    // Simetria, igualdade e limiar de movimento de 10 cm.
    for(i=0;i<1000;i=i+37)for(j=0;j<1000;j=j+29)begin
      a=codificar(i);b=codificar(j);delta=(i>j)?i-j:j-i;#1;
      if(diferenca!==codificar(delta)||mexeu!==(delta>10))$fatal(1,"Movimento %0d %0d",i,j);
    end
    a=12'h100;b=12'h110;#1;if(mexeu!==0)$fatal(1,"Limiar 10");
    b=12'h111;#1;if(mexeu!==1)$fatal(1,"Limiar 11");
    // O protocolo tem 12 caracteres, inclusive derrota, que exige dois bits.
    a=12'h123;b=12'h045;semaforo=1;
    for(k=0;k<4;k=k+1)begin
      estado=k;
      case(k)
        0:esperado="E,123,045,J#";
        1:esperado="E,123,045,G#";
        2:esperado="E,123,045,P#";
        3:esperado="E,123,045,~#";
      endcase
      for(j=0;j<12;j=j+1)begin
        seletor=j;#1;
        if(caractere!==esperado[8*(11-j)+:8])$fatal(1,"ASCII estado %0d indice %0d",k,j);
      end
    end
    semaforo=0;seletor=0;#1;if(caractere!=="O")$fatal(1,"Momento O");
    $display("PASS conversoes, movimento e mensagens ASCII");$finish;
  end
endmodule
