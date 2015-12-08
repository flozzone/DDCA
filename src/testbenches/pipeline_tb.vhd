
library ieee;
use ieee.std_logic_1164.all;

use work.op_pack.all;
use work.core_pack.all;
use work.pipeline;


entity pipeline_tb is
end pipeline_tb;

architecture arch of pipeline_tb is
	constant CLK_PERIOD : time := 2 ps;
	signal clk		: std_logic;
	signal reset :	 std_logic;
	signal s_mem_in  : mem_in_type;
	signal s_intr : std_logic_vector(INTR_COUNT-1 downto 0);

	signal r_mem_out : mem_out_type;

	signal a_mem_out : mem_out_type;

  signal testfile : string(8 downto 1);
	signal int_clk_cnt : integer;

begin

	pipeline_inst : entity pipeline
	port map (
		clk => clk,
		reset => reset,
		mem_in => s_mem_in,
		mem_out => r_mem_out,
		intr => s_intr
	);

	sync_proc : process
	begin
		clk <= '0';
		wait for CLK_PERIOD/2;
		clk <= '1';
		wait for CLK_PERIOD/2;
	end process sync_proc;

	init_proc : process
	begin
		reset <= '0';
		wait for 2.5 ps;
		reset <= '1';
		wait until true;
	end process init_proc;

	test : process(clk)
		variable clk_cnt : integer := 0;
	begin
		if reset = '0' then
			clk_cnt := 0;
		elsif rising_edge(clk) then
			int_clk_cnt <= clk_cnt;
			assert r_mem_out = a_mem_out report testfile & ": mem_out is not equal";
			clk_cnt := clk_cnt + 1;
		end if;
	end process test;
end arch;