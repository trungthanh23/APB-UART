module apb_uart baudrate_generator#(
    parameter CFG_BAUDRATE = 115200,
    parameter CFG_CLK_FREQ = 50000000 
)(
    // Global signals
    input               clk,
    input               reset_n,

    //Communication with CPU signal
    input               pclk,
    input               preset_n,
    input               psel,
    input  logic        penable,
    input  logic        pwrite,
    input  logic [11:0] paddr,
    input  logic [3 :0] pstrb,
    input  logic [31:0] pwdata,
    output logic        pready,
    output logic        pslverr,
    output logic [31:0] prdata,

    //Peripheral signals
    input               rx,
    input               cts_n,
    output              tx,
    output              rst_n
);
    //apb_slave - regitster_block signals
    wire         parity_error_apb_reg;
    wire         write_en_apb_reg;
    wire         read_en_apb_reg;
    wire  [31:0] prdata_apb_reg;
    wire         pwrite_apb_reg;
    wire  [3:0]  pstrb_apb_reg;
    wire         psel_apb_reg;
    wire         penable_apb_reg;
    wire  [31:0] pwdata_apb_reg;
    wire  [11:0] paddr_apb_reg;

    //register_block - uart_core signals
    wire         tx_done_reg_uart;
    wire         rx_done_reg_uart;
    wire         parity_error_reg_uart;
    wire  [31:0] rx_data_reg_uart;
    wire  [31:0] tx_data_reg_uart;
    wire  [1:0]  data_bit_num_reg_uart;
    wire         stop_bit_num_reg_uart;
    wire         parity_en_reg_uart;
    wire         parity_type_reg_uart;
    wire         start_tx_reg_uart;

    //Baudrate signals
    wire         tick_tx;
    wire         tick_rx;

    apb_slave apb_slave (
        .clk(clk),
        .reset_n(reset_n),
        .pclk(pclk),
        .psel(psel),
        .penable(penable),
        .pwrite(pwrite),
        .paddr(paddr),
        .pstrb(pstrb),
        .pwdata(pwdata),
        .pready(pready),
        .pslverr(pslverr),
        .prdata(prdata),
        .parity_error_i(parity_error_apb_reg),
        .write_en_i(write_en_apb_reg),
        .read_en_i(read_en_apb_reg),
        .prdata_i(prdata_apb_reg),
        .pwrite_o(pwrite_apb_reg),
        .pstrb_o(pstrb_apb_reg),
        .psel_o(psel_apb_reg),
        .penable_o(penable_apb_reg),
        .pwdata_o(pwdata_apb_reg),
        .paddr_o(paddr_apb_reg)
    );

    register_block register_block(
        .pwrite_i(pwrite_apb_reg),
        .psel_i(psel_apb_reg),
        .penable_i(penable_apb_reg),
        .pstrb_i(pstrb_apb_reg),
        .pwdata_i(pwdata_apb_reg),
        .paddr_i(paddr_apb_reg),
        .parity_error_o(parity_error_apb_reg),
        .write_en_o(write_en_apb_reg),
        .read_en_o(read_en_apb_reg),
        .prdata_o(prdata_apb_reg),
        .tx_done_i(tx_done_reg_uart),
        .rx_done_i(rx_done_reg_uart),
        .parity_error_i(parity_error_reg_uart),
        .rx_data_i(rx_data_reg_uart),
        .stop_bit_num_o(stop_bit_num_reg_uart),
        .parity_en_o(parity_en_reg_uart),
        .parity_type_o(parity_type_reg_uart),
        .start_tx_o(start_tx_reg_uart),
        .tx_data_o(tx_data_reg_uart),
        .data_bit_num_o(data_bit_num_reg_uart)
    );

    uart_core uart_core(
        .clk(clk),
        .rst_n(rst_n),
        .data_bit_num_i(data_bit_num_reg_uart),
        .parity_en_i(parity_en_reg_uart),
        .parity_type_i(parity_type_reg_uart),
        .stop_bit_num_i(stop_bit_num_reg_uart),
        .tx_data_i(tx_data_reg_uart),
        .start_tx_i(start_tx_reg_uart),
        .cts_n(cts_n),
        .tx_tick(tx_tick),
        .tx_done_o(tx_done_reg_uart),
        .tx(tx),
        .rx(rx),
        .rx_tick(rx_tick),
        .rts_n(rts_n),
        .rx_done_o(rx_done_reg_uart),
        .parity_error_o(parity_error_reg_uart),
        .rx_data_o(rx_data_reg_uart)
    );

    baudrate_generator baudrate_generator(
        .clk(clk),
        .rst_n(rst_n),
        .tx_tick(tx_tick),
        .rx_tick(rx_tick)
    );


endmodule