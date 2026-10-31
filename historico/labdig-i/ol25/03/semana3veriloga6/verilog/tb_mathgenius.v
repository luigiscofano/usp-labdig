module tb_mathgenius;
    reg clock_in = 1;
    reg reset_in = 0;
    reg jogar_in = 0;
    reg enter_in = 0;
    reg addU_in = 0;
    reg addD_in = 0;
    reg addC_in = 0;
    reg subU_in = 0;
    reg subD_in = 0;
    reg subC_in = 0;
    
    wire acertoJog_out;
    wire db_fim_out;
    wire [7:0] respostaOut_out;
    wire [6:0] db_A_out;
    wire [6:0] db_B_out;
    wire [1:0] db_op_out;
    wire [3:0] db_addr_out;
    
    parameter clockPeriod = 10;
    
    always #((clockPeriod / 2)) clock_in = ~clock_in;

    reg [3:0] caso = 0;
    
    MathGenius dut (
        .clock(clock_in),
        .addU(addU_in),
        .addD(addD_in),
        .addC(addC_in),
        .subU(subU_in),
        .subD(subD_in),
        .subC(subC_in),
        .enter(enter_in),
        .jogar(jogar_in),
        .reset(reset_in),
        .acertoJog(acertoJog_out),
        .db_fim(db_fim_out),
        .respostaOut(respostaOut_out),
        .db_A(db_A_out),
        .db_B(db_B_out),
        .db_op(db_op_out),
        .db_addr(db_addr_out)
    );

    initial begin
        clock_in = 1;
        reset_in = 1;
        #clockPeriod;
        reset_in = 0;
        #clockPeriod;
        
        jogar_in = 1;
        #clockPeriod;
        jogar_in = 0;
        #(10*clockPeriod);

        caso = 1;

        // 09 - 03 = 06
        addU_in = 1; #clockPeriod; addU_in = 0; #clockPeriod;
        addU_in = 1; #clockPeriod; addU_in = 0; #clockPeriod;
        addU_in = 1; #clockPeriod; addU_in = 0; #clockPeriod;
        addU_in = 1; #clockPeriod; addU_in = 0; #clockPeriod;
        addU_in = 1; #clockPeriod; addU_in = 0; #clockPeriod;
        addU_in = 1; #clockPeriod; addU_in = 0; #clockPeriod;
        enter_in = 1; #clockPeriod; enter_in = 0; #clockPeriod;
        #(10*clockPeriod);

        caso = 2;
        // 08 - 07 = 01
        addU_in = 1; #clockPeriod; addU_in = 0; #clockPeriod;
        enter_in = 1; #clockPeriod; enter_in = 0; #clockPeriod;
        #(10*clockPeriod);

        caso = 3;
        // 02 + 08 = 10
        addD_in = 1; #clockPeriod; addD_in = 0; #clockPeriod;
        enter_in = 1; #clockPeriod; enter_in = 0; #clockPeriod;
        #(10*clockPeriod);

        caso = 4;
        // 07 + 08 = 15
        addD_in = 1; #clockPeriod; addD_in = 0; #clockPeriod;
        addU_in = 1; #clockPeriod; addU_in = 0; #clockPeriod;
        addU_in = 1; #clockPeriod; addU_in = 0; #clockPeriod;
        addU_in = 1; #clockPeriod; addU_in = 0; #clockPeriod;
        addU_in = 1; #clockPeriod; addU_in = 0; #clockPeriod;
        addU_in = 1; #clockPeriod; addU_in = 0; #clockPeriod;
        enter_in = 1; #clockPeriod; enter_in = 0; #clockPeriod;
        #(10*clockPeriod);

        caso = 5;
        // 07 - 06 = 01
        addU_in = 1; #clockPeriod; addU_in = 0; #clockPeriod;
        enter_in = 1; #clockPeriod; enter_in = 0; #clockPeriod;

        #(10*clockPeriod);
        $stop;
    end
endmodule
