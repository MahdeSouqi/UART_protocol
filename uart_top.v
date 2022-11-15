module uart_top(
    input  clk,
    input  [7:0] data,
    input  [2:0] addr,
    input  rx,
    output [7:0] data_received,
    output rx_done,
    output tx,
    output tx_done
);

reg [1:0] baud_rate = 2'b11 ;
reg [1:0] parity_type = 2'b01 ;
reg [3:0] frame_length = 4'd5 ;
reg [0:0] stop_bit_type = 1'b0 ;
reg tx_enable = 1'b0;
reg rx_enable = 1'b0;

wire rx_tick, tx_tick;

always @(addr , data,parity_type,frame_length,stop_bit_type) begin
    case (addr)
        3'b000 : begin // baud_rate configration
            baud_rate <= data;
            parity_type <= parity_type;
            frame_length <= frame_length;
            stop_bit_type <= stop_bit_type;
            tx_enable <= 1'b0;
            rx_enable <= 1'b0;
        end

        3'b001 : begin // parity_type configration
            parity_type <= data;
            baud_rate <= baud_rate;
            frame_length <= frame_length;
            stop_bit_type <= stop_bit_type;
            tx_enable <= 1'b0;
            rx_enable <= 1'b0;
        end 

        3'b010 : begin // frame_length configration
            frame_length <= data;
            baud_rate <= baud_rate;
            parity_type <= parity_type;
            stop_bit_type <= stop_bit_type;
            tx_enable <= 1'b0;
            rx_enable <= 1'b0;            
        end 

        3'b011 : begin // stop_bit configration
            stop_bit_type <= data;
            baud_rate <= baud_rate;
            parity_type <= parity_type;
            frame_length <= frame_length;
            tx_enable <= 1'b0;
            rx_enable <= 1'b0;            
        end
        3'b100 : begin // start trasmitting
            tx_enable <= 1'b1;
            rx_enable <= 1'b0; 
            baud_rate <= baud_rate;
            parity_type <= parity_type;
            frame_length <= frame_length;
            stop_bit_type <= stop_bit_type;
        end
        3'b101 : begin // start receiving
            rx_enable <= 1'b1;
            tx_enable <= 1'b0;
            parity_type <= parity_type;
            baud_rate <= baud_rate;
            frame_length <= frame_length;
            stop_bit_type <= stop_bit_type;
        end
        default : begin // ideal state 
            tx_enable <= 1'b0;
            rx_enable <= 1'b0;
            baud_rate <= baud_rate;
            parity_type <= parity_type;
            frame_length <= frame_length;
            stop_bit_type <= stop_bit_type;
        end
    endcase
end

uart_brg generator
 (  
    clk,
    baud_rate,
    rx_tick,
    tx_tick); 

uart_trasmitter trasmitter(  
    parity_type,
    frame_length,
    stop_bit_type,
    tx_tick,
    data,
    tx_enable,
    tx,
    tx_done);

uart_recevier recevier( 
    parity_type,
    frame_length,
    stop_bit_type,
    rx_tick,
    rx,
    rx_enable,
    data_received,
    rx_done);

    
endmodule
