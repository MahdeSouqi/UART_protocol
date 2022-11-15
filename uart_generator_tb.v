`timescale 100ps / 100ps
module uart_tb();

reg clk;

reg  rx_tick0 ,tx_tick0;
reg  rx_tick1 ,tx_tick1;
reg  rx_tick2 ,tx_tick2;
reg  rx_tick3 ,tx_tick3;

 uart_brg 
 dut0( 
  clk,
  2'b00,
  rx_tick0,
  tx_tick0);
  uart_brg 
 dut1( 
  clk,
  2'b01,
  rx_tick1,
  tx_tick1);
  uart_brg 
 dut2( 
  clk,
  2'b10,
  rx_tick2,
  tx_tick2);
  uart_brg 
 dut3( 
  clk,
  2'b11,
  rx_tick3,
  tx_tick3);

always #5 clk = ~clk;


initial begin
  
  $dumpfile("dump.vcd"); $dumpvars;
  clk = 0;
  dut0.freq = 10000000;
  dut1.freq = 10000000;
  dut2.freq = 10000000;
  dut3.freq = 10000000;

  #200000 $finish;
end



endmodule