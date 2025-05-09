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
    

endmodule