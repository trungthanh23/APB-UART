module uart_tx(
    //Gold signals
    input           clk,
    input           rst_n,

    //Baudrate generator signals
    input           tx_tick,

    //Register block signals
    input   [31:0]  tx_data_i,
    input   [1 :0]  data_bit_num_i,
    input           start_tx_i,
    input           parity_en_i,
    input           parity_type_i,
    input           stop_bit_num_i,
    output  logic   tx_done_o,

    //Peripheral signals 
    input           cts_n,
    output  logic   tx
);
    //State machine states
    enum logic [2:0] {
        TX_IDLE  =  2'b00,
        TX_START =  2'b01,
        TX_DATA  =  2'b10,
        TX_STOP  =  2'b11
    } current_state, next_state;

    logic [3:0] data_tx_count;      
    logic [1:0] stop_tx_count;      
    logic [3:0] num_data_bit_tx;    
    logic [1:0] num_stop_bit_tx;

    //Current state
    always_ff @(posedge clk, negedge rst_n) begin
        if (!rst_n) begin
            current_state <= TX_IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    //Next state
    always_comb begin
        case (current_state)
            TX_IDLE: begin
                if (start_tx_i && !cts_n) begin
                    next_state = TX_START;
                end else begin
                    next_state = TX_IDLE;
                end
            end
            TX_START:begin
                if (tx_tick) begin
                    next_state = TX_DATA;
                end else begin
                    next_state = TX_START;
                end
            end
            TX_DATA:begin
                if (tx_tick && (data_tx_count == num_data_bit_tx - 1)) begin
                    if (num_stop_bit_tx == 0) begin
                        next_state = TX_IDLE;
                    end else begin
                        next_state = TX_STOP;
                    end
                end else begin
                    next_state = TX_DATA;
                end
            end
            TX_STOP:begin
                if (tx_tick && (stop_tx_count == num_stop_bit_tx - 1)) begin
                    next_state = TX_IDLE;
                end else begin
                    next_state = TX_STOP;
                end
            end
            default: next_state = TX_IDLE;
        endcase
    end

//Output
always_comb begin
    case (current_state)
        TX_IDLE: begin
            tx_done_o = 1;
            tx = 1;
        end
        TX_START: begin
            tx_done_o = 0;
            tx = 0;
        end
        TX_DATA: begin
            tx_done_o = 0;
            tx = tx_data_i[data_tx_count];
        end
        TX_STOP: begin
            if ((tx_tick && (stop_tx_count == num_stop_bit_tx - 1)) || (num_stop_bit_tx == 0)) begin
                tx_done_o = 1;
            end else begin
                tx_done_o = 0;
            end
            if (parity_en_i) begin
                case ({parity_en_i, data_bit_num_i})
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
                if (stop_bit_num_i) begin
                    tx = 1;
                end else begin
                end
            end
        end
        default: begin
            tx_done_o = 1;
            tx = 1;
        end
    endcase
end

//Count number of data bit tx and stop bit tx
always_ff @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
        data_tx_count <= 0;
        stop_tx_count <= 0;
    end else begin
        case (current_state)
            TX_IDLE: begin
                data_tx_count <= 0;
                stop_tx_count <= 0;
            end
            TX_START: begin
                data_tx_count <= 0;
                stop_tx_count <= 0;
            end
            TX_DATA: begin
                if (tx_tick) begin
                    data_tx_count <= data_tx_count + 1;
                end else begin
                    data_tx_count <= data_tx_count;
                end
                stop_tx_count <= 0;
            end
            TX_STOP: begin
                data_tx_count <= data_tx_count;
                if (tx_tick) begin
                    stop_tx_count <= stop_tx_count + 1;
                end else begin
                    stop_tx_count <= stop_tx_count;
                end
            end
            default: begin
                data_tx_count <= 0;
                stop_tx_count <= 0;
            end
        endcase
    end
end

//Decode number of data bit tx and stop bit tx
always_comb begin
    case (data_bit_num_i)
        2'b00: num_data_bit_tx = 5;
        2'b01: num_data_bit_tx = 6;
        2'b10: num_data_bit_tx = 7;
        2'b11: num_data_bit_tx = 8;
        default: num_data_bit_tx = 8;
    endcase
end

always_comb begin
    case ({stop_bit_num_i, parity_en_i})
        2'b00: num_stop_bit_tx = 0;
        2'b01: num_stop_bit_tx = 1;
        2'b10: num_stop_bit_tx = 1;
        2'b11: num_stop_bit_tx = 2;
        default: num_stop_bit_tx = 0;
    endcase
end

endmodule


