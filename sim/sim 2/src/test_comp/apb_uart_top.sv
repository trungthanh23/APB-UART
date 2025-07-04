/*******************************************************************************
 *    Copyright (C) 2025 by Dolphin Technology
 *    All right reserved.
 *
 *    Copyright Notification
 *    No part may be reproduced except as authorized by written permission.
 *
 *    File Name   : apb_uart_top.sv
 *    Company     : Dolphin Technology
 *    Project     : dti_apb_uart
 *    Author      : hoangts0
 *    Module/Class: apb_uart_top
 *    Create Date : May 20 2025
 *    Last Update : May 20 2025
 *    Description : 
 ******************************************************************************
  History:

 ******************************************************************************/

`ifdef XCELIUM
  `undef INCA
  `define INCA XCELIUM
`endif

  `include "dti_apb_macros.svh"
  `include "dti_uart_defines.sv"

  `include "dti_apb_master_intf.sv"
  `include "dti_apb_slave_intf.sv"
  `include "dti_apb_intf.sv"
  `include "dti_uart_tx_if.sv"
  `include "dti_uart_rx_if.sv"
  `include "dti_sys_intf.sv"
  `include "dti_apb_sva.sv"
module apb_uart_top;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  // Other packages
  import dti_uart_regs_pkg::*;
  import dti_apb_pkg::*;
  import dti_uart_pkg::*;
  import apb_seq_pkg::*;
  import uart_seq_pkg::*;
  import dti_sysclk_pkg::*;
  import dti_sysclk_dynamo_pkg::*;

  // Test
  `include "apb_uart_base_test.sv"
  `include "apb_uart_testcase_include.svh"

  // System interface
  dti_sys_intf intf_sys();

  // Apb interface
  dti_apb_intf                intf_apb();

  // Uart interface
  dti_uart_rx_if              intf_uart_rx();
  dti_uart_tx_if              intf_uart_tx();

  // Apb sva
  dti_apb_sva        apb_sva(.intf(intf_apb.master_intf));

  // RTL
  apb_uart #(
    .CFG_CLK_FREQ     (10000000),
    .CFG_BAUDRATE      (9600))
  dti_uart(
    .clk    (intf_sys.apb_clk),
    .reset_n(intf_sys.reset_n),
    .pclk   (intf_apb.master_intf.PCLK),
    .presetn(intf_apb.master_intf.PRESETn),
    .paddr  (intf_apb.master_intf.PADDR),
    .prdata (intf_apb.master_intf.PRDATA),
    .pwdata (intf_apb.master_intf.PWDATA),
    .psel   (intf_apb.master_intf.PSEL),
    .penable(intf_apb.master_intf.PENABLE),
    .pwrite (intf_apb.master_intf.PWRITE),
    .pstrb  (intf_apb.master_intf.PSTRB),
    .pready (intf_apb.master_intf.PREADY),
    .pslverr(intf_apb.master_intf.PSLVERR),
    .rx     (intf_uart_tx.uart_tx),
    .tx     (intf_uart_rx.uart_rx),
    .cts_n  (intf_uart_rx.rts_n),
    .rts_n  (intf_uart_tx.cts_n)
    );


  // Assign clk, reset_n
  assign intf_apb.PCLK    = intf_sys.apb_clk;
  assign intf_apb.PRESETn = intf_sys.reset_n;

  assign intf_uart_rx.clk = intf_sys.uart_clk;
  assign intf_uart_tx.clk = intf_sys.uart_clk;
  assign intf_uart_tx.reset_n = intf_sys.reset_n;
  assign intf_uart_rx.reset_n = intf_sys.reset_n;

  // UVM Root, factory
  uvm_root      _UVM_Root;
  uvm_factory   factory;

  // Set uvm_config_db
  initial begin
    _UVM_Root = uvm_root::get();

    factory = uvm_factory::get();
    factory.set_type_override_by_name("dti_sysclk_seq_item" , "dti_sysclk_dynamo_seq_item", 1);
    factory.set_type_override_by_name("dti_sysclk_seqr"     , "dti_sysclk_dynamo_seqr"    , 1);
    factory.set_type_override_by_name("dti_sysclk_drv"      , "dti_sysclk_dynamo_drv"     , 1);

    uvm_config_db #(virtual dti_sys_intf)  ::set(null , "sys_drv" , "intf" , intf_sys);
    uvm_config_db #(virtual dti_apb_intf)  ::set(uvm_root::get(), "uvm_test_top", "dti_apb_intf", intf_apb);
    uvm_config_db #(virtual dti_uart_rx_if)::set(uvm_root::get(), "uvm_test_top", "rx_if", intf_uart_rx);
    uvm_config_db #(virtual dti_uart_tx_if)::set(uvm_root::get(), "uvm_test_top", "tx_if", intf_uart_tx);

    uvm_reg::include_coverage("*", UVM_CVR_ALL);
    _UVM_Root.run_test("apb_uart_standard_test");
  end


endmodule