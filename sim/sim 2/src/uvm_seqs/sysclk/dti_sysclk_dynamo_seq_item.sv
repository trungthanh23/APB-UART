/*******************************************************************************
 *    Copyright (C) 2025 by Dolphin Technology
 *    All right reserved.
 *
 *    Copyright Notification
 *    No part may be reproduced except as authorized by written permission.
 *
 *    File Name             : dti_sysclk_dynamo_seq_item.sv
 *    Company               : Dolphin Technology
 *    Project               : Dynamo RD2402
 *    Author                : Lam Pham Ngoc
 *    Module/Class/Package  : dti_sysclk_dynamo_seq_item
 *    Create Date           : Apr 03 2025
 *    Last Update           : Apr 03 2025
 *    Description           : 
 ******************************************************************************
  History:

 ******************************************************************************/

class dti_sysclk_dynamo_seq_item extends dti_sysclk_seq_item;
  `uvm_object_utils(dti_sysclk_dynamo_seq_item)
  //---------------------------------------------------------------------------
  //  Public Properties
  //---------------------------------------------------------------------------
  `RESET_SIG_DECL_ITEM(reset_n)
  `CLOCK_SIG_DECL_ITEM(apb_clk, apb_period)
  `CLOCK_SIG_DECL_ITEM(uart_clk, uart_period)

  //---------------------------------------------------------------------------
  //  Randomization Constraints
  //---------------------------------------------------------------------------

  //---------------------------------------------------------------------------
  //  Public Methods
  //---------------------------------------------------------------------------
  function new(string name = "dti_sysclk_dynamo_seq_item");
    super.new(name);
  endfunction //  new

  virtual function string toString();
    string str = "";
    str = $psprintf("%sduration   = %1d\n", str, duration);
    str = $psprintf("%sreset_n    = %s\n", str, reset_n);
    str = $psprintf("%sapb_clk    = %s\n", str, apb_clk);
    str = $psprintf("%suart_clk   = %s\n", str, uart_clk);
    return str;
  endfunction //  toString

endclass  //  dti_sysclk_dynamo_seq_item
