----------------------------------------------------------------------------------
-- Company:      TU Wien                                                        --
-- Engineer:     Florin Hillebrand                                              --
--                                                                              --
-- Date:         20.10.2015                                                     --
-- Exercise:     exercise 1                                                     --
----------------------------------------------------------------------------------

----------------------------------------------------------------------------------
--                                LIBRARIES                                     --
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

----------------------------------------------------------------------------------
--                                 ENTITY                                       --
----------------------------------------------------------------------------------

-- serial port receiver
entity serial_port_receiver is
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
end entity serial_port_receiver;

--- EOF ---