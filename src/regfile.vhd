library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.core_pack.all;

entity regfile is

    port (
        clk, reset       : in  std_logic;
        stall            : in  std_logic;
        rdaddr1 : in  std_logic_vector(REG_BITS-1 downto 0);
        rdaddr2 : in  std_logic_vector(REG_BITS-1 downto 0);
        rddata1 : out std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
        rddata2 : out std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
        wraddr           : in  std_logic_vector(REG_BITS-1 downto 0);
        wrdata           : in  std_logic_vector(DATA_WIDTH-1 downto 0);
        regwrite         : in  std_logic);

end regfile;

architecture rtl of regfile is

    -- type declarations and constants
    type register_type is array ((2**REG_BITS)-1 downto 0) of std_logic_vector (DATA_WIDTH-1 downto 0);
    signal register_A : register_type := (others => std_logic_vector(to_unsigned(0, DATA_WIDTH))); -- init
    constant ZERO:  std_logic_vector (REG_BITS-1 downto 0) := (others => '0');

    -- latch signal
    signal latch_rdaddr1        : std_logic_vector(REG_BITS-1 downto 0) := (others => '0');
    signal latch_rdaddr2        : std_logic_vector(REG_BITS-1 downto 0) := (others => '0');

begin  -- rtl

    -- #################### --
    -- process: latchinputs --
    -- #################### --
    latchinputs : process (clk, reset)
    begin
        if reset = '0' then
            latch_rdaddr1 <= (others => '0');
            latch_rdaddr2 <= (others => '0');
        elsif rising_edge(clk) and stall = '0' then
                latch_rdaddr1 <= rdaddr1;
                latch_rdaddr2 <= rdaddr2;

                if regwrite = '1' and unsigned(wraddr) > 0 then
                    register_A(To_integer(unsigned(wraddr))) <= wrdata;
                end if;
        end if;
    end process latchinputs;

    -- ############### --
    -- process: output --
    -- ############### --
    output : process (latch_rdaddr1, latch_rdaddr2, wrdata, wraddr, regwrite, stall)
    begin
        -- set outputs
        rddata1 <= register_A(To_integer(unsigned(latch_rdaddr1)));
        rddata2 <= register_A(To_integer(unsigned(latch_rdaddr2)));

        if latch_rdaddr1 = wraddr and stall = '0' and regwrite = '1' and unsigned(wraddr) > 0 then
            rddata1 <= wrdata;
        end if;

        if latch_rdaddr2 = wraddr and stall = '0' and regwrite = '1' and unsigned(wraddr) > 0 then
            rddata2 <= wrdata;
        end if;
    end process output;
end rtl;
