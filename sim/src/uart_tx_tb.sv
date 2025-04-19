`timescale 1ns / 1ps

module uart_tx_tb;

    // Parameters
    localparam CLK_PERIOD = 10; // 100 MHz clock
    localparam BAUD_RATE = 9600;
    localparam TICKS_PER_BIT = 100_000_000 / BAUD_RATE; // Clock ticks per baud

    // Signals
    logic clk;
    logic rst_n;
    logic tx_tick;
    logic [31:0] tx_data_i;
    logic [1:0] data_bit_num_i;
    logic start_tx_i;
    logic parity_en_i;
    logic parity_type_i;
    logic stop_bit_num_i;
    logic cts_n;
    logic tx;
    logic tx_done_o;

    // Instantiate the DUT
    uart_tx dut (
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

    // Clock generation
    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end

    // Baud tick generation
    initial begin
        tx_tick = 0;
        forever begin
            #(CLK_PERIOD * TICKS_PER_BIT);
            tx_tick = 1;
            #CLK_PERIOD;
            tx_tick = 0;
        end
    end

    // Test procedure
    initial begin
        // Initialize signals
        rst_n = 0;
        tx_data_i = 0;
        data_bit_num_i = 2'b11; // 8 bits
        start_tx_i = 0;
        parity_en_i = 0;
        parity_type_i = 0; // Even parity
        stop_bit_num_i = 1;
        cts_n = 0;

        // Reset
        #100;
        rst_n = 1;
        #100;

        // Test case 1: 8 data bits, no parity, 1 stop bit
        $display("Test case 1: 8 data bits, no parity, 1 stop bit");
        tx_data_i = 32'hA5; // Data to transmit: 10100101
        data_bit_num_i = 2'b11; // 8 bits
        parity_en_i = 0;
        stop_bit_num_i = 1;
        start_tx_i = 1;
        #CLK_PERIOD;
        start_tx_i = 0;

        // Wait for transmission to complete
        wait(tx_done_o);
        #1000;

        // Test case 2: 7 data bits, even parity, 2 stop bits
        $display("Test case 2: 7 data bits, even parity, 2 stop bits");
        tx_data_i = 32'h7F; // Data to transmit: 1111111
        data_bit_num_i = 2'b10; // 7 bits
        parity_en_i = 1;
        parity_type_i = 0; // Even parity
        stop_bit_num_i = 1;
        start_tx_i = 1;
        #CLK_PERIOD;
        start_tx_i = 0;

        // Wait for transmission to complete
        wait(tx_done_o);
        #1000;

        // Test case 3: 6 data bits, odd parity, 1 stop bit
        $display("Test case 3: 6 data bits, odd parity, 1 stop bit");
        tx_data_i = 32'h3C; // Data to transmit: 111100
        data_bit_num_i = 2'b01; // 6 bits
        parity_en_i = 1;
        parity_type_i = 1; // Odd parity
        stop_bit_num_i = 1;
        start_tx_i = 1;
        #CLK_PERIOD;
        start_tx_i = 0;

        // Wait for transmission to complete
        wait(tx_done_o);
        #1000;

        // Test case 4: 5 data bits, no parity, no stop bit
        $display("Test case 4: 5 data bits, no parity, no stop bit");
 tx_data_i = 32'h1F; // Data to transmit: 11111
        data_bit_num_i = 2'b00; // 5 bits
        parity_en_i = 0;
        stop_bit_num_i = 0;
        start_tx_i = 1;
        #CLK_PERIOD;
        start_tx_i = 0;

        // Wait for transmission to complete
        wait(tx_done_o);
        #1000;

        // Test case 5: Transmission with CTS disabled
        $display("Test case 5: Transmission with CTS disabled");
        cts_n = 1; // Disable transmission
        tx_data_i = 32'hAA; // Data to transmit: 10101010
        data_bit_num_i = 2'b11; // 8 bits
        parity_en_i = 0;
        stop_bit_num_i = 1;
        start_tx_i = 1;
        #CLK_PERIOD;
        start_tx_i = 0;

        // Wait some time and check tx remains high
        #(CLK_PERIOD * TICKS_PER_BIT * 10);
        if (tx == 1) $display("CTS test passed: No transmission occurred");
        else $display("CTS test failed: Transmission occurred");

        // End simulation
        #1000;
        $finish;
    end

    // Monitor signals
    initial begin
        $monitor("Time=%0t rst_n=%b current_state=%0d tx=%b tx_done_o=%b tx_data_i=%h",
                 $time, rst_n, dut.current_state, tx, tx_done_o, tx_data_i);
    end

endmodule