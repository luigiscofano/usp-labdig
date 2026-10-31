/* --------------------------------------------------------------------------
 *  Arquivo   : contador_cm_uc-PARCIAL.v
 * --------------------------------------------------------------------------
 *  Descricao : unidade de controle do componente contador_cm
 *              
 *              incrementa contagem de cm a cada sinal de tick enquanto
 *              o pulso de entrada permanece ativo
 *              
 * --------------------------------------------------------------------------
 *  Revisoes  :
 *      Data        Versao  Autor             Descricao
 *      07/09/2024  1.0     Edson Midorikawa  versao em Verilog
 * --------------------------------------------------------------------------
 */

module contador_cm_UC (
    input wire clock,
    input wire reset,
    input wire pulso,
    input wire tick,
    output reg zera_tick,
    output reg conta_tick,
    output reg zera_bcd,
    output reg conta_bcd,
    output reg pronto
);
    reg [2:0] Eatual, Eprox;

    // Estados
    localparam inicial      = 3'b000; // idle/prev
    localparam espera_subir = 3'b001; // opcional (mesma função do inicial)
    localparam contando     = 3'b010; // pulso=1: contar ticks e BCD
    localparam finalizado   = 3'b011; // gera 'pronto' por 1 ciclo

    // Estado
    always @(posedge clock, posedge reset)
        if (reset) Eatual <= inicial;
        else       Eatual <= Eprox;

    // Próximo estado
    always @(*) begin
        case (Eatual)
            inicial:
                Eprox = pulso ? contando : inicial;

            espera_subir: // (não usado; pode ficar igual ao inicial)
                Eprox = pulso ? contando : espera_subir;

            contando:
                Eprox = pulso ? contando : finalizado;

            finalizado:
                Eprox = inicial;

            default:
                Eprox = inicial;
        endcase
    end

    // Saídas (Moore) — nota: conta_bcd é "tick-gated"
    always @(*) begin
        // defaults
        zera_tick = 1'b0;
        conta_tick= 1'b0;
        zera_bcd  = 1'b0;
        conta_bcd = 1'b0;
        pronto    = 1'b0;

        case (Eatual)
            inicial: begin
                zera_tick = 1'b1;  // garante tick ressetado
                zera_bcd  = 1'b1;  // limpa BCD para nova medida
            end

            contando: begin
                conta_tick = 1'b1;      // faz o contador_m andar
                conta_bcd  = tick;      // 1 incremento por tick
            end

            finalizado: begin
                pronto = 1'b1;          // pulso de "medida pronta"
            end
        endcase
    end
    
endmodule