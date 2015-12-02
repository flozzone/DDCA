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

use work.serial_port_pkg.serial_port;
use work.serial_port_transmitter_pkg.serial_port_transmitter;
use work.serial_port_receiver_pkg.serial_port_receiver;
use work.sync_pkg.sync;
use work.ram_pkg.fifo_1c1r1w;

----------------------------------------------------------------------------------
--                               ARCHITECTURE                                   --
----------------------------------------------------------------------------------

architecture serial_port_struc of serial_port is

  signal data_out_sync : std_logic;
  signal receiver_data : std_logic_vector (7 downto 0);
  signal receiver_data_new : std_logic;
  signal transmitter_fifo_read: std_logic;
  signal transmitter_fifo_data : std_logic_vector (7 downto 0);
  signal transmitter_fifo_empty : std_logic;
  signal tx_free_p : std_logic;

  begin --serial_port_struc

    tx_free <= not(tx_free_p);

    -- receiver chain
    rx_sync : sync
      generic map (
        SYNC_STAGES => SYNC_STAGES,
        RESET_VALUE => '1'
      )
      port map (
        clk => clk,
        res_n => res_n,
        data_in => rx,
        data_out => data_out_sync
      );

    serial_port_receiver_fsm : serial_port_receiver
      generic map (
        CLK_DIVISOR => CLK_FREQ / BAUD_RATE
      )
      port map (
        clk => clk,
        res_n => res_n,
        rx => data_out_sync,
        data => receiver_data,
        data_new => receiver_data_new
      );

    receiver_fifo : fifo_1c1r1w
      generic map (
        MIN_DEPTH => RX_FIFO_DEPTH,
        DATA_WIDTH => 8
      )
      port map (
        clk => clk,
        res_n => res_n,
        wr2 => receiver_data_new,
        data_in2 => receiver_data,
        rd1 => rx_rd,
        data_out1 => rx_data,
        empty => rx_data_empty,
        full => rx_data_full
      );

     --transmitter chain
     transmitter_fifo : fifo_1c1r1w
      generic map (
        MIN_DEPTH => TX_FIFO_DEPTH,
        DATA_WIDTH => 8
      )
      port map (
        clk => clk,
        res_n => res_n,
        wr2 => tx_wr,
        data_in2 => tx_data,
        rd1 => transmitter_fifo_read,
        data_out1 => transmitter_fifo_data,
        empty => transmitter_fifo_empty,
        full => tx_free_p
      );

      serial_port_transmitter_fsm : serial_port_transmitter
        generic map (
          CLK_DIVISOR => CLK_FREQ / BAUD_RATE
        )
        port map (
          clk => clk,
          res_n => res_n,
          data => transmitter_fifo_data,
          empty => transmitter_fifo_empty,
          tx => tx,
          rd => transmitter_fifo_read
        );
end serial_port_struc;