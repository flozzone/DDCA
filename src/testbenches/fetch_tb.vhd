
library ieee;
use ieee.std_logic_1164.all;

use work.op_pack.all;
use work.core_pack.all;
use work.fetch;


entity fetch_tb is
end fetch_tb;

architecture arch of fetch_tb is
	constant CLK_PERIOD : time := 20 ns;
  
	signal s_clk, s_reset : std_logic;
	signal s_stall      : std_logic;
	signal s_pcsrc	    : std_logic;
	signal s_pc_in	    : std_logic_vector(PC_WIDTH-1 downto 0);
	signal r_pc_out	    : std_logic_vector(PC_WIDTH-1 downto 0);
	signal r_instr	    : std_logic_vector(INSTR_WIDTH-1 downto 0);

	signal testfile : string(31 downto 1);

begin
	fetch_inst : entity fetch
	port map (
		clk => s_clk,
		reset => s_reset,
		stall => s_stall,
		pcsrc => s_pcsrc,
		pc_in => s_pc_in,
		pc_out => r_pc_out,
		instr => r_instr
	);

	clkgen : process
	begin
		s_clk <= '0';
		wait for 1 ns;
		s_clk <= '1';
		wait for 1 ns;
	end process clkgen;

	test : process
	begin
		wait for 1 ps;

		s_reset <= '0';

		wait for 1 ns;

		s_reset <= '1';
		s_stall <= '0';
		s_pcsrc <= '0';

		--assert r_M = a_M report testfile & ": M is not equal";
		--assert r_R = a_R report testfile & ": R is not equal";
		--assert r_XL = a_XL report testfile & ": XL ist not equal";
		--assert r_XS = a_XS report testfile & ": XS is not equal";

		wait for 1 ns;

		s_pc_in <= "00000000001000";
		--s_pcsrc <= '1';

		wait for 4.5 ns;
		s_stall <= '1';
		wait for 5 ns;
		s_stall <= '0';

		--wait until s_clk'event and s_clk='1';

		s_pcsrc <= '0';

		wait for 40 ms;

	end process test;
end arch;