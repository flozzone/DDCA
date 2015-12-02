library ieee;
use ieee.std_logic_1164.all;

package testbench_util_pkg is
  procedure wait_cycle(signal clk : in std_logic; constant cycle_cnt : in integer);
  procedure sendreceive(
    signal clk  : inout std_logic;
    signal data : inout std_logic;
    constant tx : in    std_logic_vector(10 downto 0);
    variable rx : out   std_logic_vector(7 downto 0));
end testbench_util_pkg;

package body testbench_util_pkg is
  procedure wait_cycle(signal clk : in std_logic; constant cycle_cnt : in integer) is
  begin
    for i in 1 to cycle_cnt loop
      wait until rising_edge(clk);
    end loop;
  end wait_cycle;

  procedure sendreceive(
    signal clk  : inout std_logic;
    signal data : inout std_logic;
    constant tx : in    std_logic_vector(10 downto 0);
    variable rx : out   std_logic_vector(7 downto 0)) is

    variable index  : integer;
    variable temprx : std_logic_vector(10 downto 0);
  begin
    clk  <= 'H';
    data <= 'H';
    for index in 10 downto 0 loop
      data          <= tx(index);
      wait for 10 us;
      clk           <= '0';
      temprx(index) := data;
      wait for 30 us;
      clk           <= 'H';
      wait for 20 us;
    end loop;
    rx := temprx(9 downto 2);
  end sendreceive;

end package body testbench_util_pkg;
