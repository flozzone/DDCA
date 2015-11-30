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

    cmd : process (op, N, Z)
    begin
        j <= '0';
        case op is
            when JMP_NOP =>
                j <= '0';
            when JMP_JMP =>
                j <= '1';
            when JMP_BEQ =>
                j <= Z;
            when JMP_BNE =>
                j <= not Z;
            when JMP_BLEZ =>
                j <= N or Z;
            when JMP_BGTZ =>
                j <= not (N or Z);
            when JMP_BLTZ =>
                j <= N;
            when JMP_BGEZ =>
                j <= not N;
            when others =>
                null;
        end case;
    end process cmd;

end rtl;
