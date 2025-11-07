module baudrate_generator #(
    parameter CFG_BAUDRATE = 115200,
    parameter CFG_CLK_FREQ = 50000000 
)(
    input clk,
    input reset_n, 
    output tx_tick,
    output rx_tick
);
    localparam COUNT_TO = CFG_CLK_FREQ / (CFG_BAUDRATE * 16);
    localparam COUNT_WIDTH = $clog2(COUNT_TO);

    logic [COUNT_WIDTH-1:0] tx_current_count, tx_next_count;
    logic [COUNT_WIDTH-1:0] rx_current_count, rx_next_count;

    // TX: Current count
    always_ff @(posedge clk or negedge reset_n) begin 
        if (~reset_n) begin
            tx_current_count <= 0;
        end else begin 
            tx_current_count <= tx_next_count;
        end
    end

    // TX: Next count
    always_comb begin
        if (tx_current_count != COUNT_TO) begin
            tx_next_count = tx_current_count + 1;
        end else begin
            tx_next_count = 0;
        end
    end

    // RX: Current count 
    always_ff @(posedge clk or negedge reset_n) begin 
        if (~reset_n) begin
            rx_current_count <= 0;
        end else begin 
            rx_current_count <= rx_next_count;
        end
    end

    // RX: Next count
    always_comb begin
        if (rx_current_count != COUNT_TO) begin
            rx_next_count = rx_current_count + 1;
        end else begin
            rx_next_count = 0;
        end
    end

    // Tick generation for TX and RX
    assign tx_tick = (tx_current_count == COUNT_TO); 
    assign rx_tick = (rx_current_count == COUNT_TO); 

endmodule
