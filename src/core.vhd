library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.core_pack.all;
use work.op_pack.all;

entity core is
	generic (
		clk_freq : integer;
		baud_rate : integer);
	port (
		clk, reset  : in  std_logic;
		tx  		: out std_logic;
		rx          : in  std_logic;
		intr        : in  std_logic_vector(INTR_COUNT-1 downto 0));

end core;

architecture rtl of core is

	signal mem_out : mem_out_type;
	signal mem_in  : mem_in_type;

	--signal ocram_rd : std_logic;
	signal ocram_wr : std_logic;
	signal ocram_rddata : std_logic_vector(DATA_WIDTH-1 downto 0);

	signal uart_rd : std_logic;
	signal uart_wr : std_logic;
	signal uart_rddata : std_logic_vector(DATA_WIDTH-1 downto 0);

	type mux_type is (MUX_OCRAM, MUX_UART);
	signal mux : mux_type;
	
begin  -- rtl

	pipeline : entity work.pipeline port map (
		clk	    => clk,
		reset   => reset,
		mem_in  => mem_in,
		mem_out => mem_out,
		intr    => intr);

	ocram : entity work.ocram_altera port map (
		address => mem_out.address(11 downto 2),
		byteena => mem_out.byteena,
		clock	=> clk,
		data	=> mem_out.wrdata,
		wren	=> ocram_wr,
		q		=> ocram_rddata);	

	uart : entity work.serial_port_wrapper generic map (
		clk_freq  => clk_freq,
		baud_rate => baud_rate,
		sync_stages => 2,
		tx_fifo_depth => 4,
		rx_fifo_depth => 4)
	port map (
		clk 	=> clk,
		res_n 	=> reset,

		address => mem_out.address(2 downto 2),
		wr		=> uart_wr,
		wr_data	=> mem_out.wrdata,
		rd 		=> uart_rd,
		rd_data => uart_rddata,
		
		tx      => tx,
		rx      => rx);

	iomux: process (mem_out, mux, ocram_rddata, uart_rddata)
	begin  -- process mux

		mux <= MUX_OCRAM;
		
		case mem_out.address(ADDR_WIDTH-1 downto ADDR_WIDTH-2) is
			when "00" => mux <= MUX_OCRAM;
			when "11" => mux <= MUX_UART;
			when others => null;
		end case;

		mem_in.busy <= mem_out.rd;

		mem_in.rddata <= (others => '0');
		case mux is
			when MUX_OCRAM => mem_in.rddata <= ocram_rddata;
			when MUX_UART  => mem_in.rddata <= uart_rddata;
			when others => null;
		end case;

		--ocram_rd <= '0';
		ocram_wr <= '0';
		if mux = MUX_OCRAM then
			--ocram_rd <= mem_out.rd;
			ocram_wr <= mem_out.wr;
		end if;

		uart_rd <= '0';
		uart_wr <= '0';
		if mux = MUX_UART then
			uart_rd <= mem_out.rd;
			uart_wr <= mem_out.wr;
		end if;
		
	end process iomux;

end rtl;

