library ieee;
use ieee.std_logic_1164.all;

use work.core_pack.all;
use work.serial_port_pkg.all;

entity serial_port_wrapper is
	
	generic (
		clk_freq	  : integer;
		baud_rate	  : integer;
		sync_stages	  : integer;
		tx_fifo_depth : integer;
		rx_fifo_depth : integer);

	port (
		clk		: in  std_logic;
		res_n	: in  std_logic;
		address : in  std_logic_vector(0 downto 0);
		wr		: in  std_logic;
		wr_data : in  std_logic_vector(DATA_WIDTH-1 downto 0);
		rd		: in  std_logic;
		rd_data : out std_logic_vector(DATA_WIDTH-1 downto 0);
		tx		: out std_logic;
		rx		: in  std_logic);

end serial_port_wrapper;

architecture behavior of serial_port_wrapper is

	signal tx_data : std_logic_vector(7 downto 0);
	signal tx_wr : std_logic;
	signal tx_free : std_logic;
	signal rx_data : std_logic_vector(7 downto 0);
	signal rx_rd : std_logic;
	signal rx_data_empty : std_logic;
	signal rx_data_full : std_logic;
	
	signal rd_address : std_logic_vector(0 downto 0);
	
begin  -- behavior

	sp : serial_port
		generic map (
			clk_freq	  => clk_freq,
			baud_rate	  => baud_rate,
			sync_stages	  => sync_stages,
			tx_fifo_depth => tx_fifo_depth,
			rx_fifo_depth => rx_fifo_depth)
		port map (
			clk			  => clk,
			res_n		  => res_n,
			tx_data		  => tx_data,
			tx_wr		  => tx_wr,
			tx_free       => tx_free,
			rx_data		  => rx_data,
			rx_rd		  => rx_rd,
			rx_data_empty => rx_data_empty,
			rx_data_full  => rx_data_full,
			rx			  => rx,
			tx			  => tx);

	sync: process (clk, res_n)
	begin  -- process sync
		if res_n = '0' then  				-- asynchronous reset (active low)
			rd_address <= (others => '0');
		elsif clk'event and clk = '1' then  -- rising clock edge
			if rd = '1' then
				rd_address <= address;				
			end if;
		end if;
	end process sync;
		
	write: process (address, wr, wr_data)
	begin  -- process wrap
		tx_data <= wr_data(31 downto 24);
		if address(0) = '1' then
			tx_wr <= wr;
		else
			tx_wr <= '0';
		end if;
	end process write;

	read: process (address, rd, rd_address, rx_data, rx_data_empty, rx_data_full)
	begin  -- process read
		if address(0) = '1' then
			rx_rd <= rd;
		else
			rx_rd <= '0';
		end if;
		rd_data <= (others => '0');
		if rd_address(0) = '1' then
			rd_data(31 downto 24) <= rx_data;
		else
			rd_data(31 downto 24) <= "00000" & rx_data_full & not rx_data_empty & tx_free;
		end if;
	end process read;
	
end behavior;
