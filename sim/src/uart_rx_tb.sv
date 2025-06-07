`timescale  1ns/1ns
module uart_rx_tb;
    logic        clk;
    logic        rst_n;
    logic        rx_tick;
    logic [1 :0]  data_bit_num_i;
    logic         parity_en_i;
    logic         parity_type_i;
    logic         stop_bit_num_i;
    logic         rx_done_o;
    logic         parity_error_o;
    logic [31:0]  rx_data_o;
    logic         rx;
    logic         rts_n;

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

task name(port_list);
    
endtask

endmodule