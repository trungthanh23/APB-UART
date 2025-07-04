/*******************************************************************************
 *    Copyright (C) 2025 by Dolphin Technology
 *    All right reserved.
 *
 *    Copyright Notification
 *    No part may be reproduced except as authorized by written permission.
 *
 *    File Name   : apb_uart_change_bit_num_test.sv
 *    Company     : Dolphin Technology
 *    Project     : dti_apb_uart
 *    Author      : hoangts0
 *    Module/Class: apb_uart_change_bit_num_test
 *    Create Date : May 20 2025
 *    Last Update : May 20 2025
 *    Description : 
 ******************************************************************************
  History:

 ******************************************************************************/
class apb_uart_change_bit_num_test extends  apb_uart_base_test;
  `uvm_component_utils(apb_uart_change_bit_num_test)
  uart_rx_seq             rx_seq;
  uart_tx_seq             tx_seq;
  apb_seq_write_cfg_reg      seq_w_cfg;
  apb_seq_write_ctrl_reg     seq_w_ctrl;
  apb_seq_write_tx_data_reg  seq_w_tx;
  apb_seq_read_stt_reg       seq_r_stt;
  apb_seq_read_ctrl_reg      seq_r_ctrl;
  apb_seq_read_cfg_reg       seq_r_cfg;
  apb_seq_read_tx_data_reg   seq_r_tx_data;
  apb_seq_read_rx_data_reg   seq_r_rx_data;

  extern function new(string name = "apb_uart_change_bit_num_test", uvm_component parent=null);
  extern task     run_phase(uvm_phase phase);

endclass : apb_uart_change_bit_num_test

function apb_uart_change_bit_num_test::new(string name = "apb_uart_change_bit_num_test", uvm_component parent=null);
    super.new(name, parent);
  endfunction

task apb_uart_change_bit_num_test::run_phase (uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);
    uart_cfg.data_bit_num = UART_8BIT;

    tx_seq = uart_tx_seq::type_id::create("tx_seq",this);
    rx_seq = uart_rx_seq::type_id::create("rx_seq",this);
    //read data
    seq_r_stt  = apb_seq_read_stt_reg::type_id::create("seq_r_stt");
    seq_r_stt.start(env.apb_agent.sequencer);
    seq_r_cfg  = apb_seq_read_cfg_reg::type_id::create("seq_r_cfg");
    seq_r_cfg.start(env.apb_agent.sequencer);
    seq_r_ctrl = apb_seq_read_ctrl_reg::type_id::create("seq_r_ctrl");
    seq_r_ctrl.start(env.apb_agent.sequencer);
    seq_r_tx_data  = apb_seq_read_tx_data_reg::type_id::create("seq_r_tx_data");
    seq_r_tx_data.start(env.apb_agent.sequencer);
    seq_r_rx_data  = apb_seq_read_rx_data_reg::type_id::create("seq_r_rx_data");
    seq_r_rx_data.start(env.apb_agent.sequencer);
    fork
      rx_seq.start(env.uart_rx.sequencer);
      begin
        #1;
        seq_w_cfg  = apb_seq_write_cfg_reg::type_id::create("seq_w_cfg");
        seq_w_cfg.randomize();
        seq_w_cfg.start(env.apb_agent.sequencer);

        seq_w_tx   = apb_seq_write_tx_data_reg::type_id::create("seq_w_tx");
        seq_w_tx.tx_data  = 8'h17;
        seq_w_tx.start(env.apb_agent.sequencer);

        seq_w_ctrl = apb_seq_write_ctrl_reg::type_id::create("seq_w_ctrl");
        seq_w_ctrl.start_tx = 1'b1;
        seq_w_ctrl.start(env.apb_agent.sequencer);
      end
      begin
        tx_seq.tx_data_pattern = 8'h21;
        tx_seq.start(env.uart_tx.sequencer);
      end
    join

    seq_r_rx_data.start(env.apb_agent.sequencer);


    uart_cfg.stop_bit_num = UART_TWO_STOP_BIT;
    uart_cfg.parity_en = UART_PARITY_DIS;

    seq_r_stt.start(env.apb_agent.sequencer);
    seq_r_cfg.start(env.apb_agent.sequencer);
    seq_r_ctrl.start(env.apb_agent.sequencer);
    seq_r_tx_data.start(env.apb_agent.sequencer);
    seq_r_rx_data.start(env.apb_agent.sequencer);
    fork
      rx_seq.start(env.uart_rx.sequencer);
      begin
        #1;
        seq_w_cfg.randomize() with{stop_bit_num == 1'b1; parity_en == 1'b0;};
        seq_w_cfg.start(env.apb_agent.sequencer);

        seq_w_tx.tx_data  = 8'h15;
        seq_w_tx.start(env.apb_agent.sequencer);

        seq_w_ctrl.start_tx = 1'b1;
        seq_w_ctrl.start(env.apb_agent.sequencer);
      end
      begin
        tx_seq.tx_data_pattern = 8'h23;
        tx_seq.start(env.uart_tx.sequencer);
      end
    join
    seq_r_rx_data.start(env.apb_agent.sequencer);

    uart_cfg.parity_en = UART_PARITY_EN;

    seq_r_stt.start(env.apb_agent.sequencer);
    seq_r_cfg.start(env.apb_agent.sequencer);
    seq_r_ctrl.start(env.apb_agent.sequencer);
    seq_r_tx_data.start(env.apb_agent.sequencer);
    fork
      rx_seq.start(env.uart_rx.sequencer);
      begin
        #1;
        seq_w_cfg.randomize() with{stop_bit_num == 1'b1; parity_en == 1'b1;};
        seq_w_cfg.start(env.apb_agent.sequencer);

        seq_w_tx.tx_data  = 8'h13;
        seq_w_tx.start(env.apb_agent.sequencer);

        seq_w_ctrl.start_tx = 1'b1;
        seq_w_ctrl.start(env.apb_agent.sequencer);
      end
      begin
        tx_seq.tx_data_pattern = 8'h25;
        tx_seq.start(env.uart_tx.sequencer);
      end
    join
    seq_r_rx_data.start(env.apb_agent.sequencer);

    uart_cfg.data_bit_num = UART_7BIT;
    seq_r_stt.start(env.apb_agent.sequencer);
    seq_r_cfg.start(env.apb_agent.sequencer);
    seq_r_ctrl.start(env.apb_agent.sequencer);
    seq_r_tx_data.start(env.apb_agent.sequencer);
    fork
      rx_seq.start(env.uart_rx.sequencer);
      begin
        #1;
        seq_w_cfg.randomize() with{stop_bit_num == 1'b1; parity_en == 1'b1; data_bit_num == 2'b10;};
        seq_w_cfg.start(env.apb_agent.sequencer);

        seq_w_tx.tx_data  = 8'hff;
        seq_w_tx.start(env.apb_agent.sequencer);

        seq_w_ctrl.start_tx = 1'b1;
        seq_w_ctrl.start(env.apb_agent.sequencer);
      end
      begin
        tx_seq.tx_data_pattern = 8'h27;
        tx_seq.start(env.uart_tx.sequencer);
      end
    join
    seq_r_rx_data.start(env.apb_agent.sequencer);

    uart_cfg.data_bit_num = UART_6BIT;
    seq_r_stt.start(env.apb_agent.sequencer);
    seq_r_cfg.start(env.apb_agent.sequencer);
    seq_r_ctrl.start(env.apb_agent.sequencer);
    seq_r_tx_data.start(env.apb_agent.sequencer);
    fork
      rx_seq.start(env.uart_rx.sequencer);
      begin
        #1;
        seq_w_cfg.randomize() with{stop_bit_num == 1'b1; parity_en == 1'b1; data_bit_num == 2'b01;};
        seq_w_cfg.start(env.apb_agent.sequencer);

        seq_w_tx.tx_data  = 8'hff;
        seq_w_tx.start(env.apb_agent.sequencer);

        seq_w_ctrl.start_tx = 1'b1;
        seq_w_ctrl.start(env.apb_agent.sequencer);
      end
      begin
        tx_seq.tx_data_pattern = 8'hf9;
        tx_seq.start(env.uart_tx.sequencer);
      end
    join
    seq_r_rx_data.start(env.apb_agent.sequencer);

    uart_cfg.data_bit_num = UART_5BIT;
    seq_r_stt.start(env.apb_agent.sequencer);
    seq_r_cfg.start(env.apb_agent.sequencer);
    seq_r_ctrl.start(env.apb_agent.sequencer);
    seq_r_tx_data.start(env.apb_agent.sequencer);
    fork
      rx_seq.start(env.uart_rx.sequencer);
      begin
        #1;
        seq_w_cfg.randomize() with{stop_bit_num == 1'b1; parity_en == 1'b1; data_bit_num == 2'b00;};
        seq_w_cfg.start(env.apb_agent.sequencer);

        seq_w_tx.tx_data  = 8'hff;
        seq_w_tx.start(env.apb_agent.sequencer);

        seq_w_ctrl.start_tx = 1'b1;
        seq_w_ctrl.start(env.apb_agent.sequencer);
      end
      begin
        tx_seq.tx_data_pattern = 8'hfb;
        tx_seq.start(env.uart_tx.sequencer);
      end
    join
    seq_r_rx_data.start(env.apb_agent.sequencer);

    uart_cfg.data_bit_num = UART_7BIT;
    seq_r_stt.start(env.apb_agent.sequencer);
    seq_r_cfg.start(env.apb_agent.sequencer);
    seq_r_ctrl.start(env.apb_agent.sequencer);
    seq_r_tx_data.start(env.apb_agent.sequencer);
    fork
      rx_seq.start(env.uart_rx.sequencer);
      begin
        #1;
        seq_w_cfg.randomize() with{stop_bit_num == 1'b1; parity_en == 1'b1; data_bit_num == 2'b10;parity_type == 1'b0;};
        seq_w_cfg.start(env.apb_agent.sequencer);

        seq_w_tx.tx_data  = 8'hff;
        seq_w_tx.start(env.apb_agent.sequencer);

        seq_w_ctrl.start_tx = 1'b1;
        seq_w_ctrl.start(env.apb_agent.sequencer);
      end
      begin
        tx_seq.tx_data_pattern = 8'h27;
        tx_seq.start(env.uart_tx.sequencer);
      end
    join
    seq_r_rx_data.start(env.apb_agent.sequencer);

    uart_cfg.data_bit_num = UART_6BIT;
    seq_r_stt.start(env.apb_agent.sequencer);
    seq_r_cfg.start(env.apb_agent.sequencer);
    seq_r_ctrl.start(env.apb_agent.sequencer);
    seq_r_tx_data.start(env.apb_agent.sequencer);
    fork
      rx_seq.start(env.uart_rx.sequencer);
      begin
        #1;
        seq_w_cfg.randomize() with{stop_bit_num == 1'b1; parity_en == 1'b1; data_bit_num == 2'b01;parity_type == 1'b0;};
        seq_w_cfg.start(env.apb_agent.sequencer);

        seq_w_tx.tx_data  = 8'hff;
        seq_w_tx.start(env.apb_agent.sequencer);

        seq_w_ctrl.start_tx = 1'b1;
        seq_w_ctrl.start(env.apb_agent.sequencer);
      end
      begin
        tx_seq.tx_data_pattern = 8'hf9;
        tx_seq.start(env.uart_tx.sequencer);
      end
    join
    seq_r_rx_data.start(env.apb_agent.sequencer);

    

      phase.drop_objection(this);



endtask : run_phase