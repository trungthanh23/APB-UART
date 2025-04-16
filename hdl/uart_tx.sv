module uart_tx(
    //Gold signals
    input           clk,
    input           rst_n,

    //Baudrate generator signals
    input           tx_tick,

    //Register block signals
    input   [31:0]  tx_data_i,
    input   [1 :0]  data_bit_num_i,
    input           start_tx_i,
    input           parity_en_i,
    input           parity_type_i,
    input           stop_bit_num_i,
    output  logic   tx_done_o,
    output  logic   parity_error_o,
    //Peripheral signals 
    input           cts_n,
    output  logic   tx
);
    //State machine states
    enum logic [2:0] {
        TX_IDLE  =  2'b00,
        TX_START =  2'b01,
        TX_DATA  =  2'b10,
        TX_STOP  =  2'b11
    } current_state, next_state;

    localparam data_tx_count = 0;

    //Current state
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= TX_IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    //Next state
    always_comb begin
        case (current_state)
            TX_IDLE: begin
                if (start_tx_i && !cts_n) begin
                    next_state <= TX_START;
                end else begin
                    next_state <= TX_IDLE;
                end
            end
            TX_START:begin
                if (tx_tick) begin
                    next_state <= TX_DATA;
                end else begin
                    next_state <= TX_START;
                end
            end
            TX_DATA:begin
                if () begin
                    next_state <= TX_STOP;
                end else begin
                    next_state <= TX_DATA;
                end
            end
            TX_STOP:begin
                if () begin
                    next_state <= TX_IDLE;
                end else begin
                    next_state <= TX_STOP;
                end
            end
            default: next_state <= TX_IDLE
        endcase
    end

endmodule