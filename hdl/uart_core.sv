module uart_core (
    //Global signals
    input                  clk,
    input                  rst_n,
    input         [1 :0]   data_bit_num_i,
    input                  parity_en_i,
    input                  parity_type_i,
    input                  stop_bit_num_i,

    //Register block - tx - peripheral
    input         [31:0]   tx_data_i,
    input                  start_tx_i,
    input                  cts_n,
    input                  tx_tick,
    output  logic          tx_done_o,
    output  logic          tx,

    //Register block - rx - peripheral
    input                  rx,
    input                  rx_tick,
    output  logic          rts_n,
    output  logic          rx_done_o, 
    output  logic          parity_error_o,
    output  logic [31:0]   rx_data_o
);

    uart_tx uart_tx (
        .clk(clk),
        .rst_n(rst_n),
        .tx_tick(tx_tick),
        .tx_data_i(tx_data_i),
        .data_bit_num_i(data_bit_num_i),
        .start_tx_i(start_tx_i),
        .parity_en_i(parity_en_i),
        .parity_type_i(parity_type_i),
        .stop_bit_num_i(stop_bit_num_i),
        .tx_done_o(tx_done_o),
        .cts_n(cts_n),
        .tx(tx)
    );

    uart_rx uart_rx (
        .clk(clk),
        .rst_n(rst_n),
        .rx_tick(rx_tick),
        .data_bit_num_i(data_bit_num_i),
        .parity_en_i(parity_en_i),
        .parity_type_i(parity_type_i),
        .stop_bit_num_i(stop_bit_num_i),
        .rx_done_o(rx_done_o),
        .parity_error_o(parity_error_o),
        .rx_data_o(rx_data_o),
        .rx(rx),
        .rts_n(rts_n)
    );
    
endmodule