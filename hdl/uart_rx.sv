module uart_rx (
    / Global signals
    input           clk,
    input           rst_n,

    // Baudrate generator signals
    input           rx_tick,

    //Register block signals
    input         [1 :0]   data_bit_num_i,
    input                  parity_en_i,
    input                  parity_type_i,
    input                  stop_bit_num_i,
    output  logic          rx_done_o, 
    output  logic          parity_error_o,
    output  logic [31:0]   rx_data_o,

    // Peripheral signals
    input           rx,
    output logic    rts_n
);
    enum logic [1:0]{
        RX_IDLE  = 2'b00,
        RX_DATA  = 2'b01,
        RX_STOP  = 2'b10
    } current_state, next_state;

    logic [3:0] data_rx_count;
    logic [1:0] stop_rx_count;
    logic [3:0] num_data_bit_rx;
    logic [1:0] num_stop_bit_rx;

    logic [3:0] count;
    logic [7:0] data_reg;
    logic [2:0] stop_reg;

    logic       parity_cal;

    //Current state 
    always_ff @(posedge clk, negedge rst_n)begin
        if (!rst_n) begin
            current_state <= RX_IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    //Next state
    always_comb begin
        case (current_state)
            RX_IDLE: begin
                if(~rx && (count == 4'd15)) next_state = RX_DATA;
                else next_state = RX_IDLE;
            end
            RX_DATA: begin
                if ((data_rx_count == num_data_bit_rx) && (count == 4'd15)) next_state = RX_STOP;
                else next_state = RX_DATA;
            end
            RX_STOP: begin
                if ((stop_rx_count == num_stop_bit_rx) && (count == 4'd15)) next_state = RX_IDLE;
                else next_state = RX_STOP;
            end
            default: next_state = RX_IDLE;
        endcase
    end

    //Count number data bit and number stop bit
    always_ff @(posedge clk, negedge rst_n)begin
        if (~rst_n) begin
            stop_rx_count <= 0;
            data_rx_count <= 0;
            count <= 0;
            data_reg <= 0;
            stop_reg <= 0;
        end else begin
            case (current_state)
                RX_IDLE: begin
                    stop_rx_count <= 0;
                    data_rx_count <= 0;
                    if (rx_tick) begin
                        if (count != 4'd15) count <= count + 1;
                        else count <= 0;
                    end else count <= count;
                end
                RX_DATA: begin
                    if (rx_tick) begin
                        if (count == 4'd15) begin
                            count <= 0;
                        end else if (count == 4'd8) begin
                            count <= count + 1;
                            data_reg[data_rx_count] <= rx;
                            data_rx_count <= data_rx_count + 1;
                            stop_rx_count <= 0;
                        end else begin
                            count <= count + 1;
                        end
                    end else begin
                        count <= count;
                    end
                end
                RX_STOP: begin
                    
                    if (rx_tick) begin
                        if (count == 4'd15) begin
                            count <= 0;
                        end else if (count == 4'd8) begin
                            count <= count + 1;
                            stop_reg[stop_rx_count] <= rx;
                            stop_rx_count <= stop_rx_count + 1;
                            data_rx_count <= 0;
                        end else begin
                            count <= count + 1;
                        end
                    end else begin
                        count <= count;
                    end
                end
                default: begin
                    data_rx_count <= 0;
                    stop_rx_count <= 0;
                end
            endcase
        end
    end

    //Config rx_done
    always_comb begin
        case (current_state)
            RX_IDLE: begin
                rx_done_o = 0;
            end
            RX_DATA: begin
                rx_done_o = 0;
            end
            RX_STOP: begin
                if ((stop_rx_count == num_stop_bit_rx) && (count == 4'd15)) begin
                    rx_done_o = 1;
                end else begin
                    rx_done_o = 0;
                end
            end
            default: begin
                rx_done_o = 0;
            end
        endcase
    end
    
    //Check parity bit
    always_comb begin
        if (((data_rx_count == num_data_bit_rx) && (count == 4'd15)) && parity_en_i) begin
            case ({parity_type_i, data_bit_num_i})
                3'b000: parity_cal = ~(^data_reg[4:0]);
                3'b001: parity_cal = ~(^data_reg[5:0]);
                3'b010: parity_cal = ~(^data_reg[6:0]);
                3'b011: parity_cal = ~(^data_reg[7:0]);
                3'b100: parity_cal = ^data_reg[4:0];
                3'b101: parity_cal = ^data_reg[5:0];
                3'b110: parity_cal = ^data_reg[6:0];
                3'b111: parity_cal = ^data_reg[7:0];
                default: parity_cal = 0; 
            endcase
        end else begin
            parity_cal = 0;
        end
    end

    assign parity_error_o = (parity_en_i ? stop_reg[0] : 0) != parity_cal;

    //Data out
    always_comb begin
        case (data_bit_num_i)
            2'b00: rx_data_o = {27'b0, data_reg[4:0]};
            2'b01: rx_data_o = {26'b0, data_reg[5:0]};
            2'b10: rx_data_o = {25'b0, data_reg[6:0]};
            2'b11: rx_data_o = {24'b0, data_reg[7:0]};
            default: rx_data_o = {24'b0, data_reg[7:0]};
        endcase
    end

    // Decode number bits in state data
    always_comb begin
        case (data_bit_num_i)
            2'b00: num_data_bit_rx = 5;
            2'b01: num_data_bit_rx = 6;
            2'b10: num_data_bit_rx = 7;
            2'b11: num_data_bit_rx = 8;
            default: num_data_bit_rx = 8;
        endcase
    end

    // Decode number bits in state stop
    always_comb begin
        case ({parity_en_i, stop_bit_num_i})
            2'b00: num_stop_bit_rx = 0; 
            2'b01: num_stop_bit_rx = 1; 
            2'b10: num_stop_bit_rx = 1; 
            2'b11: num_stop_bit_rx = 2; 
            default: num_stop_bit_rx = 0;
        endcase
    end

    //Reques to Send
    assign rts_n = ~rx_done_o;
endmodule