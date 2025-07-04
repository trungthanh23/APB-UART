/*******************************************************************************
 *    Copyright (C) 2025 by Dolphin Technology
 *    All right reserved.
 *
 *    Copyright Notification
 *    No part may be reproduced except as authorized by written permission.
 *
 *    File Name   : uart_seq_pkg.svh
 *    Company     : Dolphin Technology
 *    Project     : dti_apb_uart
 *    Author      : hoangts0
 *    Module/Class: uart_seq_pkg
 *    Create Date : May 20 2025
 *    Last Update : May 20 2025
 *    Description : 
 ******************************************************************************
  History:

 ******************************************************************************/
package uart_seq_pkg;
  import  dti_uart_pkg::*;
  import  dti_uart_regs_pkg::*;
  import  uvm_pkg::*;
  `include "uvm_macros.svh"

  `include "uart_rx_seq.sv"
  `include "uart_tx_seq.sv"


endpackage