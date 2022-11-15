module uart_top_tb();

    reg  clk;
    reg  [7:0] data;
    reg  [2:0] addr;
    reg  rx;
    wire [7:0] data_received;
    wire rx_done;
    wire tx;
    wire tx_done;
   

uart_top dut(
    clk,
    data,
    addr,
    rx,
    data_received,
    rx_done,
    tx,
    tx_done
);

always begin
    #5 clk = ~clk;
end

initial begin
    $dumpfile("dump.vcd"); $dumpvars;
    clk = 1'b0;
    addr = 3'b100;
    data = 8'b1010_1010;
    rx = 1'b0;

    #500 $finish;
end


endmodule