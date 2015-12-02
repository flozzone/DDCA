library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

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

begin  -- rtl

end rtl;
