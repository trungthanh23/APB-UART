/*******************************************************************************
 *    Copyright (C) 2025 by Dolphin Technology
 *    All right reserved.
 *
 *    Copyright Notification
 *    No part may be reproduced except as authorized by written permission.
 *
 *    File Name   : apb_seq_pkg.svh
 *    Company     : Dolphin Technology
 *    Project     : dti_apb_uart
 *    Author      : hoangts0
 *    Module/Class: apb_seq_pkg
 *    Create Date : May 20 2025
 *    Last Update : May 20 2025
 *    Description : 
 ******************************************************************************
  History:

 ******************************************************************************/
package apb_seq_pkg;
  import  dti_apb_pkg::*;
  import  dti_uart_regs_pkg::*;
  import  uvm_pkg::*;
  `include "uvm_macros.svh"

  `include "apb_seq_base.sv"
  `include "apb_seq_read_cfg_reg.sv"
  `include "apb_seq_read_ctrl_reg.sv"
  `include "apb_seq_read_rx_data_reg.sv"
  `include "apb_seq_read_stt_reg.sv"
  `include "apb_seq_read_tx_data_reg.sv"
  `include "apb_seq_write_cfg_reg.sv"
  `include "apb_seq_write_ctrl_reg.sv"
  `include "apb_seq_write_tx_data_reg.sv"

endpackage