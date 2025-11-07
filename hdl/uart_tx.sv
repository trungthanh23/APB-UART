module uart_tx (
    // Global signals
    input           clk,
    input           reset_n,

    // Baudrate generator signals
    input           tx_tick,

    // Register block signals
    input   [31:0]  tx_data_i,
    input   [1 :0]  data_bit_num_i,
    input           start_tx_i,
    input           parity_en_i,
    input           parity_type_i,
    input           stop_bit_num_i,
    output  logic   tx_done_o,
    output  logic   tx_start_ack_o,

    // Peripheral signals 
    input           cts_n,
    output  logic   tx
);
    // State machine states
    enum logic [1:0] {
        TX_IDLE  = 2'b00,
        TX_START = 2'b01,
        TX_DATA  = 2'b10,
        TX_STOP  = 2'b11
    } current_state, next_state;

    logic [3:0] data_current_count, data_next_count;      
    logic [1:0] stop_current_count, stop_next_count;      
    logic [3:0] tick_current_count, tick_next_count; 
    logic [3:0] num_data_bit_tx;    
    logic [1:0] num_stop_bit_tx;

    // Tick counter block
    always_ff @(posedge clk, negedge reset_n) begin
        if (!reset_n) begin
            tick_current_count <= 0;
        end else if (current_state == TX_IDLE && start_tx_i && !cts_n) begin
            tick_current_count <= 0;
        end else if (tx_tick) begin
            tick_current_count <= tick_next_count;
        end
    end

    always_comb begin
        if (tick_current_count == 4'd15) begin
            tick_next_count = 0;
        end else begin
            tick_next_count = tick_current_count + 1;
        end
    end

    // Current state
    always_ff @(posedge clk, negedge reset_n) begin
        if (!reset_n) begin
            current_state <= TX_IDLE;
        end else if (tx_tick && tick_current_count == 4'd15) begin
            current_state <= next_state;
        end else if (current_state == TX_IDLE && start_tx_i && !cts_n) begin
            current_state <= TX_START;
        end
    end

    // Next state
    always_comb begin
        case (current_state)
            TX_IDLE: begin
                if (start_tx_i && !cts_n) begin
                    next_state = TX_START;
                end else begin
                    next_state = TX_IDLE;
                end
            end
            TX_START: begin
                if (tick_current_count == 4'd15) begin
                    next_state = TX_DATA;
                end else begin
                    next_state = TX_START;
                end
            end
            TX_DATA: begin
                if (tick_current_count == 4'd15 && data_current_count == num_data_bit_tx - 1) begin
                    next_state = TX_STOP;
                end else begin
                    next_state = TX_DATA;
                end
            end
            TX_STOP: begin
                if (tick_current_count == 4'd15 && stop_current_count == num_stop_bit_tx - 1) begin
                    if (start_tx_i && !cts_n) begin
                        next_state = TX_START;
                    end else begin
                        next_state = TX_IDLE;
                    end
                end else begin
                    next_state = TX_STOP;
                end
            end
            default: next_state = TX_IDLE;
        endcase
    end

    // Handshake signal tx_start_ack
    always_ff @(posedge clk, negedge reset_n) begin
        if (!reset_n) begin
            tx_start_ack_o <= 0;
        end else if (current_state == TX_IDLE && start_tx_i && !cts_n) begin
            tx_start_ack_o <= 1; 
        end else begin
            tx_start_ack_o <= 0; 
        end
    end

    // Output tx_done_o
    always_ff @(posedge clk, negedge reset_n) begin
        if (!reset_n) begin
            tx_done_o <= 1;
        end else if (start_tx_i && current_state == TX_IDLE) begin
            tx_done_o <= 0; 
        end else if (tx_tick && tick_current_count == 4'd15 && current_state == TX_STOP && stop_current_count == num_stop_bit_tx - 1) begin
            tx_done_o <= 1; 
        end
    end

    // Output Tx
    always_comb begin
        case (current_state)
            TX_IDLE: begin
                tx = 1;
            end
            TX_START: begin
                tx = 0; 
            end
            TX_DATA: begin
                tx = tx_data_i[data_current_count];
            end
            TX_STOP: begin
                if (parity_en_i && stop_current_count == 0) begin
                    case ({parity_type_i, data_bit_num_i})
                        3'b000: tx = ~(^tx_data_i[4:0]);
                        3'b001: tx = ~(^tx_data_i[5:0]);
                        3'b010: tx = ~(^tx_data_i[6:0]);
                        3'b011: tx = ~(^tx_data_i[7:0]);
                        3'b100: tx = (^tx_data_i[4:0]);
                        
                        3'b101: tx = (^tx_data_i[5:0]);
                        3'b110: tx = (^tx_data_i[6:0]);
                        3'b111: tx = (^tx_data_i[7:0]);
                        default: tx = 1;
                    endcase
                end else begin
                    tx = 1; 
                end
            end
            default: begin
                tx = 1;
            end
        endcase
    end

    // Count number of data bits
    always_ff @(posedge clk, negedge reset_n) begin
        if (!reset_n) begin
            data_current_count <= 0;
        end else if (tx_tick && tick_current_count == 4'd15) begin
            data_current_count <= data_next_count;
        end
    end

    always_comb begin
        case (current_state)
            TX_IDLE, TX_START: begin
                data_next_count = 0;
            end
            TX_DATA: begin
                data_next_count = data_current_count + 1;
            end
            TX_STOP: begin
                data_next_count = 0;
            end
            default: begin
                data_next_count = 0;
            end
        endcase
    end

    // Count number of stop bits
    always_ff @(posedge clk, negedge reset_n) begin
        if (!reset_n) begin
            stop_current_count <= 0;
        end else if (tx_tick && tick_current_count == 4'd15) begin
            stop_current_count <= stop_next_count;
        end
    end

    always_comb begin
        case (current_state)
            TX_IDLE, TX_START, TX_DATA: begin
                stop_next_count = 0;
            end
            TX_STOP: begin
                stop_next_count = stop_current_count + 1;
            end
            default: begin
                stop_next_count = 0;
            end
        endcase
    end

    // Decode number bits in state data
    always_comb begin
        case (data_bit_num_i)
            2'b00: num_data_bit_tx = 5;
            2'b01: num_data_bit_tx = 6;
            2'b10: num_data_bit_tx = 7;
            2'b11: num_data_bit_tx = 8;
            default: num_data_bit_tx = 8;
        endcase
    end

    // Decode number bits in state stop
    always_comb begin
        case ({parity_en_i, stop_bit_num_i})
            2'b00: num_stop_bit_tx = 1; 
            2'b01: num_stop_bit_tx = 2; 
            2'b10: num_stop_bit_tx = 2; 
            2'b11: num_stop_bit_tx = 3; 
            default: num_stop_bit_tx = 1;
        endcase
    end

endmodule
