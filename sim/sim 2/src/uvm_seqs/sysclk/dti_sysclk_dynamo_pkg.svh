/*******************************************************************************
 *    Copyright (C) 2025 by Dolphin Technology
 *    All right reserved.
 *
 *    Copyright Notification
 *    No part may be reproduced except as authorized by written permission.
 *
 *    File Name             : dti_sysclk_dynamo_seqr.sv
 *    Company               : Dolphin Technology
 *    Project               : Dynamo RD2402
 *    Author                : Lam Pham Ngoc
 *    Module/Class/Package  : dti_sysclk_dynamo_seqr
 *    Create Date           : Apr 03 2025
 *    Last Update           : Apr 03 2025
 *    Description           : 
 ******************************************************************************
  History:

 ******************************************************************************/

`ifndef __DTI_SYSCLK_DYNAMO_PKG__
`define __DTI_SYSCLK_DYNAMO_PKG__

package dti_sysclk_dynamo_pkg;
  import uvm_pkg::*;
  import dti_sysclk_pkg::*;
  import dti_uart_pkg::*;
  `include "uvm_macros.svh"
  `include "dti_sysclk_macros.svh"

  `include "dti_sysclk_dynamo_seq_item.sv"
  `include "dti_sysclk_dynamo_seqr.sv"
  `include "dti_sysclk_dynamo_drv.sv"
  `include "dti_sysclk_generator.sv"
endpackage  //  dti_sysclk_dynamo_pkg

`endif  //  __DTI_SYSCLK_DYNAMO_PKG__