module uart_trasmitter (
    input [1:0] parity_type ,
    input [3:0] frame_length ,
    input [0:0] stop_bit_type, 
    input tx_tick,
    input [7:0] data_in,
    input enable,
    output tx,
    output tx_done
);

localparam [2:0] idl=3'b000,start = 3'b001,sending = 3'b010,parity = 3'b011,stop = 3'b100;

reg [2:0] counter = 3'd0;
reg [3:0] frame_counter = 4'd0;
reg [7:0] data;
reg data_out,parity_bit = 1'b0,stop_bit = 1'b0,done = 0;
reg [2:0] state = idl;

assign tx = data_out;
assign tx_done = done;

always@(posedge tx_tick) begin
       state <= enable ? state : idl;
       case (state)
       idl : begin
            data_out <= 1'b1;
            parity_bit <= 1'b0;
            stop_bit <= 1'b0;
            frame_counter <= 4'd0;
            data <= counter == 3'd0 ? data_in : data;   
            done <= 0;
            if(enable == 1'b1)begin
                state <= start;
            end
            else begin
                state <= idl;
            end  
        end 
        start : begin  
          data_out <= 1'b0;
          state <= sending; 
          stop_bit <= 1'b0;
          frame_counter <= 4'd0; 
        end
        sending : begin
            data_out <= data[counter];
            data[counter] <= 1'bx;
            parity_bit <= data_out=== 1'bx ? 1'b0^parity_bit : data_out ^ parity_bit;
            if(frame_counter == frame_length-1)begin
                if(!parity_type == 0)begin
                    state <= parity;
                end 
                else begin
                    state <= stop;
                end
            end 
            frame_counter <= frame_counter + 1'b1;
            counter <= counter + 1'b1;
        end
        parity : begin
            if(parity_type == 2'b01 )begin
                if(parity_bit == 1'b1)begin
                    data_out<= 1'b0;
                end  
                else begin
                    data_out<= 1'b1;
                end
                state <= stop;
            end 
            else begin
               if(parity_bit == 1'b1)begin
                
                    data_out<= 1'b1;
                end  
                else begin
                    data_out<= 1'b0; 
                end
                state <= stop;
            end
        end
        stop : begin
            data_out <= 1'b1;
            if(stop_bit_type == 1'b0)begin
                done <= counter == frame_length && frame_length != 4'd8 ? 1'b0 : 1'b1;
                state <= idl;
            end
            if(stop_bit == 1'b1)begin
                done <= counter == frame_length && frame_length != 4'd8 ? 1'b0 : 1'b1;
                state <= idl;
            end
            stop_bit <= 1'b1;
        end
       endcase 
    end

endmodule
