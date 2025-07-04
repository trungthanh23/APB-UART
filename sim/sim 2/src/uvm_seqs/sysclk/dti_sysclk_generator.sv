/*******************************************************************************
 *    Copyright (C) 2025 by Dolphin Technology
 *    All right reserved.
 *
 *    Copyright Notification
 *    No part may be reproduced except as authorized by written permission.
 *
 *    File Name             : dti_ahb_seq_base.sv
 *    Company               : Dolphin Technology
 *    Project               : Dynamo RD2402
 *    Author                : Lam Pham Ngoc
 *    Module/Class/Package  : dti_ahb_seq_base
 *    Create Date           : Mar 31 2025
 *    Last Update           : Mar 31 2025
 *    Description           : 
 ******************************************************************************
  History:

 ******************************************************************************/

class dti_sysclk_generator extends uvm_sequence#(dti_sysclk_dynamo_seq_item);
  `uvm_object_utils(dti_sysclk_generator)
  `uvm_declare_p_sequencer(dti_sysclk_dynamo_seqr)

  int tCK;

  dti_uart_configuration        uart_cfg;
  dti_sysclk_dynamo_seq_item    sys_clk;

  function new(string name = "dti_sysclk_generator");
    super.new(name);
  endfunction: new

  virtual task pre_body();
    //  Get configuration
    if (!uvm_config_db #(dti_uart_configuration)::get(null, "*", "uart_cfg", uart_cfg)) begin
      `uvm_fatal("SYSCLK_SEQ", "Can not get uart_cfg!");
    end
  endtask : pre_body

  virtual task body();
    sys_clk = dti_sysclk_dynamo_seq_item::type_id::create("sys_clk");
    tCK = int'(uart_cfg.tCK_ns);
    start_item(sys_clk,,p_sequencer);
    assert(sys_clk.randomize());
    sys_clk.reset_n=SIG_ASSERT;
    sys_clk.apb_clk=SIG_DEASSERT;
    sys_clk.uart_clk=SIG_DEASSERT;
    sys_clk.duration=0;
    finish_item(sys_clk);

    start_item(sys_clk,,p_sequencer);
    assert(sys_clk.randomize());
    sys_clk.reset_n=SIG_NOCHANGE;
    sys_clk.apb_clk=SIG_CLOCK;
    sys_clk.apb_period=tCK;
    sys_clk.uart_clk=SIG_CLOCK;
    sys_clk.uart_period=tCK;
    sys_clk.duration=100000;
    finish_item(sys_clk);

    start_item(sys_clk,,p_sequencer);
    assert(sys_clk.randomize());
    sys_clk.reset_n=SIG_DEASSERT;
    sys_clk.apb_clk=SIG_DEASSERT;
    sys_clk.uart_clk=SIG_DEASSERT;
    sys_clk.duration=0;
    finish_item(sys_clk);

    start_item(sys_clk,,p_sequencer);
    assert(sys_clk.randomize());
    sys_clk.reset_n=SIG_NOCHANGE;
    sys_clk.apb_clk=SIG_CLOCK;
    sys_clk.apb_period=tCK;
    sys_clk.uart_clk=SIG_CLOCK;
    sys_clk.uart_period=tCK;
    sys_clk.duration=100000;
    finish_item(sys_clk);

    start_item(sys_clk,,p_sequencer);
    assert(sys_clk.randomize());
    sys_clk.reset_n=SIG_ASSERT;
    sys_clk.apb_clk=SIG_DEASSERT;
    sys_clk.uart_clk=SIG_DEASSERT;
    sys_clk.duration=0;
    finish_item(sys_clk);

    start_item(sys_clk,,p_sequencer);
    assert(sys_clk.randomize());
    sys_clk.reset_n=SIG_NOCHANGE;
    sys_clk.apb_clk=SIG_CLOCK;
    sys_clk.apb_period=tCK;
    sys_clk.uart_clk=SIG_CLOCK;
    sys_clk.uart_period=tCK;
    sys_clk.duration=100000;
    finish_item(sys_clk);
  endtask

endclass : dti_sysclk_generator