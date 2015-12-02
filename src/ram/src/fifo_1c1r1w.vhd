----------------------------------------------------------------------------------
-- Company:      TU Wien - ECS Group                                            --
-- Engineer:     Thomas Polzer                                                  --
--                                                                              --
-- Create Date:  21.09.2010                                                     --
-- Design Name:  DIDLEU                                                         --
-- Module Name:  fifo_1c1r1w                                                    --
-- Project Name: DIDELU                                                         --
-- Description:  FIFO - Entity                                                  --
----------------------------------------------------------------------------------

----------------------------------------------------------------------------------
--                                LIBRARIES                                     --
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

----------------------------------------------------------------------------------
--                                 ENTITY                                       --
----------------------------------------------------------------------------------

entity fifo_1c1r1w is
  generic
  (
    MIN_DEPTH  : integer;
    DATA_WIDTH : integer
  );
  port
  (
    clk       : in  std_logic;
    res_n     : in  std_logic;
    
    data_out1 : out std_logic_vector(DATA_WIDTH - 1 downto 0);
    rd1       : in  std_logic;
    
    data_in2  : in  std_logic_vector(DATA_WIDTH - 1 downto 0);
    wr2       : in  std_logic;

    empty     : out std_logic;
    full      : out std_logic
  );
end entity fifo_1c1r1w;

--- EOF ---