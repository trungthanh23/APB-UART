/*******************************************************************************
 *    Copyright (C) 2025 by Dolphin Technology
 *    All right reserved.
 *
 *    Copyright Notification
 *    No part may be reproduced except as authorized by written permission.
 *
 *    File Name   : apb_uart_standard_test.sv
 *    Company     : Dolphin Technology
 *    Project     : dti_apb_uart
 *    Author      : hoangts0
 *    Module/Class: apb_uart_standard_test
 *    Create Date : May 20 2025
 *    Last Update : May 20 2025
 *    Description : 
 ******************************************************************************
  History:

 ******************************************************************************/
class apb_uart_strb_test extends apb_uart_base_test;
  `uvm_component_utils(apb_uart_strb_test)

  uart_rx_seq             rx_seq;
  uart_tx_seq             tx_seq;

  apb_seq_write_cfg_reg      seq_w_cfg;
  apb_seq_write_ctrl_reg     seq_w_ctrl;
  apb_seq_write_tx_data_reg  seq_w_tx;
  apb_seq_read_stt_reg       seq_r_stt;
  apb_seq_read_ctrl_reg      seq_r_ctrl;
  apb_seq_read_cfg_reg       seq_r_cfg;
  apb_seq_read_tx_data_reg   seq_r_tx_data;
  apb_seq_read_rx_data_reg   seq_r_rx_data;
extern function new(string name = "apb_uart_strb_test", uvm_component parent=null);
  extern task     run_phase(uvm_phase phase);

endclass : apb_uart_strb_test

function apb_uart_strb_test::new(string name = "apb_uart_strb_test", uvm_component parent=null);
    super.new(name, parent);
  endfunction

task apb_uart_strb_test::run_phase (uvm_phase phase);
    phase.raise_objection(this);

      
      seq_r_stt  = apb_seq_read_stt_reg::type_id::create("seq_r_stt");
      seq_r_stt.start(apb_uart_env.apb_agent.sequencer);
      seq_r_cfg  = apb_seq_read_cfg_reg::type_id::create("seq_r_cfg");
      seq_r_cfg.start(apb_uart_env.apb_agent.sequencer);
      seq_r_ctrl = apb_seq_read_ctrl_reg::type_id::create("seq_r_ctrl");
      seq_r_ctrl.start(apb_uart_env.apb_agent.sequencer);
      seq_r_tx_data  = apb_seq_read_tx_data_reg::type_id::create("seq_r_tx_data");
      seq_r_tx_data.start(apb_uart_env.apb_agent.sequencer);
      seq_r_rx_data  = apb_seq_read_rx_data_reg::type_id::create("seq_r_rx_data");
      seq_r_rx_data.start(apb_uart_env.apb_agent.sequencer);

      seq_w_cfg  = apb_seq_write_cfg_reg::type_id::create("seq_w_cfg");
      seq_w_cfg.randomize();
      seq_w_cfg.start(apb_uart_env.apb_agent.sequencer);

      seq_w_tx   = apb_seq_write_tx_data_reg::type_id::create("seq_w_tx");
      seq_w_tx.tx_data  = 8'h17;
      seq_w_tx.start(apb_uart_env.apb_agent.sequencer);

      seq_w_ctrl = apb_seq_write_ctrl_reg::type_id::create("seq_w_ctrl");
      seq_w_ctrl.start_tx = 1'b1;
      seq_w_ctrl.start(apb_uart_env.apb_agent.sequencer);
 

    phase.drop_objection(this);
  endtask

