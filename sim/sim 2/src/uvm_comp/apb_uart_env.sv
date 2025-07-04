/*******************************************************************************
 *    Copyright (C) 2025 by Dolphin Technology
 *    All right reserved.
 *
 *    Copyright Notification
 *    No part may be reproduced except as authorized by written permission.
 *
 *    File Name   : apb_uart_env.sv
 *    Company     : Dolphin Technology
 *    Project     : dti_apb_uart
 *    Author      : hoangts0
 *    Module/Class: apb_uart_env
 *    Create Date : May 20 2025
 *    Last Update : May 20 2025
 *    Description : 
 ******************************************************************************
  History:

 ******************************************************************************/


class apb_uart_env extends uvm_env;
  `uvm_component_utils(apb_uart_env)

  dti_apb_master_agent                        apb_agent;
  dti_apb_reg_adapter                         apb_adapter;
  uvm_reg_predictor#(dti_apb_master_item)     apb_predictor;
  dti_apb_config                              apb_cfg;

  dti_uart_regs                               apb_regs;

  dti_uart_configuration      uart_cfg;
  dti_uart_tx                 uart_tx;
  dti_uart_rx                 uart_rx;
  dti_sysclk_agent            sys_agent;

  // UART sequencer handle.
  // dti_uart_virtual_sequencer  virt_seqr;

  // dti_uart_scoreboard         scb;

  extern                   function      new(string name="apb_uart_env", uvm_component parent);
  extern virtual           function void build_phase(uvm_phase phase);
  extern virtual           function void connect_phase(uvm_phase phase);
  extern                   function void end_of_elaboration_phase(uvm_phase phase);
endclass

// Function: new
// Constructor of object.
function apb_uart_env::new(string name="apb_uart_env", uvm_component parent);
  super.new(name, parent);
endfunction



// Function: build_phase
// UVM built-in method.
function void apb_uart_env::build_phase(uvm_phase phase);
  super.build_phase(phase);
  `uvm_info(this.get_full_name(), "Build phase", UVM_NONE);
  sys_agent = dti_sysclk_agent::type_id::create("sys_agent", this);
  apb_agent = dti_apb_master_agent::type_id::create("apb_agent", this);
  apb_adapter = dti_apb_reg_adapter::type_id::create("apb_adapter", this);
  apb_predictor = uvm_reg_predictor#(dti_apb_master_item)::type_id::create("apb_predictor", this);
  apb_regs = dti_uart_regs::type_id::create("apb_regs", this);
  apb_regs.build();
  apb_regs.lock_model();
  uvm_config_db#(dti_uart_regs)::set(null, "*", "apb_regs", apb_regs);

  if (!uvm_config_db #(dti_apb_config)::get(null, "*", "apb_cfg", apb_cfg)) begin
    `uvm_fatal("build_phase", "Cannot get apb configuration.")
  end
  uvm_config_db#(dti_apb_master_config)::set(this, "apb_agent","master_cfg", apb_cfg.master_cfg);

  if (!uvm_config_db #(dti_uart_configuration)::get(null, "*", "uart_cfg", uart_cfg) && uart_cfg == null) begin
    `uvm_fatal("build_phase", "Cannot get uart configuration.");
  end
  // uvm_config_db#(dti_uart_configuration)::set(this, "sys_agent","uart_cfg", uart_cfg);

  // virt_seqr = dti_uart_virtual_sequencer::type_id::create("virt_seqr", this);

  uart_tx = dti_uart_tx::type_id::create("uart_tx", this);
  uart_rx = dti_uart_rx::type_id::create("uart_rx", this);
  // scb = dti_uart_scoreboard::type_id::create("scb", this);

  uvm_config_db #(dti_uart_configuration)::set(this, "uart_tx", "uart_tx_cfg", uart_cfg);
  uvm_config_db #(dti_uart_configuration)::set(this, "uart_rx", "uart_rx_cfg", uart_cfg);

  // virt_seqr.uart_cfg = uart_cfg;
endfunction

// Function: connect_phase
// UVM built-in method.
function void apb_uart_env::connect_phase(uvm_phase phase);
  `uvm_info(this.get_full_name(), "Connect phase", UVM_NONE);
    apb_predictor.map     = apb_regs.default_map;
    apb_predictor.adapter = apb_adapter;
    apb_agent.monitor.ap.connect(apb_predictor.bus_in);
    apb_regs.default_map.set_sequencer(apb_agent.sequencer, apb_adapter);
    apb_regs.default_map.set_auto_predict(0);

    // virt_seqr.tx_seqr = uart_tx.sequencer;
    // virt_seqr.rx_seqr = uart_rx.sequencer;
    // uart_tx.monitor.out_monitor_port.connect(scb.analysis_imp_tx);
    // uart_rx.monitor.out_monitor_port.connect(scb.analysis_imp_rx);
endfunction


// Function: end_of_elaboration_phase
// UVM built-in method.
function void apb_uart_env::end_of_elaboration_phase(uvm_phase phase);
  string  hdl_path = "";
  super.end_of_elaboration_phase(phase);
  `uvm_info(this.get_full_name(), "End-of-Elaboration Phase", UVM_NONE);
  void'(uvm_config_db #(string)::get(null, "env", "hdl_path", hdl_path));
  apb_regs.set_hdl_path_root(hdl_path);
  void'(apb_regs.set_coverage(UVM_CVR_ALL));
endfunction