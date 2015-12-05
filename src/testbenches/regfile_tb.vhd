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
    signal s_clk        : std_logic;
    signal s_reset      : std_logic;
    signal s_stall      : std_logic;
    signal s_rdaddr1    : std_logic_vector(REG_BITS-1 downto 0);
    signal s_rdaddr2    : std_logic_vector(REG_BITS-1 downto 0);
    signal s_rddata1    : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal s_rddata2    : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal s_wraddr     : std_logic_vector(REG_BITS-1 downto 0);
    signal s_wrdata     : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal s_regwrite   : std_logic;

    signal testfile : string(31 downto 1);

begin
    regfile_inst : entity regfile
    port map (
        clk         => s_clk,         -- in
        reset       => s_reset,       -- in
        stall       => s_stall,       -- in
        rdaddr1     => s_rdaddr1,     -- in
        rdaddr2     => s_rdaddr2,     -- in
        rddata1     => s_rddata1,     -- out
        rddata2     => s_rddata2,     -- out
        wraddr      => s_wraddr,      -- in
        wrdata      => s_wrdata,      -- in
        regwrite    => s_regwrite     -- in
    );

    clock : process
    begin
        s_clk <= '1';
        wait for 10 ns;
        s_clk <= '0';
        wait for 10 ns;
    end process clock;
    
    test : process
    begin
        -- testcase 1:
        s_reset <= '0';
        wait for 30 ns;
        
        s_reset <= '1';
        wait until rising_edge(s_clk);
        
        s_stall <= '0';
        s_rdaddr1 <= "11100";
        s_rdaddr2 <= "00000";
        s_wraddr <= "11100";
        s_wrdata <= "10001001101010111100110111101111";
        s_regwrite <= '1';
        
        wait until rising_edge(s_clk);
        --report "Starting TC1: stall="&to_bstring(s_stall) & " rdaddr1="&to_bstring(s_rdaddr1)& " rdaddr2="&to_bstring(s_rdaddr2)& " wraddr="&to_bstring(s_wraddr) & " wrdata="&to_bstring(s_wrdata) & " regwrite="&to_bstring(s_regwrite);
        --report "Result   TC1: rddata1="&to_bstring(s_rddata1) & " rddata2="&to_bstring(s_rddata2);
        --report "Expected TC1: rddata1=10001001101010111100110111101111" & " rddata2=00000000000000000000000000000000";

        wait until rising_edge(s_clk);
        report "Result one clk: rddata1="&to_bstring(s_rddata1) & " rddata2="&to_bstring(s_rddata2);
        
        wait until rising_edge(s_clk);
        report "Result two clk: rddata1="&to_bstring(s_rddata1) & " rddata2="&to_bstring(s_rddata2);
        report "Expected TC1: rddata1=10001001101010111100110111101111" & " rddata2=00000000000000000000000000000000";

        wait;

    end process test;
end arch;
