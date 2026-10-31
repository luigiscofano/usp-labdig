// ---------------------------------------------------------------------
// serial_tx_7e1.v
// Transmissor UART 7E1: start(0) + 7 dados (LSB-first) + paridade EVEN + 1 stop
// Handshake: start (pulso de 1 ciclo quando pronto=1), pronto (1=ocioso).
// Linha TX em idle alto.
// Parâmetros usuais: CLK_HZ=50_000_000, BAUD=115_200  -> ~434 clocks/bit
// ---------------------------------------------------------------------
module serial_tx_7e1 #(
    parameter integer CLK_HZ = 50_000_000,
    parameter integer BAUD   = 115_200
)(
    input  wire       clock,
    input  wire       reset,   // ativo em alto
    input  wire       start,   // pulso de 1 ciclo quando pronto=1
    input  wire [6:0] data7,   // caractere ASCII em 7 bits
    output reg        pronto,  // 1 = pode aceitar novo start
    output reg        tx       // linha serial (idle=1)
);
    // clocks por bit (arredondado)
    localparam integer CLKS_PER_BIT = (CLK_HZ + (BAUD/2)) / BAUD;

    // Estados
    localparam [2:0]
        S_IDLE  = 3'd0,
        S_START = 3'd1,
        S_DATA  = 3'd2,
        S_PAR   = 3'd3,
        S_STOP  = 3'd4;

    reg [2:0] state, next_state;

    // contador de clocks do bit
    reg [$clog2(CLKS_PER_BIT)-1:0] bitclk_cnt;
    wire tick_bit = (bitclk_cnt == CLKS_PER_BIT-1);

    // índice do bit de dados e registradores
    reg [2:0] bit_idx;       // 0..6
    reg [6:0] data_latch;    // dado latched no start aceito
    reg       parity_even;   // bit de paridade EVEN (= ~xor dos 7 dados)

    // Estado & temporização
    always @(posedge clock or posedge reset) begin
        if (reset) begin
            state      <= S_IDLE;
            bitclk_cnt <= 0;
        end else begin
            state <= next_state;
            if (state == S_IDLE)
                bitclk_cnt <= 0;
            else
                bitclk_cnt <= tick_bit ? 0 : (bitclk_cnt + 1'b1);
        end
    end

    // Próximo estado
    always @(*) begin
        next_state = state;
        case (state)
            S_IDLE:  next_state = (start && pronto) ? S_START : S_IDLE;
            S_START: next_state = tick_bit ? S_DATA  : S_START;
            S_DATA:  next_state = (tick_bit && (bit_idx == 3'd6)) ? S_PAR : S_DATA;
            S_PAR:   next_state = tick_bit ? S_STOP  : S_PAR;
            S_STOP:  next_state = tick_bit ? S_IDLE  : S_STOP;
            default: next_state = S_IDLE;
        endcase
    end

    // Saídas/registradores
    always @(posedge clock or posedge reset) begin
        if (reset) begin
            pronto      <= 1'b1;
            tx          <= 1'b1;   // idle alto
            bit_idx     <= 3'd0;
            data_latch  <= 7'd0;
            parity_even <= 1'b0;
        end else begin
            case (state)
                S_IDLE: begin
                    pronto  <= 1'b1;
                    tx      <= 1'b1;
                    bit_idx <= 3'd0;
                    if (start && pronto) begin
                        data_latch  <= data7;
                        parity_even <= ~(^data7); // EVEN
                        pronto      <= 1'b0;      // ocupado até terminar
                    end
                end

                S_START: begin
                    tx <= 1'b0; // start bit
                end

                S_DATA: begin
                    tx <= data_latch[bit_idx]; // LSB-first
                    if (tick_bit) begin
                        if (bit_idx != 3'd6) bit_idx <= bit_idx + 1'b1;
                        else                 bit_idx <= 3'd0;
                    end
                end

                S_PAR: begin
                    tx <= parity_even; // bit de paridade
                end

                S_STOP: begin
                    tx <= 1'b1; // stop bit
                    if (tick_bit) pronto <= 1'b1; // liberado para próximo start
                end

                default: begin
                    pronto <= 1'b1;
                    tx     <= 1'b1;
                end
            endcase
        end
    end
endmodule
