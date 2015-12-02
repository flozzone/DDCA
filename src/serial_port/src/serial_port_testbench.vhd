library ieee;
use ieee.std_logic_1164.all;
use work.testbench_util_pkg.all;

use work.serial_port_pkg.serial_port;

entity serial_port_testbench is
end serial_port_testbench;

architecture beh of serial_port_testbench is

  constant CLK_PERIOD : time := 20 ns;

  signal clk, reset_n      : std_logic;
  
  signal tx_data : std_logic_vector(7 downto 0);
  signal tx_wr : std_logic;
  signal tx_free : std_logic;
  signal rx_data : std_logic_vector(7 downto 0);
  signal rx_rd : std_logic;
  signal rx_data_full : std_logic;
  signal rx_data_empty : std_logic;
  signal rx : std_logic;
  signal tx : std_logic;

begin

--------------------------------------------
-- Instantiate your top level entity here --
--------------------------------------------
-- The testbench generates the above      --
-- four signals - use them as inputs to   --
-- your system                            --
--------------------------------------------

  rx <= tx;

  serial_port_inst : serial_port
  generic map (
    CLK_FREQ => 25000000,
    BAUD_RATE => 2500000,
    SYNC_STAGES => 2,
    TX_FIFO_DEPTH => 1,
    RX_FIFO_DEPTH => 1 
  )
  port map (
    clk => clk,
    res_n => reset_n,
    tx_data => tx_data,
    tx_wr => tx_wr,
    tx_free => tx_free,
    rx_data => rx_data,
    rx_rd => rx_rd,
    rx_data_full => rx_data_full,
    rx_data_empty => rx_data_empty,
    rx => rx,
    tx => tx
  );
  
  -- Generates the clock signal
  clkgen : process
  begin
    clk <= '0';
    wait for CLK_PERIOD/2;
    clk <= '1';
    wait for CLK_PERIOD/2;
  end process clkgen;

  -- Generates the reset signal
  reset : process
  begin  -- process resetsim:/testbench/CLK_PERIOD
    reset_n <= '0';
    wait_cycle(clk, 10);
    reset_n <= '1';
    wait;
  end process;
  
  send_data : process
  begin
    tx_wr <= '0';
    wait_cycle(clk, 15);
    tx_data <= "01100001";
    tx_wr <= '1';
    wait for 2 * CLK_PERIOD;
    tx_data <= "00000000";
    tx_wr <= '0';
    wait for 2500 ns;
    rx_rd <= '1';
  end process;

end beh;
