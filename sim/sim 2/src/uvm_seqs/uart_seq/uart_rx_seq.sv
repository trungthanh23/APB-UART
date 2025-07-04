/*******************************************************************************
 *    Copyright (C) 2024 by Dolphin Technology
 *    All right reserved.
 *
 *    Copyright Notification
 *    No part may be reproduced except as authorized by written permission.
 *
 *    File Name   : uart_rx_seq.sv
 *    Company     : Dolphin Technology
 *    Project     : dti uart vip
 *    Author      : Lam Pham Ngoc
 *    Module/Class: uart_rx_seq
 *    Create Date : Jul 03 2024
 *    Last Update : Jul 03 2024
 *    Description : UART rx sequence
 ******************************************************************************
  History:

 ******************************************************************************/

class uart_rx_seq extends uvm_sequence #(dti_uart_rx_transaction);

  // UART rx configuration object
  dti_uart_configuration uart_rx_cfg;

  `uvm_object_utils(uart_rx_seq)
  `uvm_declare_p_sequencer(dti_uart_rx_sequencer)


  // Function: new
  // Constructor of object.
  function new(string name="uart_rx_seq");
    super.new(name);
    // this.set_response_queue_error_report_disabled(1);  // Do not report overflow response_queue
  endfunction

  // Task: pre_start
  // UVM built-in method.
  virtual task pre_start();
    super.pre_start();
    uart_rx_cfg = p_sequencer.uart_rx_cfg;
    $display("@ %-10d: %0s", $time, get_sequence_path());
  endtask

  // Task: body
  // UVM built-in method.
  virtual task body();
    req = dti_uart_rx_transaction::type_id::create("req");
    `uvm_do(req)
  endtask

  
endclass : uart_rx_seq