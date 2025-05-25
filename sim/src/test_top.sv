`timescale 1ns/1ns
module test_top ();
logic                           clk;
logic                           reset_n;
logic [11:0]      paddr;
logic [31:0]                    pwdata;
logic [3:0]                     pstrb;
logic                           pwrite;
logic                           psel;
logic                           penable;
logic [31:0]                    prdata;
logic                           pready;
logic                           pslverr;
logic                           rx;   //rx input
logic                           tx;   //tx output
logic                           cts_n;
logic                           rts_n;

logic [31:0] read_data;

apb_uart apb_uart_top_i (
  .pclk   (clk),
  .preset_n(reset_n),
  .clk    (clk),
  .reset_n (reset_n),
  .psel   (psel),
  .penable(penable),
  .pwrite (pwrite),
  .paddr  (paddr),
  .pwdata (pwdata),
  .pstrb  (pstrb),
  .prdata (prdata),
  .pready (pready),
  .pslverr(pslverr),
  .rx     (rx),
  .tx     (tx),
  .cts_n  (cts_n),
  .rts_n  (rts_n)
  );

always #10 clk = ~clk;

task Write_tx_data_reg(logic [7:0] tx_data);
  @(posedge clk);
  psel    = 0;
  penable = 0;
  pwrite  = 0;
  paddr   = '0;
  pwdata  = '0;
  @(posedge clk);
  psel    = 1;
  penable = 0;
  pwrite  = 1;
  paddr   = 12'h0;
  pwdata  = tx_data;
  @(posedge clk);
  psel    = 1;
  penable = 1;
  pwrite  = 1;
  @(posedge clk);
  while (pready == 0) begin
    @(posedge clk);
  end
  psel    = 0;
  penable = 0;
  pwrite  = 0;
  paddr   = '0;
  pwdata  = '0;
endtask

task Write_cfg_reg(logic [1:0] data_bit_num,
                   logic       stop_bit_num,
                   logic       parity_en,
                   logic       parity_type);
  @(posedge clk);
  psel    = 0;
  penable = 0;
  pwrite  = 0;
  paddr   = '0;
  pwdata  = '0;
  @(posedge clk);
  psel    = 1;
  penable = 0;
  pwrite  = 1;
  paddr   = 12'h008;

  pwdata[1:0] = data_bit_num;
  pwdata[2]   = stop_bit_num;
  pwdata[3]   = parity_en;
  pwdata[4]   = parity_type;

  @(posedge clk);
  psel    = 1;
  penable = 1;
  pwrite  = 1;
  @(posedge clk);
  while (pready == 0) begin
    @(posedge clk);
  end
  psel    = 0;
  penable = 0;
  pwrite  = 0;
  paddr   = '0;
  pwdata  = '0;
endtask

task Write_ctrl_reg(logic start_tx);
  @(posedge clk);
  psel    = 0;
  penable = 0;
  pwrite  = 0;
  paddr   = '0;
  pwdata  = '0;
  @(posedge clk);
  psel    = 1;
  penable = 0;
  pwrite  = 1;
  paddr   = 12'h00C;
  pwdata[0] = start_tx;
  @(posedge clk);
  psel    = 1;
  penable = 1;
  pwrite  = 1;
  @(posedge clk);
  while (pready == 0) begin
    @(posedge clk);
  end
  psel    = 0;
  penable = 0;
  pwrite  = 0;
  paddr   = '0;
  pwdata  = '0;
endtask

task Write_MCR();
  @(posedge clk);
  psel    = 0;
  penable = 0;
  pwrite  = 0;
  paddr   = '0;
  pwdata  = '0;
  @(posedge clk);
  psel    = 1;
  penable = 0;
  pwrite  = 1;
  paddr   = 12'h010;
  pwdata  = '0;
  @(posedge clk);
  psel    = 1;
  penable = 1;
  pwrite  = 1;
  @(posedge clk);
  while (pready == 0) begin
    @(posedge clk);
  end
  psel    = 0;
  penable = 0;
  pwrite  = 0;
  paddr   = '0;
  pwdata  = '0;
endtask : Write_MCR

task Write_SCR();
  @(posedge clk);
  psel    = 0;
  penable = 0;
  pwrite  = 0;
  paddr   = '0;
  pwdata  = '0;
  @(posedge clk);
  psel    = 1;
  penable = 0;
  pwrite  = 1;
  paddr   = 12'h01C;
  pwdata  = '0;
  @(posedge clk);
  psel    = 1;
  penable = 1;
  pwrite  = 1;
  @(posedge clk);
  while (pready == 0) begin
    @(posedge clk);
  end
  psel    = 0;
  penable = 0;
  pwrite  = 0;
  paddr   = '0;
  pwdata  = '0;
endtask : Write_SCR

task Write_DLL();
  @(posedge clk);
  psel    = 0;
  penable = 0;
  pwrite  = 0;
  paddr   = '0;
  pwdata  = '0;
  @(posedge clk);
  psel    = 1;
  penable = 0;
  pwrite  = 1;
  paddr   = 12'h020;
  pwdata  = 8'h0F;
  @(posedge clk);
  psel    = 1;
  penable = 1;
  pwrite  = 1;
  @(posedge clk);
  while (pready == 0) begin
    @(posedge clk);
  end
  psel    = 0;
  penable = 0;
  pwrite  = 0;
  paddr   = '0;
  pwdata  = '0;
endtask : Write_DLL

task Write_DLH();
  @(posedge clk);
  psel    = 0;
  penable = 0;
  pwrite  = 0;
  paddr   = '0;
  pwdata  = '0;
  @(posedge clk);
  psel    = 1;
  penable = 0;
  pwrite  = 1;
  paddr   = 12'h024;
  pwdata  = '0;
  @(posedge clk);
  psel    = 1;
  penable = 1;
  pwrite  = 1;
  @(posedge clk);
  while (pready == 0) begin
    @(posedge clk);
  end
  psel    = 0;
  penable = 0;
  pwrite  = 0;
  paddr   = '0;
  pwdata  = '0;
endtask : Write_DLH

task Write_MDR();
  @(posedge clk);
  psel    = 0;
  penable = 0;
  pwrite  = 0;
  paddr   = '0;
  pwdata  = '0;
  @(posedge clk);
  psel    = 1;
  penable = 0;
  pwrite  = 1;
  paddr   = 12'h028;
  pwdata  = 8'h00;
  @(posedge clk);
  psel    = 1;
  penable = 1;
  pwrite  = 1;
  @(posedge clk);
  while (pready == 0) begin
    @(posedge clk);
  end
  psel    = 0;
  penable = 0;
  pwrite  = 0;
  paddr   = '0;
  pwdata  = '0;
endtask : Write_MDR

task Write_THR(logic [7:0] tx_data_in);
  @(posedge clk);
  psel    = 0;
  penable = 0;
  pwrite  = 0;
  paddr   = '0;
  pwdata  = '0;
  @(posedge clk);
  psel    = 1;
  penable = 0;
  pwrite  = 1;
  paddr   = 12'h000;
  pwdata  = tx_data_in;
  @(posedge clk);
  psel    = 1;
  penable = 1;
  pwrite  = 1;
  @(posedge clk);
  while (pready == 0) begin
    @(posedge clk);
  end
  psel    = 0;
  penable = 0;
  pwrite  = 0;
  paddr   = '0;
  pwdata  = '0;
endtask : Write_THR

task Send_rx(logic [7:0] rx_data_out);
  int baud_clk;
  baud_clk = 50000000/115200+ 1;
  @(posedge clk);
  rx = 1'b0;
  for (int i = 0; i < 8; i++) begin
    repeat (baud_clk) @(posedge clk);
    rx = rx_data_out[i];
  end
  repeat (baud_clk) @(posedge clk);
  rx = ^rx_data_out;
  repeat (baud_clk) @(posedge clk);
  rx = 1'b1;
  repeat (baud_clk) @(posedge clk);
  repeat (baud_clk) @(posedge clk);
  repeat (baud_clk) @(posedge clk);
endtask : Send_rx

task Read_RBR();
  @(posedge clk);
  psel    = 0;
  penable = 0;
  pwrite  = 0;
  paddr   = '0;
  pwdata  = '0;
  @(posedge clk);
  psel    = 1;
  penable = 0;
  pwrite  = 0;
  paddr   = 12'h000;
  @(posedge clk);
  psel    = 1;
  penable = 1;
  pwrite  = 0;
  @(posedge clk);
  while (pready == 0) begin
    @(posedge clk);
  end
  psel    = 0;
  penable = 0;
  pwrite  = 0;
  paddr   = '0;
endtask : Read_RBR

task Read_stt_reg(output logic [31:0] read_data);
  @(posedge clk);
  psel    = 0;
  penable = 0;
  pwrite  = 0;
  paddr   = '0;
  pwdata  = '0;
  @(posedge clk);
  psel    = 1;
  penable = 0;
  pwrite  = 0;
  paddr   = 12'h10;
  @(posedge clk);
  psel    = 1;
  penable = 1;
  pwrite  = 0;
  @(posedge clk);
  while (pready == 0) begin
    @(posedge clk);
  end
  read_data = prdata;
  psel    = 0;
  penable = 0;
  pwrite  = 0;
  paddr   = '0;
endtask

initial begin
  clk     = 0;
  reset_n = 1;
  paddr   = '0;
  pwdata  = '0;
  pwrite  = 0;
  psel    = 0;
  penable = 0;
  rx      = 1;
  cts_n   = 0;
  // rts_n   = 0;
  pstrb   =4'b0001;
  // #27ns;
  reset_n  = 0;
  #1;
  repeat (5) @(posedge clk);
  // #29ns;
  reset_n  = 1;
  @(posedge clk);
  // Write_IER();
  // Write_FCR();
  // Write_LCR();
  // Write_MCR();
  // Write_SCR();
  // Write_DLL();
  // Write_DLH();
  // Write_MDR();
  
  // fork
  //   begin
  //     Write_THR(8'h81); // 1000_0001
  //     Write_THR(8'hFF); // 1010_1010
  //     Write_THR(8'hF0);
  //     Write_THR(8'h0F);
  //     Write_THR(8'h3A);
  //     Write_THR(8'h77);
  //   end
  //   begin
  //     Send_rx(8'h81);
  //     Send_rx(8'hFF);
  //     Send_rx(8'hF0);
  //     Send_rx(8'h0F);
  //   end
  // join
  // Read_RBR();


  // UART TX

  // Check if tx_done is HIGH
  while(1) begin
    Read_stt_reg(read_data);
    if (read_data[0]) begin
      break;
    end
  end

  // Config
  Write_cfg_reg(2'b11, 1'b1, 1'b1, 1'b0);

  Write_cfg_reg(.data_bit_num (2'b00),
                .stop_bit_num (1'b0),
                .parity_en    (1'b0),
                .parity_type  (1'b0));

  // Send data TX to register TX
  Write_tx_data_reg(8'd3);
  Write_ctrl_reg (1'b1);
  
  #100ns;
  while(1) begin
    Read_stt_reg(read_data);
    if (read_data[0]) begin
      break;
    end
  end

// RX test case
while(1) begin
  @(posedge clk);
  if (~rts_n) begin
    break;
  end
end

  Send_rx(8'd11);
  
  while(1) begin
    Read_stt_reg(read_data);
    if (read_data[1]) begin
      break;
    end
  end






//   #50ns;
//   // Start
// //  Send_rx(5'b01111);
//   Send_rx(8'd17);
//   #50ns;
//   // UART RX
//   Read_RBR();

  #200ns;
  $finish;
  end

endmodule : test_top