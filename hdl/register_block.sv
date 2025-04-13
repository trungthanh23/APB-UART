module register_block(
    //Global signals
    input               clk,
    input               reset_n,

    //Communication with APB signals
    input  logic        pwrite_i,
    input  logic        psel_i,
    input  logic        penable_i,
    input  logic [3 :0] pstrb_i,
    input  logic [31:0] pwdata_i,
    input  logic [11:0] paddr_i,
    output              parity_error_o,
    output logic        write_en_o,
    output logic        read_en_o,
    output logic [31:0] prdata_o

    //Communication with UART signals
    input  logic        tx_done_i,
    input  logic        rx_done_i,
    input  logic        parity_error_i,
    input  logic [31:0] rx_data_i,
    output logic        stop_bit_num_o,
    output logic        parity_en_o,
    output logic        parity_type_o,
    output logic        start_tx_o,
    output logic [31:0] tx_data_o,
    output logic [1 :0] data_bit_num_o,
);

//Registers
logic [31:0] tx_data_reg;
logic [31:0] rx_data_reg;
logic [31:0] cfg_reg;
logic [31:0] ctrl_reg;
logic [31:0] stt_reg;

//Register addresses
localparam  ADDR_TX_DATA_REG = 'h0;
localparam  ADDR_RX_DATA_REG = 'h4;
localparam  ADDR_CFG_REG     = 'h8;
localparam  ADDR_CTRL_REG    = 'hc;
localparam  ADDR_STT_REG     = 'h10;

//Confirm is write
logic write_en = pwrite_i && psel_i && penable_i;

//Output read/write enable 
always_comb begin  
    case (paddr_i)
        ADDR_TX_DATA_REG: begin
            write_en_o = 1'b1;
            read_en_o  = 1'b1;
        end
        ADDR_RX_DATA_REG: begin
            write_en_o = 1'b0;
            read_en_o  = 1'b1;
        end
        ADDR_CFG_REG: begin
            write_en_o = 1'b1;
            read_en_o  = 1'b1;
        end
        ADDR_CTRL_REG: begin
            write_en_o = 1'b1;
            read_en_o  = 1'b1;
        end
        ADDR_STT_REG: begin
            write_en_o = 1'b0;
            read_en_o  = 1'b1;
        end
        default: begin
            write_en_o = 1'b0;
            read_en_o  = 1'b0;
        end
    endcase
end

//tx_data_reg
always_ff @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        tx_data_reg <= 32'b0;
    end else if (write_en && (paddr_i == ADDR_TX_DATA_REG)) begin
        case (pstrb_i)
            4'b0001: tx_data_reg <= {24'b0, pwdata_i[7:0]};
            4'b0010: tx_data_reg <= {24'b0, pwdata_i[15:8]};
            4'b0100: tx_data_reg <= {24'b0, pwdata_i[23:16]};
            4'b1000: tx_data_reg <= {24'b0, pwdata_i[31:24]};
            4'b1111: tx_data_reg <= pwdata_i;
            default: tx_data_reg <= tx_data_reg;
        endcase
    end else begin
        tx_data_reg <= tx_data_reg;
    end
end

//rx_data_reg
always_ff @(posedge clk, negedge reset_n) begin
    if (!reset_n) begin
        rx_data_reg <= 32'b0;
    end else begin
        rx_data_reg <= rx_data_i;
    end
end

//cfg_reg
always_ff @(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        cfg_reg <= 32'b0;
    end else if (write_en && (paddr_i == ADDR_CFG_REG)) begin
        case (pstrb_i) 
        4'b0001: cfg_reg <= {24'b0, pwdata_i[7:0]};
        4'b0011: cfg_reg <= {16'b0, pwdata_i[15:0]};
        4'b0111: cfg_reg <= {8'b0, pwdata_i[23:0]}; 
        4'b1111: cfg_reg <= pwdata_i;
        default: cfg_reg <= pwdata_i;
      endcase
    end else begin
        cfg_reg <= cfg_reg;
    end
end

//ctrl_reg
always_ff @(posedge clk, negedge reset_n) begin
    if(!reset_n) begin
        ctrl_reg <= 32'b0;
    end else if (write_en && (paddr_i == ADDR_CTRL_REG)) begin
        case (pstrb_i) 
        4'b0001: ctrl_reg <= {24'b0, pwdata_i[7:0]};
        4'b0011: ctrl_reg <= {16'b0, pwdata_i[15:0]};
        4'b0111: ctrl_reg <= {8'b0, pwdata_i[23:0]}; 
        4'b1111: ctrl_reg <= pwdata_i;
        default: ctrl_reg <= pwdata_i;
      endcase
    end else begin
        ctrl_reg <= ctrl_reg;
    end
end

//stt_reg
always_ff @(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        stt_reg <= 32'b0;
    end else begin
        stt_reg <= {29'b0, parity_error_i, rx_done_i, tx_done_i};
    end
end

//Read data logic
always_comb begin
  if (~(pwrite_i)) begin
    case (paddr_i)
        ADDR_TX_DATA_REG: begin
            prdata_o = tx_data_reg;
        end
        ADDR_RX_DATA_REG: begin
            prdata_o = rx_data_reg;
        end
        ADDR_CFG_REG: begin
            prdata_o = cfg_reg;
        end
        ADDR_CTRL_REG: begin
            prdata_o = ctrl_reg;
        end
        ADDR_STT_REG: begin
            prdata_o = stt_reg;
        end
        default: begin
            prdata_o = 32'b0;
        end
  endcase 
  end else begin
    prdata_o = 32'b0;
  end
end

assign parity_error_o = stt_reg[2];

//Output UART logic
assign tx_data_o = tx_data_reg;
assign data_bit_num_o = cfg_reg[1:0];
assign stop_bit_num_o = cfg_reg[2];
assign parity_en_o   = cfg_reg[3];
assign parity_type_o = cfg_reg[4];
assign start_tx_o    = ctrl_reg[0];

endmodule