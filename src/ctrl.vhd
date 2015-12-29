library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.core_pack.all;
use work.op_pack.all;

entity ctrl is

    port (
        clk : in std_logic;
        reset : in std_logic;
        pcsrc_in : in std_logic;
        pc_in : in std_logic_vector(PC_WIDTH-1 downto 0);

        pcsrc_out : out std_logic;
        pc_out : out std_logic_vector(PC_WIDTH-1 downto 0);

        flush_decode : out std_logic;
        flush_exec : out std_logic;
        flush_mem : out std_logic;
        flush_wb : out std_logic
);

end ctrl;

architecture rtl of ctrl is
begin  -- rtl
    pcsrc_out <= pcsrc_in;
    pc_out <= pc_in;

    branch_proc : process(pc_in, pcsrc_in)
    begin
        flush_decode <= '0';
        flush_exec <= '0';
        flush_mem <= '0';
        flush_wb <= '0';
        if pcsrc_in = '1' then
            flush_decode <= '1';
        end if;
    end process branch_proc;
end rtl;
