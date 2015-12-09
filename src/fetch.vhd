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

signal current_pc 		: std_logic_vector(PC_WIDTH-1 downto 0);
signal imem_addr 		: std_logic_vector (11 downto 0);

signal int_pc			: std_logic_vector (PC_WIDTH-1 downto 0) := (others => '0');
signal int_pc_next 		: std_logic_vector (PC_WIDTH-1 downto 0) := (others => '0');


begin  -- rtl
	imem : entity imem_altera
	port map (
		address => imem_addr,
		clock => clk,
		q	=> instr
	);

	-- #################### --
    -- process: fetchinputs --
    -- #################### --
    fetchinputs : process (clk, reset)
    begin
        if reset = '0' then
            int_pc 		<= (others => '0');
        elsif rising_edge(clk) then
            int_pc 		<= int_pc_next;
        end if;
    end process fetchinputs;

	pc_out <= int_pc_next;
	imem_addr <= std_logic_vector(int_pc_next(PC_WIDTH-1 downto 2));

	-- ############### --
    -- process: output --
    -- ############### --
    output : process (reset, stall, pcsrc, int_pc, pc_in)
    begin
        if reset = '0' then
            -- reset outupt rddatas and latch_rddata_nexts
            int_pc_next 	<= (others => '0');
        elsif stall = '1' then
			int_pc_next <= int_pc;
        else
			if pcsrc = '1' then
				int_pc_next <= pc_in;
			else
				int_pc_next <= std_logic_vector(unsigned(int_pc) + to_unsigned(4, PC_WIDTH));
			end if;

        end if; -- clk edge

    end process output;
end rtl;
