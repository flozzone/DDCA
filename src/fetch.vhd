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

--signal imem_addr         : std_logic_vector (11 downto 0);
signal int_pc            : std_logic_vector (PC_WIDTH-1 downto 0) := std_logic_vector(to_signed(-4, PC_WIDTH));
signal int_pc_next         : std_logic_vector (PC_WIDTH-1 downto 0) := (others => '0');
signal int_instr            : std_logic_vector(INSTR_WIDTH-1 downto 0);

begin  -- rtl
    imem : entity imem_altera
    port map (
        address => int_pc_next(PC_WIDTH-1 downto 2),
        clock => clk,
        q    => int_instr
    );

     -- todo process calc pc, flush, sync
     pc : process (stall, reset, pcsrc, int_pc, pc_in) 
     begin
        int_pc_next <= int_pc;
        pc_out <= int_pc;
        if stall = '0' and reset = '1' then
            if pcsrc = '1' then
                int_pc_next <= pc_in;
                pc_out <= pc_in;
            else
                int_pc_next <= std_logic_vector(unsigned(int_pc) + to_unsigned(4, PC_WIDTH));
                pc_out <= std_logic_vector(unsigned(int_pc) + to_unsigned(4, PC_WIDTH));
            end if;
        end if;
     end process pc;
     
     
     flush : process (pcsrc, int_instr)
     begin
        if pcsrc = '1' then
            instr <= (others => '0');
        else
            instr <= int_instr;
        end if;
     end process flush;
     
     sync : process (clk, reset)
     begin
        if reset = '0' then 
            int_pc <= std_logic_vector(to_signed(-4, PC_WIDTH));
        elsif rising_edge(clk) then
            int_pc <= int_pc_next;
        end if;
     end process sync;
end rtl;
