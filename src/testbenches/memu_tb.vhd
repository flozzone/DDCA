library ieee;
use ieee.std_logic_1164.all;

use work.op_pack.all;
use work.core_pack.all;
use work.memu;


entity memu_tb is
end memu_tb;

architecture arch of memu_tb is
	constant CLK_PERIOD : time := 20 ns;
	signal clk		: std_logic;

	signal s_op   : mem_op_type;
	signal s_A    : std_logic_vector(ADDR_WIDTH-1 downto 0);
	signal s_W    : std_logic_vector(DATA_WIDTH-1 downto 0);
	signal s_D    : std_logic_vector(DATA_WIDTH-1 downto 0);

	signal r_M    : mem_out_type;
	signal r_R    : std_logic_vector(DATA_WIDTH-1 downto 0);
	signal r_XL   : std_logic;
	signal r_XS   : std_logic;

	signal a_M    : mem_out_type;
	signal a_R    : std_logic_vector(DATA_WIDTH-1 downto 0);
	signal a_XL   : std_logic;
	signal a_XS   : std_logic;

begin
	memu_inst : entity memu
	port map (
		op => s_op,
		A => s_A,
		W => s_W,
		D => s_D,
		M => r_M,
		R => r_R,
		XL => r_XL,
		XS => r_XS
	);

	-- Generates the clock signal
	--clkgen : process
	--begin
	--	clk <= '0';
	--	wait for CLK_PERIOD/2;
	--	clk <= '1';
	--	wait for CLK_PERIOD/2;
	--end process clkgen;

	test : process
	begin
		s_op.memread <= '1';
		s_op.memwrite <= '1';
		s_op.memtype <= MEM_B;

		wait for 1 ps;

		assert r_M = a_M report "M is not equal";
		assert r_R = a_R report "R is not equal";
		assert r_XL = a_XL report "XL ist not equal";
		assert r_XS = a_XS report "XS is not equal";

		wait for 1 ps;

	end process test;
end arch;