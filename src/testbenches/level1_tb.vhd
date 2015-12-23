
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use work.txt_util.all;
use work.op_pack.all;
use work.core_pack.all;
use work.mimi;
use work.pipeline;
use work.ocram_altera;


entity level1_tb is
end level1_tb;

architecture arch of level1_tb is
    constant CLK_PERIOD : time := 20 ns;
    signal clk            : std_logic;

    signal s_test_clk_cnt : integer range 0 to 300;

    signal s_reset         : std_logic := '0';
    signal s_enable_ocram : std_logic;
    signal s_mem_in      : mem_in_type := ('0', (others => '0'));
    signal mem_in      : mem_in_type;
    signal s_intr         : std_logic_vector(INTR_COUNT-1 downto 0) := (others => '0');
    signal r_mem_out     : mem_out_type := ((others => '0'),'0','0', (others => '0'),(others => '0'));
    signal a_mem_out     : mem_out_type := ((others => '0'),'0','0', (others => '0'),(others => '0'));

    signal ocram_rddata : std_logic_vector(DATA_WIDTH-1 downto  0);

    signal clk_cnt     : integer := -1;
    signal testfile : string(8 downto 1);
    signal break_on_error : boolean := false;

    procedure check(
        test_nr : in integer;
        signal_name : in string;
        result : in std_logic_vector;
        expected : in std_logic_vector;
        success : inout boolean;
        boe : in boolean) is -- break on error
    begin
        if not std_match(result, expected) then
            if boe = true then
                assert std_match(result, expected) report str(test_nr) & ": " & signal_name & " result: " & hstr(result) & " expected: " & hstr(expected) severity FAILURE;
            else
                assert std_match(result, expected) report str(test_nr) & ": " & signal_name & " result: " & hstr(result) & " expected: " & hstr(expected);
            end if;
            success := false;
        end if;
    end check;

    procedure check(
        test_nr : in integer;
        signal_name : in string;
        result : in std_logic;
        expected : in std_logic;
        success : inout boolean;
        boe : in boolean) is -- break on error
    begin
        if not std_match(result, expected) then
            if boe = true then
                assert std_match(result, expected) report str(test_nr) & ": " & signal_name & " result: " & chr(result) & " expected: " & chr(expected) severity FAILURE;
            else
                assert std_match(result, expected) report str(test_nr) & ": " & signal_name & " result: " & chr(result) & " expected: " & chr(expected);
            end if;
            success := false;
        end if;
    end check;

begin

    pipeline_inst : entity pipeline
    port map (
        clk => clk,
        reset => s_reset,
        mem_in => mem_in,
        mem_out => r_mem_out,
        intr => s_intr
    );
    
    memory_inst : entity ocram_altera
    port map (
        clock => clk,
        address => r_mem_out.address(11 downto 2),
        byteena => r_mem_out.byteena,
        data => r_mem_out.wrdata,
        wren => r_mem_out.wr,
        q => ocram_rddata
    );

    sync_proc : process
    begin
        clk <= '0';
        wait for CLK_PERIOD/2;
        clk <= '1';
        clk_cnt <= clk_cnt + 1;
        wait for CLK_PERIOD/2;
    end process sync_proc;

    mem_proc : process(r_mem_out, ocram_rddata, s_mem_in, clk)
    begin
        if s_enable_ocram = '1' then
            mem_in.busy <= r_mem_out.rd;
            mem_in.rddata <= ocram_rddata;
        else
            mem_in.rddata <= s_mem_in.rddata;
            mem_in.busy <= s_mem_in.busy;
        end if;
    end process mem_proc;

    test_proc : process
        variable rdline : line;
        file fd : text open read_mode is "../src/test.tc";
        variable bin_line : string(94 downto 1);
        variable vec : std_logic_vector(93 downto 0);
        variable success : boolean;
        variable fail_count : integer := 0;
        variable total_count : integer := 0;
    begin
        if not endfile(fd) then
            wait until rising_edge(clk);

            --print(output, "############ LINE: " & str(clk_cnt) & " ##############");

            readline(fd, rdline);
            read(rdline, bin_line);
            vec := to_std_logic_vector(bin_line);

            -- TEST SIGNALS
            s_enable_ocram <= vec(93);
            s_reset <= vec(92);
            s_mem_in.rddata <= vec(91 downto 60);
            s_mem_in.busy <= vec(59);
            a_mem_out.address <= vec(58 downto 38);
            a_mem_out.rd <= vec(37);
            a_mem_out.wr <= vec(36);
            a_mem_out.byteena <= vec(35 downto 32);
            a_mem_out.wrdata <= vec(31 downto 0);
            -- END TEST SIGNALS

            wait until falling_edge(clk);

            success := true;
            check(clk_cnt, "mem_out.address", r_mem_out.address, a_mem_out.address, success, break_on_error);
            check(clk_cnt, "mem_out.rd", r_mem_out.rd, a_mem_out.rd, success, break_on_error);
            check(clk_cnt, "mem_out.wr", r_mem_out.wr, a_mem_out.wr, success, break_on_error);
            check(clk_cnt, "mem_out.byteena", r_mem_out.byteena, a_mem_out.byteena, success, break_on_error);
            check(clk_cnt, "mem_out.wrdata", r_mem_out.wrdata, a_mem_out.wrdata, success, break_on_error);
            total_count := total_count + 1;
            if success = false then
                fail_count := fail_count + 1;
            end if;
        else
            print(output, "######### EOF of testfile ########");
            print(output, str(fail_count) & "/" & str(total_count) & " tests failed.");

            assert False report "EOF" severity FAILURE;
        end if;
   end process test_proc;
end arch;
