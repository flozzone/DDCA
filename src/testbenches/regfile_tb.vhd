library ieee;
use ieee.std_logic_1164.all;

use work.op_pack.all;
use work.core_pack.all;
use work.regfile;


entity regfile_tb is
    function to_bstring(sl : std_logic) return string is
        variable sl_str_v : string(1 to 3);  -- std_logic image with quotes around
    begin
       sl_str_v := std_logic'image(sl);
        return "" & sl_str_v(2);  -- "" & character to get string
    end function;

    function to_bstring(slv : std_logic_vector) return string is
        alias    slv_norm : std_logic_vector(1 to slv'length) is slv;
        variable sl_str_v : string(1 to 1);  -- String of std_logic
        variable res_v    : string(1 to slv'length);
    begin
        for idx in slv_norm'range loop
            sl_str_v := to_bstring(slv_norm(idx));
            res_v(idx) := sl_str_v(1);
        end loop;
        return res_v;
    end function;
end regfile_tb;

architecture arch of regfile_tb is
    constant CLK_PERIOD : time := 20 ns;
    signal clk      : std_logic;

    signal s_reset      : std_logic;
    signal s_stall      : std_logic;
    signal s_rdaddr1    : std_logic_vector(REG_BITS-1 downto 0);
    signal s_rdaddr2    : std_logic_vector(REG_BITS-1 downto 0);
    signal s_wraddr     : std_logic_vector(REG_BITS-1 downto 0);
    signal s_wrdata     : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal s_regwrite   : std_logic;

    signal r_rddata1    : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal r_rddata2    : std_logic_vector(DATA_WIDTH-1 downto 0);

    signal a_rddata1    : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal a_rddata2    : std_logic_vector(DATA_WIDTH-1 downto 0);

    signal testfile : string(8 downto 1);

begin
    regfile_inst : entity regfile
    port map (
        clk         => clk,         -- in
        reset       => s_reset,     -- in
        stall       => s_stall,       -- in
        rdaddr1     => s_rdaddr1,     -- in
        rdaddr2     => s_rdaddr2,     -- in
        rddata1     => r_rddata1,     -- out
        rddata2     => r_rddata2,     -- out
        wraddr      => s_wraddr,      -- in
        wrdata      => s_wrdata,      -- in
        regwrite    => s_regwrite     -- in
    );

    test : process
    begin
        --IMPORTAND: set testrunner time to 4 ps

        s_reset <= '0';
        clk <= '0';
        

        wait for 2 ps;
        s_reset <= '1';
        clk <= '1';

        assert r_rddata1 = a_rddata1 report testfile & ": rddata1 is not equal: a_rddata1=" & to_bstring(a_rddata1) & " r_rddata1=" & to_bstring(r_rddata1);
        assert r_rddata2 = a_rddata2 report testfile & ": rddata2 is not equal: a_rddata2=" & to_bstring(a_rddata2) & " r_rddata2=" & to_bstring(r_rddata2);
        
        wait for 2 ps;
        clk <= '0';

    end process test;
end arch;
