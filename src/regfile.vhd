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
    signal register_A : register_type := (others => std_logic_vector(to_unsigned(0, DATA_WIDTH))); -- init

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
                if not (To_integer(unsigned(wraddr)) = 0) then
                    -- no writes on addr 0
                    register_A(To_integer(unsigned(wraddr))) <= wrdata;
                end if;
            end if; -- wrdata
            
            if stall = '0' then
                -- latch requested values
                -- read from adress 0 returns 0
                -- writes are only visible in the next cycle, 
                -- but the newest value should always be read
                if (To_integer(unsigned(rdaddr1)) = 0) then
                    rddata1 <= std_logic_vector(to_unsigned(0, rddata2'length));
                elsif (wraddr = rdaddr1) and (regwrite = '1') then    
                    rddata1 <= wrdata;
                else 
                    rddata1 <= register_A(To_integer(unsigned(rdaddr1)));
                end if;

                if (To_integer(unsigned(rdaddr2)) = 0) then
                    rddata2 <= std_logic_vector(to_unsigned(0, rddata2'length));
                elsif (wraddr = rdaddr2) and (regwrite = '1') then    
                    rddata2 <= register_A(To_integer(unsigned(wraddr)));
                else 
                    rddata2 <= register_A(To_integer(unsigned(rdaddr2)));
                end if;               

            end if; -- stall
        end if; -- clk edge
    end process sync;
end rtl;
