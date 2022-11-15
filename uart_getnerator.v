module uart_brg (
    input      clk,
    input  [1:0] baud_rate,
    output reg rx_tick = 1'b0,
				tx_tick = 1'b0
);
//variable define start
integer  baud_wide , counter = 0;
reg [31:0] freq = 10000000 ;

//variable define end

always@(baud_rate) begin //used to initialize variable and to calculate the baud wide 
    
    
    case (baud_rate)
        0:begin //4800 B/s
            baud_wide <= (freq / (4800 * 16));
        end
        1:begin // 9600 B/s
            baud_wide <= (freq / (9600 * 16));
        end
        2:begin //14400 B/s
            baud_wide <= (freq / (14400 * 16));
        end
        3:begin //19200 B/s
            baud_wide <= (freq / (19200 * 16));
        end

    endcase
end

always @(posedge clk) begin
    
    if(counter == baud_wide) begin
        rx_tick <= ~rx_tick;
        tx_tick <= ~tx_tick;
        counter = 0;
    end else begin
       counter <= counter + 1'b1;
    end
end

endmodule