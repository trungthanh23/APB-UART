/*******************************************************************************
 *    Copyright (C) 2025 by Dolphin Technology
 *    All right reserved.
 *
 *    Copyright Notification
 *    No part may be reproduced except as authorized by written permission.
 *
 *    File Name             : dti_sysclk_dynamo_drv.sv
 *    Company               : Dolphin Technology
 *    Project               : Dynamo RD2402
 *    Author                : Lam Pham Ngoc
 *    Module/Class/Package  : dti_sysclk_dynamo_drv
 *    Create Date           : Apr 03 2025
 *    Last Update           : Apr 03 2025
 *    Description           : 
 ******************************************************************************
  History:

 ******************************************************************************/

typedef class dti_sysclk_dynamo_seq_item;

class dti_sysclk_dynamo_drv extends dti_sysclk_drv;
  `uvm_component_utils(dti_sysclk_dynamo_drv)

  `INTERFACE_DECL_DRV(dti_sys_intf, "sys_drv")

  `RESET_SIG_DECL_DRV(reset_n)
  `CLOCK_SIG_DECL_DRV(apb_clk, apb_period)
  `CLOCK_SIG_DECL_DRV(uart_clk, uart_period)

  `SIGNAL_CTRL_DRV_BEGIN
    `RESET_CTRL_DECL_DRV(reset_n)
    `CLOCK_CTRL_DECL_DRV(apb_clk)
    `CLOCK_CTRL_DECL_DRV(uart_clk)
  `SIGNAL_CTRL_DRV_END

  `SIGNAL_UPDATE_DRV_BEGIN(dti_sysclk_dynamo_seq_item)
    `RESET_UPDATE_DECL_DRV(reset_n)
    `CLOCK_UPDATE_DECL_DRV(apb_clk, apb_period)
    `CLOCK_UPDATE_DECL_DRV(uart_clk, uart_period)
  `SIGNAL_UPDATE_DRV_END

  //---------------------------------------------------------------------------
  //  Public Methods
  //---------------------------------------------------------------------------
  function new(string name = "dti_sysclk_dynamo_drv", uvm_component parent = null);
    super.new(name, parent);
  endfunction //  new

endclass  //  dti_sysclk_dynamo_drv
