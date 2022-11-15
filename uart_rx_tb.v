module uart_rx_tb();


    
reg tx_tick,enable;
reg  [7:0] data_in;
wire tx1,tx_done1;
wire tx2,tx_done2;
wire tx3,tx_done3;
wire [7:0] rx_data1;
wire rx_done1;
wire [7:0] rx_data2;
wire rx_done2;
wire [7:0] rx_data3;
wire rx_done3;

uart_trasmitter dut1(  
    2'b00,
    4'b0101,
    1'b0,
    tx_tick,
    data_in,
    enable,
    tx1,
    tx_done1);

uart_recevier dut_rx1( 
    2'b00,
    4'b0101,
    1'b0,
    tx_tick,
    tx1,
    enable,
    rx_data1,
    rx_done1);

    uart_trasmitter dut2(  
    2'b01,
    4'b0110,
    1'b0,
    tx_tick,
    data_in,
    enable,
    tx2,
    tx_done2);

uart_recevier dut_rx2( 
    2'b01,
    4'b0110,
    1'b0,
    tx_tick,
    tx2,
    enable,
    rx_data2,
    rx_done2);

    uart_trasmitter dut3(  
    2'b01,
    4'b0101,
    1'b0,
    tx_tick,
    data_in,
    enable,
    tx3,
    tx_done3);

uart_recevier dut_rx3( 
   2'b10,
    4'b0111,
    1'b1,
    tx_tick,
    tx3,
    enable,
    rx_data3,
    rx_done3);

always  begin
    #5 tx_tick = ~ tx_tick;
end

initial begin
    $dumpfile("dump.vcd"); $dumpvars;
    tx_tick = 0;
    data_in = 8'b1010_1010;
    enable = 1'b0;
    #10 enable = 1'b1;


    #300 $finish();
end

    
endmodule