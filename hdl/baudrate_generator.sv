module baudrate_generator#(
    parameter CFG_BAUDRATE = 115200;
    parameter CFG_CLK_FREQ = 50000000; 
)(
    input clk,
    input rst_n,
    output tx_tick,
    output rx_tick,
);
    localparam TX_COUNT_TO = CFG_CLK_FREQ / (CFG_BAUDRATE * 16);
    localparam RX_COUNT_TO = CFG_CLK_FREQ / (CFG_BAUDRATE * 16);
    localparam TX_COUNT_WIDTH = $clog2(TX_COUNT_MAX);
    localparam RX_COUNT_WIDTH = $clog2(RX_COUNT_MAX);

    logic [TX_COUNT_WIDTH-1:0] tx_count;
    logic [RX_COUNT_WIDTH-1:0] rx_count;

    //Counting for TX
    always_ff @(posedge clk or negedge rst_n) begin : proc_tx_count
        if(~rst_n) begin
            tx_count <= 0;
        end else begin
            if (tx_count != TX_COUNT_TO) begin
                tx_count <= tx_count + 1;
            end else begin
                tx_count <= 0;
            end
        end
    end

    //Counting for RX
    always_ff @(posedge clk or negedge rst_n) begin : proc_rx_count
        if(~rst_n) begin
            rx_count <= 0;
        end else begin
            if (rx_count != RX_COUNT_TO) begin
                rx_count <= rx_count + 1;
            end else begin
                rx_count <= 0;
            end
        end
    end

    //Tick generation for TX and RX
    assign tx_tick = (tx_count == TX_COUNT_TO);
    assign rx_tick = (rx_count == RX_COUNT_TO);
endmodule