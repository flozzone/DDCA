library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.core_pack.all;
use work.op_pack.all;

entity wb is

    port (
        clk, reset : in  std_logic;
        stall      : in  std_logic;
        flush      : in  std_logic;
        op         : in  wb_op_type;
        rd_in      : in  std_logic_vector(REG_BITS-1 downto 0);
        aluresult  : in  std_logic_vector(DATA_WIDTH-1 downto 0);
        memresult  : in  std_logic_vector(DATA_WIDTH-1 downto 0);
        rd_out     : out std_logic_vector(REG_BITS-1 downto 0);
        result     : out std_logic_vector(DATA_WIDTH-1 downto 0);
        regwrite   : out std_logic);

end wb;

architecture rtl of wb is

signal int_op          : wb_op_type;
signal int_rd_in      : std_logic_vector(REG_BITS-1 downto 0);
signal int_aluresult  : std_logic_vector(DATA_WIDTH-1 downto 0);
signal int_memresult  : std_logic_vector(DATA_WIDTH-1 downto 0);


begin  -- rtl

    input : process(clk, reset)
    begin
        if reset = '0' then
            int_op <= WB_NOP;
            int_rd_in <= (others => '0');
            int_aluresult <= (others => '0');
            int_memresult <= (others => '0');
        elsif rising_edge(clk) then
            if flush = '1' then
                int_op <= WB_NOP;
                int_rd_in <= (others => '0');
                int_aluresult <= (others => '0');
                int_memresult <= (others => '0');
            elsif stall = '0' then
                int_op <= op;
                int_rd_in <= rd_in;
                int_aluresult <= aluresult;
                int_memresult <= memresult;
            end if;
        end if;
    end process input;

    wb : process(int_op, int_aluresult, int_memresult, int_rd_in)
    begin
        regwrite <= int_op.regwrite;
        rd_out <= int_rd_in;

        if int_op.memtoreg = '1' then
            result <= int_memresult;
        else
            result <= int_aluresult;
        end if;

    end process wb;
end rtl;
