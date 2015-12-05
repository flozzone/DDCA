library ieee;
use ieee.std_logic_1164.all;

use work.op_pack.all;
use work.core_pack.all;
use work.regfile;


entity regfile_tb is
end regfile_tb;

architecture arch of regfile_tb is
    constant CLK_PERIOD : time := 20 ns;
    signal clk		: std_logic;
    
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

    --clock : process
    --begin
    --    clk <= '1';
    --    wait for 10 ns;
    --    clk <= '0';
    --    wait for 10 ns;
    --end process clock;
    
    test : process
    begin
        -- testcase 1:
        --s_reset <= '0';
        --wait for 30 ns;
        
        s_reset <= '1';
        --wait until rising_edge(clk);
        
        wait for 1 ps;
        
        clk <= '1';

		assert r_rddata1 = a_rddata1 report testfile & ": rddata1 is not equal";
		assert r_rddata2 = a_rddata1 report testfile & ": rddata2 is not equal";

		wait for 1 ps;

    end process test;
end arch;
