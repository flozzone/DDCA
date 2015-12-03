library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.core_pack.all;

use work.imem_altera;

entity fetch is
	
	port (
		clk, reset : in	 std_logic;
		stall      : in  std_logic;
		pcsrc	   : in	 std_logic;
		pc_in	   : in	 std_logic_vector(PC_WIDTH-1 downto 0);
		pc_out	   : out std_logic_vector(PC_WIDTH-1 downto 0);
		instr	   : out std_logic_vector(INSTR_WIDTH-1 downto 0));

end fetch;

architecture rtl of fetch is

signal current_pc : std_logic_vector(PC_WIDTH-1 downto 0);
signal imem_addr : std_logic_vector (11 downto 0);

begin  -- rtl
	imem : entity imem_altera
	port map (
		address => imem_addr,
		clock => clk,
		q	=> instr
	);

	ctrl : process(clk, reset, stall, pcsrc, pc_in, current_pc)
	begin
		if reset = '0' then
			current_pc <= (others => '0');
			imem_addr <= std_logic_vector(current_pc(PC_WIDTH-1 downto 2));
			pc_out <= current_pc;
		elsif rising_edge(clk) then
			if stall = '0' then
				if pcsrc = '1' then
					-- next program counter = pc_in
					current_pc <= pc_in;
				else
					-- next program counter = current_pc + 4
					current_pc <= std_logic_vector(unsigned(current_pc) + 4);
				end if;
				imem_addr <= std_logic_vector(current_pc(PC_WIDTH-1 downto 2));
				pc_out <= current_pc;
			end if;
		end if;
	end process ctrl;
end rtl;
