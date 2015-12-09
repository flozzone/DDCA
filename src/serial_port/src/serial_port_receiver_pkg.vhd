----------------------------------------------------------------------------------
-- Company:      TU Wien - ECS Group                                            --
-- Engineer:     Florian Huemer                                                  --
--                                                                              --
-- Create Date:  2011                                                     --
-- Design Name:                                                           --
-- Module Name:                                                         --
-- Project Name:                                                          --
-- Description:          --
----------------------------------------------------------------------------------


----------------------------------------------------------------------------------
--                                LIBRARIES                                     --
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

----------------------------------------------------------------------------------
--                                 PACKAGE                                      --
----------------------------------------------------------------------------------

package serial_port_receiver_pkg is
    -- serial port receiver
    component serial_port_receiver is
      generic
      (
        CLK_DIVISOR : integer
      );
      port
      (
        clk, res_n         : in  std_logic;
        rx : in std_logic;

        data : out std_logic_vector(7 downto 0);
        data_new : out std_logic

      );
    end component;
end package;

--- EOF ---