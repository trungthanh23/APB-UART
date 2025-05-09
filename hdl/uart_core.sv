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
    output  logic [31:0]   rx_data_o
);

    uart_tx uart_tx (
        
    );
    
endmodule