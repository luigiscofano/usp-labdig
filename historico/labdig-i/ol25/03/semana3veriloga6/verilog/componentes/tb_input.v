`timescale 1ns / 1ps

module tb_input;
    reg clock;
    reg addU, subU, addD, subD, addC, subC, clear, enable;
    wire [7:0] OUT;
    
    inputControl uut (
        .clock(clock),
        .addU(addU),
        .subU(subU),
        .addD(addD),
        .subD(subD),
        .addC(addC),
        .subC(subC),
        .clear(clear),
        .enable(enable),
        .OUT(OUT)
    );
    
    // Geração de clock
    always #5 clock = ~clock; // Período de 10ns
    
    initial begin
        // Inicialização
        clock = 0;
        addU = 0; subU = 0; addD = 0; subD = 0; addC = 0; subC = 0;
        clear = 0; enable = 0;
        
        #10 clear = 1; // Limpa a saída
        #10 clear = 0;
        
        #10 enable = 1; addU = 1; // Incrementa 1
        #10 addU = 0;
        
        #10 addD = 1; // Incrementa 10
        #10 addD = 0;
        
        #10 addC = 1; // Incrementa 100 (como OUT é 8 bits, haverá overflow)
        #10 addC = 0;
        
        #10 subU = 1; // Decrementa 1
        #10 subU = 0;
        
        #10 subD = 1; // Decrementa 10
        #10 subD = 0;
        
        #10 subC = 1; // Decrementa 100
        #10 subC = 0;
        
        #10 enable = 0; // Desativa a contagem
        
        #20 $stop;
    end
    
endmodule
