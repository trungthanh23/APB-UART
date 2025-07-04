/*******************************************************************************
 *    Copyright (C) 2025 by Dolphin Technology
 *    All right reserved.
 *
 *    Copyright Notification
 *    No part may be reproduced except as authorized by written permission.
 *
 *    File Name   : apb_seq_write_ctrl_reg.sv
 *    Company     : Dolphin Technology
 *    Project     : dti_apb_uart
 *    Author      : hoangts0
 *    Module/Class: apb_seq_write_ctrl_reg
 *    Create Date : May 20 2025
 *    Last Update : May 20 2025
 *    Description : 
 ******************************************************************************
  History:

 ******************************************************************************/
class apb_seq_write_ctrl_reg extends apb_seq_base;
  `uvm_object_utils(apb_seq_write_ctrl_reg)

  rand bit   start_tx;

  constraint ctrl_reg_const {
    soft start_tx == 1'b0;
    }

  extern function new(string name = "apb_seq_write_ctrl_reg");
  extern task     body();

  virtual task pre_start();
    super.pre_start();
    $display("@ %-10d: %0s", $time, get_sequence_path());
  endtask
endclass

  function apb_seq_write_ctrl_reg::new(string name = "apb_seq_write_ctrl_reg");
    super.new(name);
  endfunction

  task apb_seq_write_ctrl_reg::body();
    // Mode configure
    reg_id      = apb_regs.get_reg_by_name("reg_ctrl_reg");
    field_id    = reg_id.get_field_by_name("start_tx");
    value       = start_tx << field_id.get_lsb_pos();
  
    write_reg ("reg_ctrl_reg", value, status, UVM_FRONTDOOR);
  endtask