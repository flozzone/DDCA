library ieee;
use ieee.std_logic_1164.all;

use work.op_pack.all;
use work.core_pack.all;
use work.regfile;


entity regfile_tb is
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

    test : process
    begin
        -- testcase 1:
    wait for 10 ns;
        s_reset <= '0';
        s_clk <= '0';
        wait for 10 ns;

        s_reset <= '1';
        s_stall <= '0';
        s_rdaddr1 <= "11100";
        s_rdaddr2 <= "00000";
        s_wraddr <= "11100";
        s_wrdata <= "10001001101010111100110111101111";
        s_regwrite <= '1';

        wait for 10 ns;
        s_clk <= '1';
        wait for 10 ns;

        assert s_rddata1 = "10001001101010111100110111101111" report testfile & "result rddata1";
        assert s_rddata2 = "00000000000000000000000000000000" report testfile & "result rddata2";

        wait for 30 ns;

        -- reset

        s_reset <= '0';
        s_clk <= '0';

        s_stall <= '0';
        s_rdaddr1 <= "00000";
        s_rdaddr2 <= "00000";
        s_wraddr <= "00000";
        s_wrdata <= "00000000000000000000000000000000";
        s_regwrite <= '0';
        wait for 10 ns;

        -- testcase 2:
        s_reset <= '1';
        s_stall <= '0';
        s_rdaddr1 <= "00000";
        s_rdaddr2 <= "11101";
        s_wraddr <= "11101";
        s_wrdata <= "01110110010101000011001000010000";
        s_regwrite <= '1';

        wait for 10 ns;
        s_clk <= '1';
        wait for 10 ns;

        assert s_rddata1 = "00000000000000000000000000000000" report testfile & "result rddata1";
        assert s_rddata2 = "01110110010101000011001000010000" report testfile & "result rddata2";

        wait;

    end process test;
end arch;
