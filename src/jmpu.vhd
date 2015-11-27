library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.core_pack.all;
use work.op_pack.all;

entity jmpu is
	port (
		op   : in  jmp_op_type;
		N, Z : in  std_logic;
		J    : out std_logic);
end jmpu;

architecture rtl of jmpu is

begin  -- rtl

end rtl;
