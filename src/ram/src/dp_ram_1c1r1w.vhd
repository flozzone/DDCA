----------------------------------------------------------------------------------
-- Company:      TU Wien - ECS Group                                            --
-- Engineer:     Thomas Polzer                                                  --
--                                                                              --
-- Create Date:  21.09.2010                                                     --
-- Design Name:  DIDLEU                                                         --
-- Module Name:  dp_ram_1c1r1w                                                  --
-- Project Name: DIDELU                                                         --
-- Description:  Dual Port RAM - Entity                                         --
----------------------------------------------------------------------------------

----------------------------------------------------------------------------------
--                                LIBRARIES                                     --
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

----------------------------------------------------------------------------------
--                                 ENTITY                                       --
----------------------------------------------------------------------------------

entity dp_ram_1c1r1w is
  generic
  (
    -- address width
    ADDR_WIDTH : integer;
    -- data width
    DATA_WIDTH : integer
  );
  port
  (
    clk    : in  std_logic;

    raddr1 : in  std_logic_vector(ADDR_WIDTH - 1 downto 0);
    rdata1 : out std_logic_vector(DATA_WIDTH - 1 downto 0);
    rd1    : in  std_logic;

    waddr2 : in  std_logic_vector(ADDR_WIDTH - 1 downto 0);
    wdata2 : in  std_logic_vector(DATA_WIDTH - 1 downto 0);
    wr2    : in  std_logic
  );
end entity dp_ram_1c1r1w;

--- EOF ---