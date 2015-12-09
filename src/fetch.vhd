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

signal int_pc	: std_logic_vector (PC_WIDTH-1 downto 0);


begin  -- rtl
	imem : entity imem_altera
	port map (
		address => imem_addr,
		clock => clk,
		q	=> instr
	);

	fetch_input : process (clk, reset)
    begin
        if reset = '0' then
            -- reset intern signals
            int_pc      <= (others => '0');
			imem_addr 	<= (others => '0');
            pc_out  	<= (others => '0');
            instr 		<= (others => '0');
        elsif rising_edge(clk) then
            if stall = '0' then
                -- latch intern signals
				if pcsrc = '1' then
					int_pc <= pc_in;
				else
					int_pc <= std_logic_vector(unsigned(int_pc) + 4);
				end if;

				imem_addr <= std_logic_vector(int_pc(PC_WIDTH-1 downto 2));

            end if;
        end if;
    end process fetch_input;

	fetch_output : process(int_pc)
	begin
		pc_out <= int_pc;
	end process fetch_output;
end rtl;
