`timescale 1ns / 1ps

module uart_tx_tb;

    // Inputs
    logic        clk;
    logic        rst_n;
    logic        tx_tick;
    logic [31:0] tx_data_i;
    logic [1:0]  data_bit_num_i;
    logic        start_tx_i;
    logic        parity_en_i;
    logic        parity_type_i;
    logic        stop_bit_num_i;
    logic        cts_n;

    // Outputs
    logic        tx;
    logic        tx_done_o;

    // Instantiate the UART TX module
    uart_tx uut (
        .clk(clk),
        .rst_n(rst_n),
        .tx_tick(tx_tick),
        .tx_data_i(tx_data_i),
        .data_bit_num_i(data_bit_num_i),
        .start_tx_i(start_tx_i),
        .parity_en_i(parity_en_i),
        .parity_type_i(parity_type_i),
        .stop_bit_num_i(stop_bit_num_i),
        .cts_n(cts_n),
        .tx(tx),
        .tx_done_o(tx_done_o)
    );

    // Clock generation (50 MHz)
    initial begin
        clk = 0;
        forever #10 clk = ~clk; // 20ns period
    end

    // Baud tick generation (simulate 230400 baud with 50 MHz clock)
    // 50 MHz / 230400 ≈ 217 cycles per bit
    integer tick_counter;
    initial begin
        tx_tick = 0;
        tick_counter = 0;
        forever begin
            @(posedge clk);
            if (tick_counter >= 217) begin
                tx_tick = 1;
                tick_counter = 0;
            end else begin
                tx_tick = 0;
                tick_counter = tick_counter + 1;
            end
        end
    end

    // Test stimulus
    initial begin
        // Initialize inputs
        rst_n = 0;
        tx_data_i = 0;
        data_bit_num_i = 2'b11; // 8 bits
        start_tx_i = 0;
        parity_en_i = 0; // No parity
        parity_type_i = 0; // Even parity (not used)
        stop_bit_num_i = 0; // 1 stop bit
        cts_n = 0; // Clear to send

        // Reset
        #100;
        rst_n = 1;

        // Test case 1: 8-bit data, no parity, 1 stop bit
        @(posedge clk);
        tx_data_i = 32'hA5; // Data = 10100101
        data_bit_num_i = 2'b11; // 8 bits
        parity_en_i = 0;
        stop_bit_num_i = 0;
        start_tx_i = 1;
        @(posedge clk);
        start_tx_i = 0;

        // Wait for transmission to complete
        @(posedge tx_done_o);
        #10000;

        // Test case 2: 7-bit data, even parity, 2 stop bits
        @(posedge clk);
        tx_data_i = 32'h7F; // Data = 1111111
        data_bit_num_i = 2'b10; // 7 bits
        parity_en_i = 1;
        parity_type_i = 0; // Even
        stop_bit_num_i = 1;
        start_tx_i = 1;
        @(posedge clk);
        start_tx_i = 0;

        // Wait for transmission to complete
        @(posedge tx_done_o);
        #10000;

        // Test case 3: 6-bit data, odd parity, 1 stop bit
        @(posedge clk);
        tx_data_i = 32'h3C; // Data = 111100
        data_bit_num_i = 2'b01; // 6 bits
        parity_en_i = 1;
        parity_type_i = 1; // Odd
        stop_bit_num_i = 0;
        start_tx_i = 1;
        @(posedge clk);
        start_tx_i = 0;

        // Wait for transmission to complete
        @(posedge tx_done_o);
        #10000;

        // End simulation
        $display("Simulation completed!");
        $finish;
    end

    // Monitor outputs
    initial begin
        $monitor("Time=%0t rst_n=%b tx=%b tx_done_o=%b tx_data_i=%h state=%s",
                 $time, rst_n, tx, tx_done_o, tx_data_i, uut.current_state);
    end

endmodule