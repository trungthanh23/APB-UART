/*******************************************************************************
 *    Copyright (C) 2025 by Dolphin Technology
 *    All right reserved.
 *
 *    Copyright Notification
 *    No part may be reproduced except as authorized by written permission.
 *
 *    File Name   : apb_seq_write_tx_data_reg.sv
 *    Company     : Dolphin Technology
 *    Project     : dti_apb_uart
 *    Author      : hoangts0
 *    Module/Class: apb_seq_write_tx_data_reg
 *    Create Date : May 20 2025
 *    Last Update : May 20 2025
 *    Description : 
 ******************************************************************************
  History:

 ******************************************************************************/
class apb_seq_write_tx_data_reg extends apb_seq_base;
  `uvm_object_utils(apb_seq_write_tx_data_reg)

  rand bit [7:0]  tx_data;


  extern function new(string name = "apb_seq_write_tx_data_reg");
  extern task     body();

  virtual task pre_start();
    super.pre_start();
    $display("@ %-10d: %0s", $time, get_sequence_path());
  endtask
endclass

  function apb_seq_write_tx_data_reg::new(string name = "apb_seq_write_tx_data_reg");
    super.new(name);
  endfunction

  task apb_seq_write_tx_data_reg::body();
    // Mode configure
    reg_id      = apb_regs.get_reg_by_name("reg_tx_data_reg");
    field_id    = reg_id.get_field_by_name("tx_data");
    value       = tx_data << field_id.get_lsb_pos();
    
    $display("tx_data_frame = %0h", tx_data);

    write_reg ("reg_tx_data_reg", value, status, UVM_FRONTDOOR);
  endtask