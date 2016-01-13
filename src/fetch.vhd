library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.core_pack.all;

use work.imem_altera;

entity fetch is

    port (
        clk, reset : in     std_logic;
        stall      : in  std_logic;
        pcsrc       : in     std_logic;
        pc_in       : in     std_logic_vector(PC_WIDTH-1 downto 0);
        pc_out       : out std_logic_vector(PC_WIDTH-1 downto 0);
        instr       : out std_logic_vector(INSTR_WIDTH-1 downto 0));

end fetch;

architecture rtl of fetch is

signal imem_addr         : std_logic_vector (11 downto 0);
signal int_pc            : std_logic_vector (PC_WIDTH-1 downto 0) := (others => '0');
signal int_pc_next         : std_logic_vector (PC_WIDTH-1 downto 0) := (others => '0');
signal int_instr			: std_logic_vector(INSTR_WIDTH-1 downto 0));

begin  -- rtl
    imem : entity imem_altera
    port map (
        address => imem_addr,
        clock => clk,
        q    => int_instr
    );

	 -- todo process calc pc, flush, sync
	 
	 pc : process (TODO) 
	 begin
		if stall = '0' then
			pc_out <= int_pc;
		else
			int_pc_next <= std_logic_vector(unsigned(int_pc) + to_unsigned(4, PC_WIDTH));
			pc_out <= std_logic_vector(unsigned(int_pc) + to_unsigned(4, PC_WIDTH));
		end if;
	 end process pc;
	 
	 
	 flush : process (TODO)
	 begin
		if pcsrc = '1' then
			instr <= (others => '0');
		else
			instr <= int_instr;
		end if;
	 end process flush;
	 
	 sync : process (TODO)
	 begin
		if reset = '0' then 
			int_pc <= std_logic_vector(to_signed(-4, PC_WIDTH)) ;
		elsif rising_edge(clk) then
			int_pc <= int_pc_next;
		end if;
	 end process sync;
--	 
--    -- #################### --
--    -- process: fetchinputs --
--    -- #################### --
--    fetchinputs : process (clk, reset)
--    begin
--        if reset = '0' then
--            int_pc         <= std_logic_vector(to_signed(-4, PC_WIDTH)) ;
--        elsif rising_edge(clk) then
--            if stall = '0' then
--                int_pc     <= int_pc_next;
--            end if;
--        end if;
--    end process fetchinputs;
--
--    pc_out <= int_pc;
--    imem_addr <= std_logic_vector(int_pc_next(PC_WIDTH-1 downto 2));
--
--    -- ############### --
--    -- process: output --
--    -- ############### --
--    output : process (reset, stall, pcsrc, int_pc, pc_in)
--    begin
--        if reset = '0' then
--            -- reset outupt rddatas and latch_rddata_nexts
--            int_pc_next     <= (others => '0');
--        elsif stall = '1' then
--            int_pc_next <= int_pc;
--        else
--            if pcsrc = '1' then
--                int_pc_next <= pc_in;
--            else
--                int_pc_next <= std_logic_vector(unsigned(int_pc) + to_unsigned(4, PC_WIDTH));
--            end if;
--
--        end if; -- clk edge
--
--    end process output;
end rtl;
