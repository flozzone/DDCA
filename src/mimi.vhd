library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.core_pack.all;
use work.op_pack.all;

entity mimi is
	
	port (
		clk_pin   : in  std_logic;
		reset_pin : in  std_logic;
		tx  	  : out std_logic;
		rx        : in  std_logic;
		intr_pin  : in  std_logic_vector(INTR_COUNT-1 downto 0));

end mimi;

architecture rtl of mimi is

	signal clk : std_logic;
	signal reset : std_logic;
	signal pll_locked : std_logic;
	signal reset_reg0, reset_reg1 : std_logic;

	signal intr : std_logic_vector(INTR_COUNT-1 downto 0);
	signal intr_edge : std_logic_vector(INTR_COUNT-1 downto 0);
	signal intr_reg0, intr_reg1 : std_logic_vector(INTR_COUNT-1 downto 0);	
	
begin  -- rtl

	core : entity work.core
		generic map (
			clk_freq  => 75000000,
			baud_rate => 115200)
		port map (
			clk	  => clk,
			reset => reset,
			tx    => tx,
			rx    => rx,
			intr  => intr_edge);

	pll : entity work.pll port map (
		inclk0  => clk_pin,
		c0      => clk,
		locked  => pll_locked);

	sync: process (clk)
	begin  -- process sync
		if clk'event and clk = '1' then  -- rising clock edge
			-- external reset, pll must be locked
			reset_reg0 <= reset_pin and pll_locked;
			reset_reg1 <= reset_reg0;
			reset <= reset_reg1;

			-- interrupts are active high internally
			intr_reg0 <= not intr_pin;
			intr_reg1 <= intr_reg0;
			intr <= intr_reg1;
			for i in 0 to INTR_COUNT-1 loop
				if intr_reg1(i) = '1' and intr(i) = '0' then
					intr_edge(i) <= '1';
				else
					intr_edge(i) <= '0';
				end if;				
			end loop;  -- i
		end if;
	end process sync;
	
end rtl;
