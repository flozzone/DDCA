
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use work.txt_util.all;
use work.op_pack.all;
use work.core_pack.all;

use work.pipeline;


entity level1_tb is
end level1_tb;

architecture arch of level1_tb is
    constant CLK_PERIOD : time := 2 ps;
    signal clk            : std_logic;

    signal s_reset         : std_logic := '0';
    signal s_mem_in      : mem_in_type := ('0', (others => '0'));
    signal s_intr         : std_logic_vector(INTR_COUNT-1 downto 0) := (others => '0');
    signal r_mem_out     : mem_out_type := ((others => '0'),'0','0', (others => '0'),(others => '0'));
    signal a_mem_out     : mem_out_type := ((others => '0'),'0','0', (others => '0'),(others => '0'));

    signal int_s_reset     : std_logic;
    signal int_s_mem_in : mem_in_type := ('0', (others => '0'));
    signal int_s_intr     : std_logic_vector(INTR_COUNT-1 downto 0);
    signal int_r_mem_out : mem_out_type := ((others => '0'),'0','0', (others => '0'),(others => '0'));
    signal int_a_mem_out : mem_out_type := ((others => '0'),'0','0', (others => '0'),(others => '0'));


    signal int_clk_cnt     : integer := 0;
    signal testfile : string(8 downto 1);
    type TEST_TYPE is (NO_TEST, TEST);
    signal has_data     : TEST_TYPE;

begin

    pipeline_inst : entity pipeline
    port map (
        clk => clk,
        reset => s_reset,
        mem_in => s_mem_in,
        mem_out => r_mem_out,
        intr => s_intr
    );

    sync_proc : process
    begin
        clk <= '0';
        wait for CLK_PERIOD;
        clk <= '1';
        wait for CLK_PERIOD;
    end process sync_proc;

    --init_proc : process(
    --begin
    --    reset <= '0';
    --    wait for 2.5 ps;
    --    reset <= '1';
    --    wait until true;
    --end process init_proc;

    assert_proc : process(clk)
        variable rdline : line;
        file vector_file : text open read_mode is "../src/test.tc";
        variable bin : bit_vector(92 downto 0);
        variable vec : std_logic_vector(92 downto 0);
        variable clk_cnt : integer := 0;
    begin
        if rising_edge(clk) then
            clk_cnt := clk_cnt + 1;
            int_clk_cnt <= clk_cnt;
            if not endfile(vector_file) then
                --wait for 2 ps;
                readline(vector_file, rdline);
                read(rdline, bin);
                vec := to_stdlogicvector(bin);

                print(output, "############ LINE: " & integer'IMAGE(clk_cnt) & " ##############");

                s_reset <= vec(92);
                s_mem_in.busy <= vec(91);
                s_mem_in.rddata <= vec(90 downto 59);
                a_mem_out.address <= vec(58 downto 38);
                a_mem_out.rd <= vec(37);
                a_mem_out.wr <= vec(36);
                a_mem_out.byteena <= vec(35 downto 32);
                a_mem_out.wrdata <= vec(31 downto 0);

                has_data <= TEST;

            else
                if has_data = TEST then
                    has_data <= NO_TEST;
                    print(output, "######### EOF of testfile ########");
                end if;
            end if;
        end if;
    end process assert_proc;

    test_proc : process
    begin
            wait for 3 ps;
            if has_data = NO_TEST then
                assert r_mem_out.address = a_mem_out.address report "clk "&str(int_clk_cnt)&": wrong mem_out.address (" & str(r_mem_out.address) & ") expected "& str(a_mem_out.address);
                assert r_mem_out.rd = a_mem_out.rd report "clk "&str(int_clk_cnt)&": wrong mem_out.rd (" & chr(r_mem_out.rd) & ") expected "&chr(a_mem_out.rd);
                assert r_mem_out.wr = a_mem_out.wr report "clk "&str(int_clk_cnt)&": wrong mem_out.wr (" & chr(r_mem_out.wr) & ") expected "&chr(a_mem_out.wr);
                assert r_mem_out.byteena = a_mem_out.byteena report "clk "&str(int_clk_cnt)&": wrong mem_out.byteena ("&str(r_mem_out.byteena)&") expected "&str(a_mem_out.byteena);
                assert r_mem_out.wrdata = a_mem_out.wrdata report "clk "&str(int_clk_cnt)&": wrong mem_out.wrdata (" & str(r_mem_out.wrdata) & ") expected "&str(a_mem_out.wrdata);
            else
                --assert false report "EOF";
            end if;
            wait for 1 ps;
    end process test_proc;
end arch;
