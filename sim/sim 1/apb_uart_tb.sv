module apb_uart_tb;
    logic                           clk;
    logic                           reset_n;
    logic [11:0]                    paddr;
    logic [31:0]                    pwdata;
    logic [3:0]                     pstrb;
    logic                           pwrite;
    logic                           psel;
    logic                           penable;
    logic [31:0]                    prdata;
    logic                           pready;
    logic                           pslverr;
    logic                           rx;
    logic                           tx;
    logic                           cts_n;
    logic                           rts_n;
    parameter baud_rate = 115200; 

    logic [31:0] read_data;

    apb_uart #(.CFG_BAUDRATE(115200),
               .CFG_CLK_FREQ(50000000)) apb_uart (
        .pclk   (clk),
        .presetn(reset_n),
        .clk    (clk),
        .reset_n (reset_n),
        .psel   (psel),
        .penable(penable),
        .pwrite (pwrite),
        .paddr  (paddr),
        .pwdata (pwdata),
        .pstrb  (pstrb),
        .prdata (prdata),
        .pready (pready),
        .pslverr(pslverr),
        .rx     (rx),
        .tx     (tx),
        .cts_n  (cts_n),
        .rts_n  (rts_n)
    );

    initial begin
        clk = 0;
        forever #10 clk = ~clk;  // 50MHz clock
    end

    // Task write data to TX_DATA register
    task Write_tx_data_reg(input logic [7:0] tx_data);
        @(posedge clk);
        psel    = 0; penable = 0; pwrite = 0; pstrb = 4'b0000; paddr = 12'h0; pwdata = 32'h0;
        @(posedge clk);
        psel    = 1; penable = 0; pwrite = 1; pstrb = 4'b1111; paddr = 12'h0; pwdata = tx_data;
        @(posedge clk);
        psel    = 1; penable = 1; pwrite = 1;
        @(posedge clk);
        while (pready == 0) @(posedge clk);
        if (pslverr) $display("Error: pslverr during TX_DATA write!");
        $display("TX_DATA write: %h", pwdata);
        psel    = 0; penable = 0; pwrite = 0; pstrb = 4'b0000; paddr = 12'h0; pwdata = 32'h0;
    endtask

    // Task write data to CFG register
    task Write_cfg_reg(input logic [4:0] cfg_data);
        @(posedge clk);
        psel    = 0; penable = 0; pwrite = 0; pstrb = 4'b0000; paddr = 12'h0; pwdata = 32'h0;
        @(posedge clk);
        psel    = 1; penable = 0; pwrite = 1; pstrb = 4'b1111; paddr = 12'h008;
        pwdata[1:0] = cfg_data[1:0]; pwdata[2] = cfg_data[2]; pwdata[3] = cfg_data[3]; pwdata[4] = cfg_data[4];
        @(posedge clk);
        psel    = 1; penable = 1; pwrite = 1;
        @(posedge clk);
        while (pready == 0) @(posedge clk);
        if (pslverr) $display("Error: pslverr during CFG write!");
        $display("CFG write: %h", pwdata);
        psel    = 0; penable = 0; pwrite = 0; pstrb = 4'b0000; paddr = 12'h0; pwdata = 32'h0;
    endtask

    // Task write data to CTRL register
    task Write_ctrl_reg(input logic start_tx);
        @(posedge clk);
        psel    = 0; penable = 0; pwrite = 0; paddr = 12'h0; pstrb = 4'b0000; pwdata = 32'h0;
        @(posedge clk);
        psel    = 1; penable = 0; pwrite = 1; pstrb = 4'b1111; paddr = 12'h00C; pwdata[0] = start_tx;
        @(posedge clk);
        psel    = 1; penable = 1; pwrite = 1;
        @(posedge clk);
        while (pready == 0) @(posedge clk);
        if (pslverr) $display("Error: pslverr during CTRL write!");
        $display("CTRL write: %h", pwdata);
        psel    = 0; penable = 0; pwrite = 0; pstrb = 4'b0000; paddr = 12'h0; pwdata = 32'h0;
    endtask

    // Task read data form RX_DATA register
    task Read_rx_data_reg();
        @(posedge clk);
        psel    = 0; penable = 0; pwrite = 0; paddr = 12'h004; 
        @(posedge clk);
        psel    = 1; penable = 0; pwrite = 0; paddr = 12'h004; 
        @(posedge clk);
        psel    = 1; penable = 1; pwrite = 0; 
        @(posedge clk);
        while (pready == 0) @(posedge clk);
        if (pslverr) $display("Error: pslverr during RX_DATA read!");
        wait (apb_uart.register_block.host_read_data_o == 1);
        @(posedge clk);
        $display("RX_DATA: %h", prdata); 
        read_data = prdata;
        psel    = 0; penable = 0; pwrite = 0; paddr = 12'h0;
        @(posedge clk);
    endtask

    // Task Virtiual RX receive data form TX
    task automatic send_tx;
        integer i, data_num, stop_num;
        logic [7:0] tx_data = apb_uart.register_block.tx_data_reg[7:0];
        case (apb_uart.register_block.cfg_reg[1:0])
            2'b00: data_num = 5;
            2'b01: data_num = 6;
            2'b10: data_num = 7;
            2'b11: data_num = 8;
        endcase
        case (apb_uart.register_block.cfg_reg[2])
            1'b0: stop_num = 1;
            1'b1: stop_num = 2;
        endcase
        wait (apb_uart.uart_core.tx == 0);
        for (i = 0; i < data_num; i++) wait (apb_uart.uart_core.tx_tick);
        if (apb_uart.register_block.cfg_reg[3]) wait (apb_uart.uart_core.tx_tick);
        for (i = 0; i < stop_num; i++) wait (apb_uart.uart_core.tx_tick);
        $display("TX received: %h", tx_data);
    endtask

    // Task  Virtual TX transmit data to RX
    task automatic send_rx(input [8:0] data);
        integer i, data_num, stop_num;
        case (apb_uart.register_block.data_bit_num_o)
            2'b00: data_num = 5;
            2'b01: data_num = 6;
            2'b10: data_num = 7;
            2'b11: data_num = 8;
        endcase
        case (apb_uart.register_block.stop_bit_num_o)
            1'b0: stop_num = 1;
            1'b1: stop_num = 2;
        endcase
        $display("TX send: %h", data);
        rx = 1'b0;
        repeat (434) @(posedge clk); 
        for (i = 0; i < data_num; i++) begin
            rx = data[i];
            repeat (434) @(posedge clk);
        end
        if (apb_uart.register_block.parity_en_o) begin
            rx = (apb_uart.register_block.parity_type_o) ? ~(^data) : (^data);
            repeat (434) @(posedge clk);
        end
        repeat (stop_num) begin
            rx = 1;
            repeat (434) @(posedge clk);
        end
        rx = 1;
    endtask

   initial begin
        cts_n = 1; reset_n = 0; pwdata = 32'h0; paddr = 12'h0; pstrb = 4'b0;
        pwrite = 0; psel = 0; penable = 0; rx = 1;
        @(posedge clk);
        reset_n = 1;
        $display("--------------------------------------------------------------");
        // Test Case 1: Host send data (TX)
        $display("Starting Test Case 1: TX (8-bit, 2 stop bits, odd parity)");
        Write_tx_data_reg(8'hA3); // Send 0xA3
        Write_cfg_reg(5'b11111); // 8-bit data (11), 2 stop bits (1), odd parity (1), enable TX (1)
        Write_ctrl_reg(1'b1); // Start TX
        @(posedge clk);
        cts_n = 0;
        send_tx();
        wait (apb_uart.register_block.tx_done_i == 1);
        $display("Test Case 1: TX done");
        repeat (50) @(posedge clk);

        $display("--------------------------------------------------------------");
        // Test Case 2: Virtual TX send first data (RX)
        $display("Starting Test Case 2: RX (8-bit, 2 stop bits, odd parity)");
        fork
            begin
                send_rx(8'b10110110); // Send 0xB6
                wait (apb_uart.register_block.rx_done_i == 1);
                Read_rx_data_reg();
                if (read_data[7:0] == 8'hB6)
                    $display("Test Case 2: RX data correct (0xB6)");
                else
                    $display("Test Case 2: RX data error, expected 0xB6, got %h", read_data);
            end
        join
        repeat (50) @(posedge clk);

        $display("--------------------------------------------------------------");
        // Test Case 3: Virtual TX send second data (RX)
        $display("Starting Test Case 3: RX (8-bit, 2 stop bits, odd parity)");
        fork
            begin
                send_rx(8'b01011010); // Send 0x5A
                wait (apb_uart.register_block.rx_done_i == 1);
                Read_rx_data_reg();
                if (read_data[7:0] == 8'h5A)
                    $display("Test Case 3: RX data correct (0x5A)");
                else
                    $display("Test Case 3: RX data error, expected 0x5A, got %h", read_data);
            end
        join
        repeat (50) @(posedge clk);

        $display("--------------------------------------------------------------");
        // Test Case 4: Additional TX with 6-bit data, 1 stop bit, even parity
        $display("Starting Test Case 4: TX (6-bit, 1 stop bit, even parity)");
        Write_cfg_reg(5'b01101); // 6-bit data (01), 1 stop bit (0), even parity (1), enable TX (1)
        Write_tx_data_reg(8'h2A); // Send 0x2A
        Write_ctrl_reg(1'b1); // Start TX
        cts_n = 0;
        send_tx();
        wait (apb_uart.register_block.tx_done_i == 1);
        $display("Test Case 4: TX done (0x2A)");
        repeat (50) @(posedge clk);

        $display("--------------------------------------------------------------");
        $display("All Test Cases Completed!");
        $stop;
    end
endmodule