----------------------------------------------------------------------------------
-- Company:      TU Wien - ECS Group                                            --
-- Engineer:     Thomas Polzer                                                  --
--                                                                              --
-- Create Date:  21.09.2010                                                     --
-- Design Name:  DIDELU                                                         --
-- Module Name:  sync_pkg                                                       --
-- Project Name: DIDELU                                                         --
-- Description:  Synchronizer - Package                                         --
----------------------------------------------------------------------------------

----------------------------------------------------------------------------------
--                                LIBRARIES                                     --
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

----------------------------------------------------------------------------------
--                                 PACKAGE                                      --
----------------------------------------------------------------------------------

package sync_pkg is

  --------------------------------------------------------------------
  --                          COMPONENT                             --
  --------------------------------------------------------------------
  
  -- serial connection of flip-flops to avoid latching of metastable inputs at
  -- the analog/digital interface
  component sync is
    generic
    (
      -- number of stages in the input synchronizer
      SYNC_STAGES : integer range 2 to integer'high;
      -- reset value of the output signal
      RESET_VALUE : std_logic
    );
    port
    (
      clk       : in std_logic;
      res_n     : in std_logic;
      
      data_in   : in std_logic;
      data_out  : out std_logic
    );
  end component sync;
end package sync_pkg;

--- EOF ---