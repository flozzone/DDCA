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
begin
	for i in 3 to 0 loop
		case x(i) is
			when 'A'=>
				ret := ret or (((3-i)*BYTES_PER_WORD-1 downto 0 => '0') & data(4*BYTES_PER_WORD-1 downto 3*BYTES_PER_WORD) & (i*BYTES_PER_WORD-1 downto 0 => '0'));
			when 'B'=>
				ret := ret or (((3-i)*BYTES_PER_WORD-1 downto 0 => '0') & data(3*BYTES_PER_WORD-1 downto 2*BYTES_PER_WORD) & (i*BYTES_PER_WORD-1 downto 0 => '0'));
			when 'C'=>
				ret := ret or (((3-i)*BYTES_PER_WORD-1 downto 0 => '0') & data(2*BYTES_PER_WORD-1 downto 1*BYTES_PER_WORD) & (i*BYTES_PER_WORD-1 downto 0 => '0'));
			when 'D'=>
				ret := ret or (((3-i)*BYTES_PER_WORD-1 downto 0 => '0') & data(1*BYTES_PER_WORD-1 downto 0*BYTES_PER_WORD) & (i*BYTES_PER_WORD-1 downto 0 => '0'));
			when 'X'=>
				null;
			when '0'=>
				ret := ret or (((3-i)*BYTES_PER_WORD-1 downto 0 => '0') & (1*BYTES_PER_WORD-1 downto 0*BYTES_PER_WORD => '0') & (i*BYTES_PER_WORD-1 downto 0 => '0'));
			when others =>
				assert false;
		end case;
	end loop;
	return ret;
end word_game;


begin  -- rtl
	memu_unit : process (op, A, W, D)
	begin
		M.rd <= op.memread;
		M.wr <= op.memwrite;
		M.address <= A;
		if (op.memtype = MEM_B) or (op.memtype = MEM_BU) then
			case A(1 downto 0) is
				when "00" =>
					M.byteena <= "1000";
					M.wrdata <= word_game(D, "AXXX");
				when "01" =>
					M.byteena <= "0100";
					M.wrdata <= word_game(D, "XAXX");
				when "10" =>
					M.byteena <= "0010";
					M.wrdata <= word_game(D, "XXAX");
				when "11" =>
					M.byteena <= "0001";
					M.wrdata <= word_game(D, "XXXA");
				when others =>
					assert false;
			end case;
		end if;
		if (op.memtype = MEM_H) or (op.memtype = MEM_HU) then
			case A(1 downto 0) is
				when "00" =>
					M.byteena <= "1100";
					M.wrdata <= word_game(D, "BAXX");
				when "01" =>
					M.byteena <= "1100";
					M.wrdata <= word_game(D, "BAXX");
				when "10" =>
					M.byteena <= "0011";
					M.wrdata <= word_game(D, "XXBA");
				when "11" =>
					M.byteena <= "0011";
					M.wrdata <= word_game(D, "XXBA");
				when others =>
					assert false;
			end case;
		end if;
		if op.memtype = MEM_W then
			case A(1 downto 0) is
				when "00" =>
					M.byteena <= "1111";
					M.wrdata <= word_game(D, "DCBA");
				when "01" =>
					M.byteena <= "1111";
					M.wrdata <= word_game(D, "DCBA");
				when "10" =>
					M.byteena <= "1111";
					M.wrdata <= word_game(D, "DCBA");
				when "11" =>
					M.byteena <= "1111";
					M.wrdata <= word_game(D, "DCBA");
				when others =>
					assert false;
			end case;
		end if;
	end process memu_unit;
end rtl;
