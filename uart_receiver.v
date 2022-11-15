module uart_recevier(
    input [1:0] parity_type ,
    input [3:0] frame_length ,
    input [0:0] stop_bit_type , 
    input  rx_tick,
    input  data_in,
    input  enable,
    output [7:0] rx_data,
    output rx_done
);

localparam [1:0] idl=2'b00,receving = 2'b01,parity = 2'b10,stop = 2'b11;

reg [2:0] counter = 3'd0;
reg [3:0] frame_counter = 4'd0;
reg [7:0] data;
reg done = 1'b0 , stop_bit = 1'b0,parity_bit = 1'b0;
reg [1:0] state = idl;

assign rx_done = done;
assign rx_data = done ? data : 8'bzzzz_zzzz;

always@(posedge rx_tick) begin
       state <= enable ? state : idl;
       case (state)
       idl : begin
            frame_counter <= 4'd0;
            stop_bit <= 1'b0; 
            done <= 0;
            if(data_in == 1'b0 && enable)begin
                state <= receving;
            end
            else begin
                state <= idl;
            end
        end 
        receving : begin  
            data[counter] <=  data_in === 1'bx ? data[counter] : data_in;
            parity_bit <= data_in=== 1'bx ? 1'b0^parity_bit : data_in ^ parity_bit;
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

            state <= stop; // ToDo ask hamza what to do if there is an error in the parity 
        end
        stop : begin
            if(stop_bit_type == 1'b0)begin 
                done <= (!(data^data)=== 1'bx) ? 1'b0 : 1'b1; 
                state <= idl;
            end
            if(stop_bit == 1'b1)begin
                done <= (!(data^data)=== 1'bx)  ? 1'b0 : 1'b1; 
                state <= idl;
            end
            stop_bit <= 1'b1;
        end
       endcase 
    end

endmodule
