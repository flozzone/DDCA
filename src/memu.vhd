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

function word_game(
		data : std_logic_vector(DATA_WIDTH-1 downto 0);
		x : PATTERN)
			return std_logic_vector is
	variable ret : std_logic_vector(DATA_WIDTH-1 downto 0) := (others=>'0');
  variable tmp_word : std_logic_vector(BYTE_WIDTH-1 downto 0);
  variable dbg_current : character;
begin

	assert tmp_word'LENGTH = 8 report "Wrong tmp_word length";

	ret := (others => '0');

	for i in 3 downto 0 loop
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
			when others =>
				assert false report "Unexpected pattern";
		end case;
		ret := ret or ((3-i)*BYTE_WIDTH-1 downto 0 => '0') & tmp_word & (i*BYTE_WIDTH-1 downto 0 => '0');
	end loop;
	return ret;
end word_game;

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

		M.address <= A;
		case op.memtype is
			when MEM_B | MEM_BU =>
				case A(1 downto 0) is
					when "00" =>
						M.byteena <= "1000";
						M.wrdata <= word_game(W, "AXXX");
					when "01" =>
						M.byteena <= "0100";
						M.wrdata <= word_game(W, "XAXX");
					when "10" =>
						M.byteena <= "0010";
						M.wrdata <= word_game(W, "XXAX");
					when "11" =>
						M.byteena <= "0001";
						M.wrdata <= word_game(W, "XXXA");
					when others =>
						null;
				end case;

			when MEM_H | MEM_HU =>
				case A(1 downto 0) is
					when "00" =>
						M.byteena <= "1100";
						M.wrdata <= word_game(W, "BAXX");
					when "01" =>
						M.byteena <= "1100";
						M.wrdata <= word_game(W, "BAXX");
					when "10" =>
						M.byteena <= "0011";
						M.wrdata <= word_game(W, "XXBA");
					when "11" =>
						M.byteena <= "0011";
						M.wrdata <= word_game(W, "XXBA");
					when others =>
						null;
				end case;
			when MEM_W =>
				case A(1 downto 0) is
					when "00" =>
						M.byteena <= "1111";
						M.wrdata <= word_game(W, "DCBA");
					when "01" =>
						M.byteena <= "1111";
						M.wrdata <= word_game(W, "DCBA");
					when "10" =>
						M.byteena <= "1111";
						M.wrdata <= word_game(W, "DCBA");
					when "11" =>
						M.byteena <= "1111";
						M.wrdata <= word_game(W, "DCBA");
					when others =>
						null;
				end case;
		end case;

		-- Computation of exceptions
			case op.memtype is
				when MEM_H | MEM_HU=>
					case A(1 downto 0) is
						when "01" => set_exception(op.memread, op.memwrite, tmp_XL, tmp_XS);
						when "11" => set_exception(op.memread, op.memwrite, tmp_XL, tmp_XS);
						when others => set_exception('0', '0', tmp_XL, tmp_XS);
					end case;
				when MEM_W =>
					case A(1 downto 0) is
						when "01" => set_exception(op.memread, op.memwrite, tmp_XL, tmp_XS);
						when "10" => set_exception(op.memread, op.memwrite, tmp_XL, tmp_XS);
						when "11" => set_exception('0', '0', tmp_XL, tmp_XS);
						when others => XL <= '0';
					end case;
				when others =>
					if (A(1 downto 0) = "00") and (A(ADDR_WIDTH-1 downto 2) = (ADDR_WIDTH-1 downto 2 => '0')) then
						tmp_XL := '1';
						tmp_XS := '1';
					else
						tmp_XL := '0';
						tmp_XS := '0';	
					end if;
			end case;
			XL <= tmp_XL;
			XS <= tmp_XS;
	end process memu_unit;
end rtl;
