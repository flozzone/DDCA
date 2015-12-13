library ieee;
use ieee.std_logic_1164.all;

use work.op_pack.all;
use work.core_pack.all;
use work.memu;


entity memu_tb is
end memu_tb;

architecture arch of memu_tb is
    constant CLK_PERIOD : time := 20 ns;
    signal clk        : std_logic;

    signal s_op   : mem_op_type;
    signal s_A    : std_logic_vector(ADDR_WIDTH-1 downto 0);
    signal s_W    : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal s_D    : std_logic_vector(DATA_WIDTH-1 downto 0);

    signal r_M    : mem_out_type;
    signal r_R    : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal r_XL   : std_logic;
    signal r_XS   : std_logic;

    signal a_M    : mem_out_type;
    signal a_R    : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal a_XL   : std_logic;
    signal a_XS   : std_logic;

    signal testfile : string(8 downto 1);

    function x_match(
        result : std_logic_vector(DATA_WIDTH-1 downto 0);
        expected : std_logic_vector(DATA_WIDTH-1 downto 0))
            return boolean is
             variable ret : std_logic_vector(DATA_WIDTH-1 downto 0) := (others=>'0');
    begin
        assert result'LENGTH = expected'LENGTH;

        for i in result'LENGTH-1 downto 0 loop
            if expected(i) = 'X' then
                null;
            elsif expected(i) /= result(i) then
                return false;
            end if;
        end loop;
        return true;
    end x_match;

begin
    memu_inst : entity memu
    port map (
        op => s_op,
        A => s_A,
        W => s_W,
        D => s_D,
        M => r_M,
        R => r_R,
        XL => r_XL,
        XS => r_XS
    );

    test : process
    begin
        wait for 2 ps;

        assert r_M.address = a_M.address report testfile & ": M.address is not equal";
        assert r_M.rd = a_M.rd report testfile & ": M.rd is not equal";
        assert r_M.wr = a_M.wr report testfile & ": M.wr is not equal";
        assert r_M.byteena = a_M.byteena report testfile & ": M.byteena is not equal";
        assert x_match(r_M.wrdata, a_M.wrdata) report testfile & ": M.wrdata is not equal";
        assert r_R = a_R report testfile & ": R is not equal";
        assert r_XL = a_XL report testfile & ": XL ist not equal";
        assert r_XS = a_XS report testfile & ": XS is not equal";

        wait for 2 ps;

    end process test;
end arch;