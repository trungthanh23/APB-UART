/*******************************************************************************
 *    Copyright (C) 2025 by Dolphin Technology
 *    All right reserved.
 *
 *    Copyright Notification
 *    No part may be reproduced except as authorized by written permission.
 *
 *    File Name   : apb_seq_read_rx_data_reg.sv
 *    Company     : Dolphin Technology
 *    Project     : dti_apb_uart
 *    Author      : hoangts0
 *    Module/Class: apb_seq_read_rx_data_reg
 *    Create Date : May 20 2025
 *    Last Update : May 20 2025
 *    Description : 
 ******************************************************************************
  History:

 ******************************************************************************/
class apb_seq_read_rx_data_reg extends  apb_seq_base;
  `uvm_object_utils(apb_seq_read_rx_data_reg)

  function new(string name = "apb_seq_read_rx_data_reg");
    super.new();
  endfunction
  
  task body();
    //Read reg
    read_reg("reg_rx_data_reg",value,status,UVM_FRONTDOOR);
    //Read reg from reg model
    reg_id = apb_regs.get_reg_by_name("reg_rx_data_reg");
    value = reg_id.get("reg_rx_data_reg",0);
    `uvm_info("REG",$sformatf("reg_rx_data_reg = %0h",value),UVM_DEBUG)
  endtask

endclass : apb_seq_read_rx_data_reg