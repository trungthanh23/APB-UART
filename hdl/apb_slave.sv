module apb_slave # (
    parameter ADDR_MIN = 12'h000,
    parameter ADDR_MAX = 12'h010
)
(
    // Global signals
    input               clk,
    input               reset_n,

    //Communication with CPU signal
    input               pclk,
    input               preset_n,
    input               psel,
    input  logic        penable,
    input  logic        pwrite,
    input  logic [11:0] paddr,
    input  logic [3 :0] pstrb,
    input  logic [31:0] pwdata,
    output logic        pready,
    output logic        pslverr,
    output logic [31:0] prdata,

    //Communication with Register signals
    input               parity_error_i,
    input  logic        write_en_i,
    input  logic        read_en_i,
    input  logic [31:0] prdata_i,
    output logic        pwrite_o,
    output logic [3 :0] pstrb_o,
    output logic        psel_o,
    output logic        penable_o,
    output logic [31:0] pwdata_o,
    output logic [11:0] paddr_o
);

localparam APB_IDLE = 2'b00;
localparam APB_SETUP = 2'b01;

logic [1:0] current_state;
logic [1:0] next_state;
    
localparam  ADDR_TX_DATA_REG = 'h0;
localparam  ADDR_RX_DATA_REG = 'h4;
localparam  ADDR_CFG_REG     = 'h8;
localparam  ADDR_CTRL_REG    = 'hc;
localparam  ADDR_STT_REG     = 'h10;

//Curent_state
always_ff @(posedge pclk, negedge preset_n) begin
    if (~preset_n) begin
        current_state <= APB_IDLE;
    end else begin
        current_state <= next_state;
    end
end

//Next_state
always_comb begin
    case (current_state)
        APB_IDLE: begin
            if (psel) begin
                next_state <= APB_SETUP;
            end else begin
                next_state <= APB_IDLE;
            end
        end
        APB_SETUP: begin
            if (psel && penable) begin
                next_state <= APB_SETUP;
            end else begin
                next_state <= APB_IDLE;
            end
        end
        default: begin
            next_state <= APB_IDLE;
        end
    endcase
end


//Output 
always_comb begin
    pready = 0;
    pslverr = 0;
    
    //read
    if (read_en_i) begin
        prdata = prdata_i;
    end else begin
        prdata = 0;
    end

    case (current_state)
        APB_IDLE: begin
            pwrite_o = 0;
            paddr_o = 0;
            pstrb_o = 0;
            pwdata_o = 0;
            pready = 0;
            pslverr = 0;
        end
        APB_SETUP: begin
            pwrite_o = pwrite;
            paddr_o = paddr;
            pstrb_o = pstrb;
            pwdata_o = pwdata;
            // pready
            if (penable) begin
                case (paddr)
                    ADDR_TX_DATA_REG: begin // tx_data_reg_addr
                        pready = (pwrite && write_en_i) || (~pwrite && read_en_i); // RW
                    end
                    ADDR_RX_DATA_REG: begin // rx_data_reg_addr
                        pready = ~pwrite && read_en_i; // RO
                    end
                    ADDR_CFG_REG: begin     // cfg_reg_addr
                        pready = (pwrite && write_en_i) || (~pwrite && read_en_i); //RW
                    end
                    ADDR_CTRL_REG: begin    // ctrl_reg_addr
                        pready = (pwrite && write_en_i) || (~pwrite && read_en_i); //RW
                    end
                    ADDR_STT_REG: begin     // stt_reg_addr
                        pready = ~pwrite && read_en_i; // RO
                    end
                    default: begin
                        pready = 0;
                    end
                endcase
            end

            //pslverr
            if (psel && penable && pready) begin
                case (paddr)
                    ADDR_TX_DATA_REG: begin
                        pslverr = pwrite ? 0 : 1;
                    end
                    ADDR_RX_DATA_REG: begin
                        pslverr = pwrite;
                    end
                    ADDR_CFG_REG: begin
                        pslverr = pwrite ? 0 : 1;
                    end
                    ADDR_CTRL_REG: begin
                        pslverr = pwrite ? 0 : 1;
                    end
                    ADDR_STT_REG: begin
                        pslverr = pwrite ? 1 : parity_error_i;
                    end
                    default: begin
                        pslverr = 1;
                    end
                endcase
            end else begin
                pslverr = 0;
            end
        end
        default: begin
            pwrite_o = 0;
            paddr_o = 0;
            pstrb_o = 0;
            pwdata_o = 0;
            pready = 0;
            pslverr = 0;
        end
    endcase
end

assign psel_o = psel;
assign penable_o = penable;

endmodule