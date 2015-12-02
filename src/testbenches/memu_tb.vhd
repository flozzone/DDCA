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
	signal s_M    : mem_out_type;
	signal s_R    : std_logic_vector(DATA_WIDTH-1 downto 0);
	signal s_XL   : std_logic;
	signal s_XS   : std_logic;

begin
	memu_inst : entity memu
	port map (
		op => s_op,
		A => s_A,
		W => s_W,
		D => s_D,
		M => s_M,
		R => s_R,
		XL => s_XL,
		XS => s_XS
	);

	-- Generates the clock signal
	clkgen : process
	begin
		clk <= '0';
		wait for CLK_PERIOD/2;
		clk <= '1';
		wait for CLK_PERIOD/2;
	end process clkgen;

	test : process
	begin
		s_op.memread <= '1';
		s_op.memwrite <= '1';
		s_op.memtype <= MEM_B;
	end process test;
end arch;