----------------------------------------------------------------------------------
-- Company:      TU Wien - ECS Group                                            --
-- Engineer:     Thomas Polzer                                                  --
--                                                                              --
-- Create Date:  21.09.2010                                                     --
-- Design Name:  DIDLEU                                                         --
-- Module Name:  fifo_1c1r1w_mixed                                              --
-- Project Name: DIDELU                                                         --
-- Description:  FIFO - Architecture                                            --
----------------------------------------------------------------------------------

----------------------------------------------------------------------------------
--                                LIBRARIES                                     --
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ram_pkg.all;
use work.math_pkg.all;

----------------------------------------------------------------------------------
--                               ARCHITECTURE                                   --
----------------------------------------------------------------------------------

architecture mixed of fifo_1c1r1w is
  signal read_address, read_address_next : std_logic_vector(log2c(MIN_DEPTH) - 1 downto 0);
  signal write_address, write_address_next : std_logic_vector(log2c(MIN_DEPTH) - 1 downto 0);
  signal full_int, full_next : std_logic;
  signal empty_int, empty_next : std_logic;
  signal wr_int, rd_int : std_logic;
begin
  memory_inst : dp_ram_1c1r1w
    generic map
    (
      ADDR_WIDTH => log2c(MIN_DEPTH),
      DATA_WIDTH => DATA_WIDTH
    )
    port map
    (
      clk   => clk,
      raddr1 => read_address,
      rdata1 => data_out1,
      rd1    => rd_int,
      waddr2 => write_address,
      wdata2 => data_in2,
      wr2    => wr_int
    ); 
  
  --------------------------------------------------------------------
  --                    PROCESS : SYNC                              --
  --------------------------------------------------------------------
  
  sync : process(clk, res_n)
  begin
    if res_n = '0' then
      read_address <= (others => '0');
      write_address <= (others => '0');
      full_int <= '0';
      empty_int <= '1';
    elsif rising_edge(clk) then
      read_address <= read_address_next;
      write_address <= write_address_next;
      full_int <= full_next;
      empty_int <= empty_next;
    end if;
  end process sync;
  
  --------------------------------------------------------------------
  --                    PROCESS : EXEC                              --
  --------------------------------------------------------------------
  
  exec : process(write_address, read_address, full_int, empty_int, wr2, rd1)
  begin
    write_address_next <= write_address;
    read_address_next <= read_address;  
    full_next <= full_int;
    empty_next <= empty_int;
    wr_int <= '0';
    rd_int <= '0';

    if wr2 = '1' and full_int = '0' then
      wr_int <= '1'; -- only write, if fifo is not full
      write_address_next <= std_logic_vector(unsigned(write_address) + 1);
    end if;
    
    if rd1 = '1' and empty_int = '0'  then
      rd_int <= '1'; -- only read, if fifo is not empty
      read_address_next <= std_logic_vector(unsigned(read_address) + 1);
    end if;

    -- if memory is empty after current read operation
    if rd1 = '1' then
      full_next <= '0';
      if write_address = std_logic_vector(unsigned(read_address) + 1) then
        empty_next <= '1';
      end if;
    end if;
    
    -- if memory is full after current write operation
    if wr2 = '1' then
      empty_next <= '0';
      if read_address = std_logic_vector(unsigned(write_address) + 1) then
        full_next <= '1';
      end if;      
    end if;
  end process exec;

  full <= full_int;
  empty <= empty_int;
end architecture mixed;

--- EOF ---