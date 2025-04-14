module baudrate_generator#(
    parameter CFG_BAUDRATE = 115200;
    parameter CFG_CLK_FREQ = 50000000; 
)(
    input clk,
    input rst_n,
    output tx_tick,
    output rx_tick,
);
    
endmodule