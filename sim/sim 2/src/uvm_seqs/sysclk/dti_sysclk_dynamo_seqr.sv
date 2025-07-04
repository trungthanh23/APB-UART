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

class dti_sysclk_dynamo_seqr extends dti_sysclk_seqr;
  `uvm_component_utils(dti_sysclk_dynamo_seqr)

  //---------------------------------------------------------------------------
  //  Methods
  //---------------------------------------------------------------------------
  /*  Function  : new, Constructor
   *  Arguments
   *    name    : string, Instance's Name
   *
   *  Return    : None
   */
  function new(string name="dti_sysclk_dynamo_seqr", uvm_component parent = null);
    super.new(name, parent);
  endfunction

endclass
