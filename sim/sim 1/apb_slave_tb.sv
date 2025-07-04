`timescale 1ns/1ps

module tb_apb_slave;

    // Clock and Reset
    logic clk;
    logic reset_n;
    logic pclk;
    logic preset_n;

    // APB Signals
    logic psel;
    logic penable;
    logic pwrite;
    logic [11:0] paddr;
    logic [3:0]  pstrb;
    logic [31:0] pwdata;
    logic        pready;
    logic        pslverr;
    logic [31:0] prdata;

    // Register Interface
    logic        parity_error_i;
    logic        write_en_i;
    logic        read_en_i;
    logic [31:0] prdata_i;
    logic        pwrite_o;
    logic        psel_o;
    logic        penable_o;
    logic [3:0]  pstrb_o;
    logic [31:0] pwdata_o;
    logic [11:0] paddr_o;

    // Clock generation
    always #5 pclk = ~pclk;

    // DUT instance
    apb_slave #(
        .ADDR_MIN(12'h000),
        .ADDR_MAX(12'h010)
    ) dut (
        .clk(clk),
        .reset_n(reset_n),
        .pclk(pclk),
        .preset_n(preset_n),
        .psel(psel),
        .penable(penable),
        .pwrite(pwrite),
        .paddr(paddr),
        .pstrb(pstrb),
        .pwdata(pwdata),
        .pready(pready),
        .pslverr(pslverr),
        .prdata(prdata),
        .parity_error_i(parity_error_i),
        .write_en_i(write_en_i),
        .read_en_i(read_en_i),
        .prdata_i(prdata_i),
        .pwrite_o(pwrite_o),
        .pstrb_o(pstrb_o),
        .psel_o(psel_o),
        .penable_o(penable_o),
        .pwdata_o(pwdata_o),
        .paddr_o(paddr_o)
    );

    // Task to simulate a single APB transaction
    task automatic apb_write(input [11:0] addr, input [31:0] data);
        begin
            @(posedge pclk);
            psel      <= 1;
            penable   <= 0;
            pwrite    <= 1;
            paddr     <= addr;
            pwdata    <= data;
            pstrb     <= 4'b1111;
            write_en_i <= 1;
            read_en_i  <= 0;
            @(posedge pclk);
            penable <= 1;
            @(posedge pclk);
            wait (pready);
            @(posedge pclk);
            penable <= 0;
            psel    <= 0;
        end
    endtask

    task automatic apb_read(input [11:0] addr);
        begin
            @(posedge pclk);
            psel      <= 1;
            penable   <= 0;
            pwrite    <= 0;
            paddr     <= addr;
            pstrb     <= 4'b0000;
            write_en_i <= 0;
            read_en_i  <= 1;
            @(posedge pclk);
            penable <= 1;
            @(posedge pclk);
            wait (pready);
            @(posedge pclk);
            $display("Read from addr %h: %h", addr, prdata);
            penable <= 0;
            psel    <= 0;
        end
    endtask

    initial begin
        // Init
        pclk = 0;
        clk  = 0;
        reset_n = 0;
        preset_n = 0;
        psel = 0;
        penable = 0;
        pwrite = 0;
        paddr = 0;
        pstrb = 0;
        pwdata = 0;
        parity_error_i = 0;
        prdata_i = 32'hDEADBEEF;
        write_en_i = 0;
        read_en_i  = 0;

        // Reset
        #20;
        reset_n = 1;
        preset_n = 1;

        // WRITE TX DATA
        $display(">> WRITE TX DATA");
        apb_write(12'h000, 32'h12345678);

        // READ STT REG
        $display(">> READ STT REG");
        parity_error_i = 1;
        apb_read(12'h010);

        // WRITE CFG REG
        $display(">> WRITE CFG REG");
        apb_write(12'h008, 32'hCAFEBABE);

        // READ RX DATA (expect no pready if write_en_i is 0)
        $display(">> READ RX DATA");
        apb_read(12'h004);

        #50;
        $display(">> END SIM");
        $finish;
    end

endmodule
