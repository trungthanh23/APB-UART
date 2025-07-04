/*******************************************************************************
 *    Copyright (C) 2023 by Dolphin Technology
 *    All right reserved.
 *
 *    Copyright Notification
 *    No part may be reproduced except as authorized by written permission.
 *
 *    File Name   : dti_apb_inc_file.sv
 *    Company     : Dolphin Technology
 *    Project     : dti_apb_vip
 *    Author      : phuongnd0
 *    Module/Class: 
 *    Create Date : Sep 11th 2023
 *    Last Update : Sep 11th 2023
 *    Description : 
 ******************************************************************************
  History:

 ******************************************************************************/

package dti_apb_pkg;
  import  uvm_pkg::*;
  `include "uvm_macros.svh"

  `include "dti_apb_macros.svh"
  `include "dti_apb_type.sv"

  `include "dti_apb_master_config.sv"
  `include "dti_apb_slave_config.sv"

  `include "dti_apb_config.sv"
  `include "dti_apb_item.sv"


  `include "dti_apb_master_item.sv"
  // `include "dti_apb_slave_item.sv"

  `include "dti_apb_master_sequencer.sv"
  // `include "dti_apb_slave_sequencer.sv"
  // `include "dti_apb_virtual_sequencer.sv"
  // `include "dti_apb_virtual_sequence.sv"

  `include "dti_apb_coverage_monitor.sv"
  `include "dti_apb_master_monitor.sv"
  `include "dti_apb_master_driver.sv"
  `include "dti_apb_master_agent.sv"

  // `include "dti_apb_slave_driver.sv"
  // `include "dti_apb_slave_agent.sv"

  `include "dti_apb_master_seq_base.sv"
  // `include "dti_apb_slave_seq_base.sv"
  // `include "dti_apb_env.sv"
  `include "dti_apb_reg_adapter.sv"

  // `include "dti_apb_base_test.sv"


  // export uvm_pkg::*;
endpackage

// `include "dti_apb_sva.sv"
// `include "tb_dti_apb_top.sv"