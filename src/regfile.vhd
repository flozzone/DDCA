library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.core_pack.all;

entity regfile is
    
    port (
        clk, reset       : in  std_logic;
        stall            : in  std_logic;
        rdaddr1, rdaddr2 : in  std_logic_vector(REG_BITS-1 downto 0);
        rddata1, rddata2 : out std_logic_vector(DATA_WIDTH-1 downto 0);
        wraddr           : in  std_logic_vector(REG_BITS-1 downto 0);
        wrdata           : in  std_logic_vector(DATA_WIDTH-1 downto 0);
        regwrite         : in  std_logic);

end regfile;

architecture rtl of regfile is
    
    type register_type is array ((2**REG_BITS)-1 downto 0) of std_logic_vector (DATA_WIDTH-1 downto 0);
    signal register_A : register_type := (others => (others => '0')); -- init

begin  -- rtl
    
    sync : process (clk, reset)
    
    begin
        if reset = '0' then
            rddata1 <= (others => '0');
            rddata2 <= (others => '0');
            
            -- reset registry
            --register_A <= (others => (others => '0'));
            
        elsif rising_edge(clk) then
            if regwrite = '1' then
                if not (wraddr = (wraddr'range => '0')) then
                    -- no writes on addr 0
                    register_A(To_integer(unsigned(wraddr))) <= wrdata;
                end if;
            end if; -- wrdata
            
            if stall = '0' then
                -- latch requested values
                rddata1 <= register_A(To_integer(unsigned(rdaddr1)));
                rddata2 <= register_A(To_integer(unsigned(rdaddr2)));
            end if; -- stall
        end if; -- clk edge
    end process sync;
end rtl;
