/*******************************************************************************
 *    Copyright (C) 2025 by Dolphin Technology
 *    All right reserved.
 *
 *    Copyright Notification
 *    No part may be reproduced except as authorized by written permission.
 *
 *    File Name             : dti_sys_intf.sv
 *    Company               : Dolphin Technology
 *    Project               : dti_apb_uart
 *    Author                : hoangts0
 *    Module/Class/Package  : dti_sys_intf
 *    Create Date           : May 20 2025
 *    Last Update           : May 20 2025
 *    Description           : 
 ******************************************************************************
  History:

 ******************************************************************************/

interface dti_sys_intf();
  //---------------------------------------------------------------------------
  //         Signals
  //---------------------------------------------------------------------------
  logic                                           reset_n       ;   //  System reset signal
  logic                                           uart_clk      ;   //  Uart port clock signal
  logic                                           apb_clk       ;   //  APB port clock signal
  logic                               [ 31  : 0 ] uart_period   ;   //  Uart port clock period in ps
  logic                               [ 31  : 0 ] apb_period    ;   //  APB port clock period in ps


  modport MOD_SYS (
    output  reset_n       ,
    output  uart_clk      ,
    output  apb_clk       ,
    output  uart_period   ,
    output  apb_period
  );

  modport MOD_TEST (
    input   reset_n       ,
    input   uart_clk      ,
    input   apb_clk       ,
    input   uart_period   ,
    input   apb_period
  );

endinterface  //  dti_sys_intf
