library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

use work.core_pack.all;
use work.op_pack.all;

entity memu is
    port (
        -- Access type
        op   : in  mem_op_type;
        -- Address
        A    : in  std_logic_vector(ADDR_WIDTH-1 downto 0);
        -- Write data
        W    : in  std_logic_vector(DATA_WIDTH-1 downto 0);
        -- Data from memory
        D    : in  std_logic_vector(DATA_WIDTH-1 downto 0);
        -- Interface to memory
        M    : out mem_out_type;
        -- Result of memory load
        R    : out std_logic_vector(DATA_WIDTH-1 downto 0);
        -- Load exception
        XL   : out std_logic;
        -- Store exception
        XS   : out std_logic);
end memu;

architecture rtl of memu is

type PATTERN is array (3 downto 0) of character;
constant ZERO : std_logic_vector (ADDR_WIDTH-3 downto 0) := (others => '0');

function byte_swap(
        data : std_logic_vector(DATA_WIDTH-1 downto 0);
        x : PATTERN)
            return std_logic_vector is
    variable ret : std_logic_vector(DATA_WIDTH-1 downto 0) := (others=>'0');
  variable tmp_word : std_logic_vector(BYTE_WIDTH-1 downto 0);
  variable dbg_current : character;
begin

    assert tmp_word'LENGTH = 8 report "Wrong tmp_word length";

    ret := (others => '0');

    for i in 0 to 3 loop
        dbg_current := x(i);
        case x(i) is
            when 'A'=>
                tmp_word := data(1*BYTE_WIDTH-1 downto 0*BYTE_WIDTH);
            when 'B'=>
                tmp_word := data(2*BYTE_WIDTH-1 downto 1*BYTE_WIDTH);
            when 'C'=>
                tmp_word := data(3*BYTE_WIDTH-1 downto 2*BYTE_WIDTH);
            when 'D'=>
                tmp_word := data(4*BYTE_WIDTH-1 downto 3*BYTE_WIDTH);
            when 'X'=>
                tmp_word := (others => 'X');
            when '0'=>
                tmp_word := (others => '0');
            when 'S'=>
                if i /= 0 then
                    if ret(i*BYTE_WIDTH-1) = '1' then
                        tmp_word := (others => '1');
                    else
                        tmp_word := (others => '0');
                    end if;
                end if;
            when others =>
                assert false report "Unexpected pattern";
        end case;
        ret := ret or ((3-i)*BYTE_WIDTH-1 downto 0 => '0') & tmp_word & (i*BYTE_WIDTH-1 downto 0 => '0');
    end loop;
    return ret;
end byte_swap;

procedure set_exception(memread : in std_logic;
                                                         memwrite : in std_logic;
                                                         XL : out std_logic;
                                                         XS : out std_logic) is
use ieee.std_logic_1164.all;
begin
    XL := '0';
    XS := '0';
    if memread = '1' then
        XL := '1';
    end if;
    if memwrite = '1' then
        XS := '1';
    end if;
end procedure set_exception;


