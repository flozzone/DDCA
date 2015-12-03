library ieee;
use ieee.std_logic_1164.all;

use work.op_pack.all;
use work.core_pack.all;
use work.alu;


entity alu_tb is
end alu_tb;

architecture arch of alu_tb is
	constant CLK_PERIOD : time := 20 ns;
	signal clk		: std_logic;

	signal i_op   : alu_op_type;
	signal i_A    : std_logic_vector(DATA_WIDTH-1 downto 0);
	signal i_B    : std_logic_vector(DATA_WIDTH-1 downto 0);
	signal o_R    : std_logic_vector(DATA_WIDTH-1 downto 0);
	signal o_Z   : std_logic;
	signal o_V   : std_logic;

begin
	alu_inst : entity alu
	port map (
		op => i_op,
		A => i_A,
		B => i_B,
		R => o_R,
		V => o_V,
		Z => o_Z
	);

	test : process
	begin
		report "sending first ALU_ADD command";
		i_op <= ALU_ADD;
		i_A <= "11111111111111111111111111111111";
		i_B <= "11111111111111111111111111111111";

		wait for 1 ms;
		report "sent next ALU_ADD command";
		i_op <= ALU_ADD;
		i_A <= "01111111111111111111111111111111";
		i_B <= "01111111111111111111111111111111";

	end process test;
end arch;
