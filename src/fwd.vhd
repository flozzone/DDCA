library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.core_pack.all;
use work.op_pack.all;

entity fwd is
    port (
        -- define input and output ports as needed
        decode_rs : in std_logic_vector(REG_BITS-1 downto 0);
        decode_rt : in std_logic_vector(REG_BITS-1 downto 0);
        alu_rd : in std_logic_vector(REG_BITS-1 downto 0);
        wb_rd : in std_logic_vector(REG_BITS-1 downto 0);
        forwardA : out fwd_type;
        forwardB : out fwd_type
);

end fwd;

architecture rtl of fwd is

    signal int_decode_rs : std_logic_vector(REG_BITS-1 downto 0);
    signal int_decode_rt : std_logic_vector(REG_BITS-1 downto 0);
    signal int_alu_rd : std_logic_vector(REG_BITS-1 downto 0);
    signal int_wb_rd : std_logic_vector(REG_BITS-1 downto 0);

begin  -- rtl
    fwd_proc : process(decode_rs, decode_rt, alu_rd, wb_rd)
    begin
        forwardA <= FWD_NONE;
        if decode_rs /= (REG_BITS-1 downto 0 => '0') then
            if decode_rs = alu_rd then
                forwardA <= FWD_ALU;
            elsif decode_rs = wb_rd then
                forwardA <= FWD_WB;
            end if;
        end if;
        forwardB <= FWD_NONE;
        if decode_rt /= (REG_BITS-1 downto 0 => '0') then
            if decode_rt = alu_rd then
                forwardB <= FWD_ALU;
            elsif decode_rt = wb_rd then
                forwardB <= FWD_WB;
            end if;
        end if;
    end process fwd_proc;
end rtl;
