----------------------------------------------------------------------------------
-- Company:      TU Wien - ECS Group                                            --
-- Engineer:     Thomas Polzer                                                  --
--                                                                              --
-- Create Date:  21.09.2010                                                     --
-- Design Name:  DIDLEU                                                         --
-- Module Name:  dp_ram_1c1r1w_beh                                              --
-- Project Name: DIDELU                                                         --
-- Description:  Dual Port RAM - Architecture                                   --
----------------------------------------------------------------------------------

----------------------------------------------------------------------------------
--                                LIBRARIES                                     --
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

----------------------------------------------------------------------------------
--                               ARCHITECTURE                                   --
----------------------------------------------------------------------------------

architecture beh of dp_ram_1c1r1w is
  subtype ram_entry is std_logic_vector(DATA_WIDTH - 1 downto 0);
  type ram_type is array(0 to (2 ** ADDR_WIDTH) - 1) of ram_entry;
  signal ram : ram_type :=
  (
    others => (others => '0')
  );
begin
 
  --------------------------------------------------------------------
  --                    PROCESS : SYNC                              --
  --------------------------------------------------------------------
 
  sync : process(clk)
  begin
    if rising_edge(clk) then
      if wr2 = '1' then
        ram(to_integer(unsigned(waddr2))) <= wdata2;
      end if;
      if rd1 = '1' then
        rdata1 <= ram(to_integer(unsigned(raddr1)));
      end if;      
    end if;
  end process sync;
end architecture beh;

--- EOF ---