begin  -- rtl
    memu_unit : process (op, A, W, D)

    variable tmp_XL, tmp_XS : std_logic;

    begin
        M.rd <= '0';
        M.wr <= '0';
        if op.memread = '1' then
            M.rd <= '1';
        end if;
        if op.memwrite = '1' then
            M.wr <= '1';
        end if;

        tmp_XL := '0';
        tmp_XS := '0';

        -- address must be written with A always (nightly tests)
        M.address <= A;

        -- compute byteena and wrdata
        case op.memtype is
            when MEM_B | MEM_BU =>
                case A(1 downto 0) is
                    when "00" =>
                        M.byteena <= "1000";
                        M.wrdata <= byte_swap(W, "AXXX");
                    when "01" =>
                        M.byteena <= "0100";
                        M.wrdata <= byte_swap(W, "XAXX");
                    when "10" =>
                        M.byteena <= "0010";
                        M.wrdata <= byte_swap(W, "XXAX");
                    when "11" =>
                        M.byteena <= "0001";
                        M.wrdata <= byte_swap(W, "XXXA");
                    when others =>
                        null;
                end case;

            when MEM_HU | MEM_H =>
                case A(1 downto 0) is
                    when "00" =>
                        M.byteena <= "1100";
                        M.wrdata <= byte_swap(W, "BAXX");
                    when "01" =>
                        M.byteena <= "1100";
                        M.wrdata <= byte_swap(W, "BAXX");
                    when "10" =>
                        M.byteena <= "0011";
                        M.wrdata <= byte_swap(W, "XXBA");
                    when "11" =>
                        M.byteena <= "0011";
                        M.wrdata <= byte_swap(W, "XXBA");
                    when others =>
                        null;
                end case;
            when MEM_W =>
                case A(1 downto 0) is
                    when "00" =>
                        M.byteena <= "1111";
                        M.wrdata <= byte_swap(W, "DCBA");
                    when "01" =>
                        M.byteena <= "1111";
                        M.wrdata <= byte_swap(W, "DCBA");
                    when "10" =>
                        M.byteena <= "1111";
                        M.wrdata <= byte_swap(W, "DCBA");
                    when "11" =>
                        M.byteena <= "1111";
                        M.wrdata <= byte_swap(W, "DCBA");
                    when others =>
                        null;
                end case;
        end case;

        -- Computation of exceptions
            case op.memtype is
                when MEM_HU | MEM_H=>
                    case A(1 downto 0) is
                        when "01" => set_exception(op.memread, op.memwrite, tmp_XL, tmp_XS);
                        when "11" => set_exception(op.memread, op.memwrite, tmp_XL, tmp_XS);
                        when "00" =>
                            if std_match(A, ZERO & "--") then
                                set_exception(op.memread, op.memwrite, tmp_XL, tmp_XS);
                            end if;
                        when others => set_exception('0', '0', tmp_XL, tmp_XS);
                    end case;
                when MEM_W =>
                    case A(1 downto 0) is
                        when "01" => set_exception(op.memread, op.memwrite, tmp_XL, tmp_XS);
                        when "10" => set_exception(op.memread, op.memwrite, tmp_XL, tmp_XS);
                        when "11" => set_exception(op.memread, op.memwrite, tmp_XL, tmp_XS);
                        when "00" =>
                            if std_match(A, ZERO & "--") then
                                set_exception(op.memread, op.memwrite, tmp_XL, tmp_XS);
                            end if;
                        when others => set_exception('0', '0', tmp_XL, tmp_XS);
                    end case;
                when others =>
                    null;
            end case;
            XL <= tmp_XL;
            XS <= tmp_XS;

            -- don't process memory access when exception occured
            if (tmp_XL = '1' or tmp_XS = '1') then
                M.rd <= '0';
                M.wr <= '0';
            end if;

            -- compute R
            case op.memtype is
                when MEM_B =>
                    case A(1 downto 0) is
                        when "00" => R <= byte_swap(D, "SSSD");
                        when "01" => R <= byte_swap(D, "SSSC");
                        when "10" => R <= byte_swap(D, "SSSB");
                        when "11" => R <= byte_swap(D, "SSSA");
                        when others => null;
                    end case;
                when MEM_BU =>
                    case A(1 downto 0) is
                        when "00" => R <= byte_swap(D, "000D");
                        when "01" => R <= byte_swap(D, "000C");
                        when "10" => R <= byte_swap(D, "000B");
                        when "11" => R <= byte_swap(D, "000A");
                        when others => null;
                    end case;
                when MEM_H =>
                    case A(1 downto 0) is
                        when "00" => R <= byte_swap(D, "SSDC");
                        when "01" => R <= byte_swap(D, "SSDC");
                        when "10" => R <= byte_swap(D, "SSBA");
                        when "11" => R <= byte_swap(D, "SSBA");
                        when others => null;
                    end case;
                when MEM_HU =>
                    case A(1 downto 0) is
                        when "00" => R <= byte_swap(D, "00DC");
                        when "01" => R <= byte_swap(D, "00DC");
                        when "10" => R <= byte_swap(D, "00BA");
                        when "11" => R <= byte_swap(D, "00BA");
                        when others => null;
                    end case;
                when MEM_W =>
                    case A(1 downto 0) is
                        when "00" => R <= byte_swap(D, "DCBA");
                        when "01" => R <= byte_swap(D, "DCBA");
                        when "10" => R <= byte_swap(D, "DCBA");
                        when "11" => R <= byte_swap(D, "DCBA");
                        when others => null;
                    end case;
                when others =>
                    assert False report "Case not covered";
            end case;
    end process memu_unit;
end rtl;
