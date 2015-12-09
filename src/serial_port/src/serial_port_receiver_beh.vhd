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
--                               ARCHITECTURE                                   --
----------------------------------------------------------------------------------
architecture beh of serial_port_receiver is
  type RECEIVER_STATE_TYPE is (RECEIVER_STATE_IDLE,
                                  RECEIVER_STATE_WAIT_START_BIT,
                                  RECEIVER_STATE_GOTO_MIDDLE_OF_START_BIT,
                                  RECEIVER_STATE_MIDDLE_OF_START_BIT,
                                  RECEIVER_STATE_WAIT_DATA_BIT,
                                  RECEIVER_STATE_MIDDLE_OF_DATA_BIT,
                                  RECEIVER_STATE_WAIT_STOP_BIT,
                                  RECEIVER_STATE_MIDDLE_OF_STOP_BIT);
  signal receiver_state, receiver_state_next : RECEIVER_STATE_TYPE;

  signal bit_cnt, bit_cnt_next : integer range 0 to 8;
  signal clk_cnt, clk_cnt_next : integer range 0 to CLK_DIVISOR - 1;
  signal data_int, data_int_next : std_logic_vector(7 downto 0);
begin

  --------------------------------------------------------------------
  --                    PROCESS : NEXT_STATE                        --
  --------------------------------------------------------------------

  receiver_next_state : process(receiver_state, clk_cnt, bit_cnt, clk, rx)
  begin
    receiver_state_next <= receiver_state;

    case receiver_state is
      when RECEIVER_STATE_IDLE =>
        if rx = '1' then
          receiver_state_next <= RECEIVER_STATE_WAIT_START_BIT;
        end if;
      when RECEIVER_STATE_WAIT_START_BIT =>
        if rx = '0' then
          receiver_state_next <= RECEIVER_STATE_GOTO_MIDDLE_OF_START_BIT;
        end if;
      when RECEIVER_STATE_GOTO_MIDDLE_OF_START_BIT =>
        if clk_cnt = (CLK_DIVISOR/2 - 2) then
          receiver_state_next <= RECEIVER_STATE_MIDDLE_OF_START_BIT;
        end if;
      when RECEIVER_STATE_MIDDLE_OF_START_BIT =>
          receiver_state_next <= RECEIVER_STATE_WAIT_DATA_BIT;
      when RECEIVER_STATE_WAIT_DATA_BIT =>
        if clk_cnt = (CLK_DIVISOR - 2) then
          receiver_state_next <= RECEIVER_STATE_MIDDLE_OF_DATA_BIT;
        end if;
      when RECEIVER_STATE_MIDDLE_OF_DATA_BIT =>
        if bit_cnt = 7 then
          receiver_state_next <= RECEIVER_STATE_WAIT_STOP_BIT;
        elsif  bit_cnt < 7 then
          receiver_state_next <= RECEIVER_STATE_WAIT_DATA_BIT;
        end if;
      when RECEIVER_STATE_WAIT_STOP_BIT =>
        if clk_cnt = (CLK_DIVISOR - 2) then
          receiver_state_next <= RECEIVER_STATE_MIDDLE_OF_STOP_BIT;
        end if;
      when RECEIVER_STATE_MIDDLE_OF_STOP_BIT =>
        if rx = '0' then
          receiver_state_next <= RECEIVER_STATE_IDLE;
        elsif rx = '1' then
          receiver_state_next <= RECEIVER_STATE_WAIT_START_BIT;
        end if;
    end case;

  end process receiver_next_state;

  --------------------------------------------------------------------
  --                    PROCESS : OUTPUT                            --
  --------------------------------------------------------------------

  receiver_output : process(receiver_state, clk_cnt, bit_cnt, data_int, rx)
  begin
    data <= "00000000";
    data_new <= '0';
    data_int_next <= data_int;
    clk_cnt_next <= clk_cnt;
    bit_cnt_next <= bit_cnt;

    case receiver_state is
      when RECEIVER_STATE_IDLE =>
        null;
      when RECEIVER_STATE_WAIT_START_BIT =>
        data_int_next <= "00000000";
        bit_cnt_next <= 0;
        clk_cnt_next <= 0;
      when RECEIVER_STATE_GOTO_MIDDLE_OF_START_BIT =>
        clk_cnt_next <= clk_cnt + 1;
      when RECEIVER_STATE_MIDDLE_OF_START_BIT =>
        clk_cnt_next <= 0;
      when RECEIVER_STATE_WAIT_DATA_BIT =>
        clk_cnt_next <= clk_cnt + 1;
      when RECEIVER_STATE_MIDDLE_OF_DATA_BIT =>
        clk_cnt_next <= 0;
        bit_cnt_next <= bit_cnt + 1;
        data_int_next(bit_cnt) <= rx;
      when RECEIVER_STATE_WAIT_STOP_BIT =>
        clk_cnt_next <= clk_cnt + 1;
      when RECEIVER_STATE_MIDDLE_OF_STOP_BIT =>
        data_new <= '1';
        data <= data_int;
    end case;
  end process receiver_output;

  --------------------------------------------------------------------
  --                    PROCESS : SYNC                              --
  --------------------------------------------------------------------

  sync : process(clk, res_n)
  begin
    if res_n = '0' then
      receiver_state <= RECEIVER_STATE_IDLE;
      clk_cnt <= 0;
      bit_cnt <= 0;
    elsif rising_edge(clk) then
      receiver_state <= receiver_state_next;
      clk_cnt <= clk_cnt_next;
      bit_cnt <= bit_cnt_next;
        data_int <= data_int_next;
    end if;
  end process sync;
end architecture beh;

--- EOF ---