/*******************************************************************************
 *    Copyright (C) 2024 by Dolphin Technology
 *    All right reserved.
 *
 *    Copyright Notification
 *    No part may be reproduced except as authorized by written permission.
 *
 *    File Name   : uart_tx_seq.sv
 *    Company     : Dolphin Technology
 *    Project     : dti uart vip
 *    Author      : Lam Pham Ngoc
 *    Module/Class: uart_tx_seq
 *    Create Date : Jul 03 2024
 *    Last Update : Jul 03 2024
 *    Description : UART tx sequence
 ******************************************************************************
  History:

 ******************************************************************************/


class uart_tx_seq extends uvm_sequence #(dti_uart_tx_transaction);

  // UART TX configuration object
  dti_uart_configuration uart_tx_cfg;
  rand bit [7:0]        tx_data_pattern;

  `uvm_object_utils(uart_tx_seq)
  `uvm_declare_p_sequencer(dti_uart_tx_sequencer)


  // Function: new
  // Constructor of object.
  function new(string name="uart_tx_seq");
    super.new(name);
    // this.set_response_queue_error_report_disabled(1);  // Do not report overflow response_queue
  endfunction

  // Task: pre_start
  // UVM built-in method.
  virtual task pre_start();
    super.pre_start();
    uart_tx_cfg = p_sequencer.uart_tx_cfg;
    $display("@ %-10d: %0s", $time, get_sequence_path());
  endtask

  // Task: body
  // UVM built-in method.
  virtual task body();
    req = dti_uart_tx_transaction::type_id::create("req");
    `uvm_do_with(req, {uart_tx_data_frame == tx_data_pattern;})
  endtask

endclass : uart_tx_seq