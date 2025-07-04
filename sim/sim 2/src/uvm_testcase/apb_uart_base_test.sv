/*******************************************************************************
 *    Copyright (C) 2025 by Dolphin Technology
 *    All right reserved.
 *
 *    Copyright Notification
 *    No part may be reproduced except as authorized by written permission.
 *
 *    File Name   : apb_uart_base_test.sv
 *    Company     : Dolphin Technology
 *    Project     : dti_apb_uart
 *    Author      : hoangts0
 *    Module/Class: apb_uart_base_test
 *    Create Date : May 20 2025
 *    Last Update : May 20 2025
 *    Description : 
 ******************************************************************************
  History:

 ******************************************************************************/
`include "../uvm_comp/apb_uart_env.sv"
class apb_uart_base_test extends uvm_test;
  `uvm_component_utils(apb_uart_base_test)

  apb_uart_env                   env;
  dti_apb_config                 apb_cfg;
  dti_uart_configuration         uart_cfg;
  dti_sysclk_generator           sys_clk;


  function new(string name = "apb_uart_base_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction //  new

  /** Build phase */
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(this.get_full_name(), "Build Phase", UVM_NONE)
    env = apb_uart_env::type_id::create("env", this);

    apb_cfg  = dti_apb_config::type_id::create("apb_cfg");
    uart_cfg = dti_uart_configuration::type_id::create("uart_cfg");

    if (!uvm_config_db#(virtual dti_apb_intf)::get(null, get_full_name(), "dti_apb_intf", apb_cfg.apb_intf)) begin
      `uvm_fatal("apb_uart_base_test", "Can not Get apb_intf!");
    end
    if (!uvm_config_db#(virtual dti_uart_tx_if)::get(null, get_full_name(), "tx_if", uart_cfg.tx_if)) begin
      `uvm_fatal("apb_uart_base_test", "Can not Get tx_if!");
    end
    if (!uvm_config_db#(virtual dti_uart_rx_if)::get(null, get_full_name(), "rx_if", uart_cfg.rx_if)) begin
      `uvm_fatal("apb_uart_base_test", "Can not Get rx_if!");
    end

    uart_cfg.fCK_MHz = 10;
    uart_cfg.randomize_tCK_ns();
    uart_cfg.randomize_bit_rate();

    // Create sub configs
    apb_cfg.create_sub_configs();
    uvm_config_db#(dti_apb_config)::set(null, "*", "apb_cfg", apb_cfg);
    // uvm_config_db#(virtual dti_apb_master_intf)::set(null, "uvm_test_top", "master_intf", apb_vif.master_intf);
    uvm_config_db#(dti_uart_configuration)::set(null, "*", "uart_cfg", uart_cfg);
    uvm_config_int::set(this, "env.agent", "is_active", UVM_ACTIVE);

  endfunction


  virtual task run_phase (uvm_phase phase);
    sys_clk = dti_sysclk_generator::type_id::create("sys_clk", this);
    if (phase!=null) begin
      phase.raise_objection(this);
      `uvm_info("run_phase","Starting of the test apb_uart_base_test", UVM_LOW);
    end

    generate_clock();

    phase.drop_objection(this);
  endtask

  virtual function void end_of_elaboration_phase (uvm_phase phase);
     uvm_top.print_topology();
  endfunction

  virtual function void check_phase(uvm_phase phase);
    check_config_usage();
  endfunction

  function void final_phase(uvm_phase phase);
    super.final_phase(phase);
    `uvm_info(this.get_full_name(), "Final Phase", UVM_NONE)
  endfunction //  final_phase

  task generate_clock();
    assert(sys_clk.randomize());
    sys_clk.start(env.sys_agent.seqr);
  endtask : generate_clock
endclass