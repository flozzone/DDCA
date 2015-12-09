----------------------------------------------------------------------------------
-- Company:      TU Wien - ECS Group                                            --
-- Engineer:     Thomas Polzer                                                  --
--                                                                              --
-- Create Date:  21.09.2010                                                     --
-- Design Name:  DIDLEU                                                         --
-- Module Name:  ram_pkg                                                        --
-- Project Name: DIDELU                                                         --
-- Description:  RAM Package                                                    --
----------------------------------------------------------------------------------

----------------------------------------------------------------------------------
--                                LIBRARIES                                     --
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use work.math_pkg.all;

----------------------------------------------------------------------------------
--                                 PACKAGE                                      --
----------------------------------------------------------------------------------

package ram_pkg is

  --------------------------------------------------------------------
  --                          COMPONENT                             --
  --------------------------------------------------------------------

  component dp_ram_1c1r1w is
    generic
    (
      ADDR_WIDTH : integer;
      DATA_WIDTH : integer
    );
    port
    (
      clk    : in std_logic;

      raddr1 : in std_logic_vector(ADDR_WIDTH - 1 downto 0);
      rdata1 : out std_logic_vector(DATA_WIDTH - 1 downto 0);
      rd1    : in std_logic;

      waddr2 : in std_logic_vector(ADDR_WIDTH - 1 downto 0);
      wdata2 : in std_logic_vector(DATA_WIDTH - 1 downto 0);
      wr2    : in std_logic
    );
  end component dp_ram_1c1r1w;

  component fifo_1c1r1w is
    generic
    (
      MIN_DEPTH  : integer;
      DATA_WIDTH : integer
    );
    port
    (
      clk       : in std_logic;
      res_n     : in std_logic;

      data_out1 : out std_logic_vector(DATA_WIDTH - 1 downto 0);
      rd1       : in std_logic;

      data_in2  : in std_logic_vector(DATA_WIDTH - 1 downto 0);
      wr2       : in std_logic;

      empty    : out std_logic;
      full     : out std_logic
    );
  end component fifo_1c1r1w;

end ram_pkg;

--- EOF ---