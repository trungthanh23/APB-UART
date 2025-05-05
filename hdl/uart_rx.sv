module uart_rx (
    / Global signals
    input           clk,
    input           rst_n,

    // Baudrate generator signals
    input           tx_tick,

    //Register block signals
    input         [1 :0]   data_bit_num_i,
    input                  start_tx_i,
    input                  parity_en_i,
    input                  parity_type_i,
    input                  stop_bit_num_i,
    output  logic          rx_done_o, 
    output  logic [31:0]   rx_data_o,

    // Peripheral signals
    input           rx,
    output logic    rts_n
);
    enum logic [1:0]{
        TX_IDLE  = 2'b00,
        TX_START = 2'b01,
        TX_DATA  = 2'b10,
        TX_STOP  = 2'b11
    } current_state, next_state;

    logic [3:0] data_rx_count;
    logic [1:0] stop_rx_count;
    logic [3:0] num_data_bit_rx;
    logic [1:0] num_stop_bit_rx;
    
endmodule