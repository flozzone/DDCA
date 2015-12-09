library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.core_pack.all;

entity regfile is

    port (
        clk, reset       : in  std_logic;
        stall            : in  std_logic;
        rdaddr1, rdaddr2 : in  std_logic_vector(REG_BITS-1 downto 0);
        rddata1, rddata2 : out std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
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
    signal latch_rddata1        : std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
    signal latch_rddata1_next   : std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
    signal latch_rddata2        : std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
    signal latch_rddata2_next   : std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');

    -- internal signals for outputs
    signal output_rddata1       : std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
    signal output_rddata2       : std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');

    -- internal signals
    signal int_regwrite         : std_logic := '0';
    signal int_wr_zero          : std_logic := '0';

begin  -- rtl
    -- asynchronus stuff
    int_wr_zero    <= '1' when(wraddr = ZERO) else '0' ;
    int_regwrite   <= (reset) and (not stall)and (regwrite) and (not int_wr_zero);
    output_rddata1 <= std_logic_vector(register_A(To_integer(unsigned(rdaddr1))));
    output_rddata2 <= std_logic_vector(register_A(To_integer(unsigned(rdaddr2))));

    -- ###################### --
    -- process: registerwrite --
    -- ###################### --
    registerwrite : process (clk)
    begin
        if rising_edge(clk) then
            if int_regwrite = '1' then
                register_A(To_integer(unsigned(wraddr))) <= wrdata;
            end if;
        end if;
    end process registerwrite;

    -- #################### --
    -- process: latchinputs --
    -- #################### --
    latchinputs : process (clk, reset)
    begin
        if reset = '0' then
            latch_rddata1 <= (others => '0');
            latch_rddata2 <= (others => '0');
        elsif rising_edge(clk) then
            latch_rddata1 <= latch_rddata1_next;
            latch_rddata2 <= latch_rddata2_next;
        end if;
    end process latchinputs;

    -- ############### --
    -- process: output --
    -- ############### --
    output : process (reset, stall, rdaddr1, rdaddr2, wraddr, wrdata, int_regwrite, latch_rddata1, latch_rddata2, output_rddata1, output_rddata2)
    begin
        -- TODO: added because of inferred latch
        latch_rddata1_next <= (others => '0');
        latch_rddata2_next <= (others => '0');

        if reset = '0' then
            -- reset outupt rddatas and latch_rddata_nexts
            rddata1 <= (others => '0');
            rddata2 <= (others => '0');
            latch_rddata1_next <= (others => '0');
            latch_rddata2_next <= (others => '0');
        elsif stall = '1' then
            -- output previous latched rddatas
            rddata1 <= latch_rddata1;
            rddata2 <= latch_rddata2;
        else
            -- latch requested values
			-- writes are accesable in the next cycle,
			-- but the newest value should always be read
            if (wraddr = rdaddr1) and (int_regwrite = '1') then
                rddata1             <= wrdata;
                latch_rddata1_next  <= wrdata;
            else
                rddata1             <= output_rddata1;
                latch_rddata1_next  <= output_rddata1;
            end if;

            if (wraddr = rdaddr2) and (int_regwrite = '1') then
                rddata2             <= wrdata;
                latch_rddata2_next  <= wrdata;
            else
                rddata2             <= output_rddata2;
                latch_rddata2_next  <= output_rddata2;
            end if;

        end if; -- clk edge

    end process output;
end rtl;
