library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.core_pack.all;
use work.op_pack.all;
use std.env.all;
use std.textio.all;
use ieee.numeric_std.all;
use work.txt_util.all;
use work.serial_port_receiver_pkg.serial_port_receiver;

entity core_serial_tb is
end core_serial_tb;

architecture rtl of core_serial_tb is
    constant clk_freq : integer := 50000000;
    --constant baud_rate : integer := 115200;
    constant baud_rate : integer := 500000;

    signal tx : std_logic;
    signal rx : std_logic;

    signal rx_data : std_logic_vector(7 downto 0);
    signal rx_data_new : std_logic;

    constant CLK_PERIOD : time := 20 ns;

    constant NO_INTERRUPTS : std_logic_vector(INTR_COUNT-1 downto 0) := (others => '0');
    constant INTR0 : std_logic_vector(INTR_COUNT-1 downto 0) := "001";
    constant INTR1 : std_logic_vector(INTR_COUNT-1 downto 0) := "010";
    constant INTR2 : std_logic_vector(INTR_COUNT-1 downto 0) := "100";

    signal clk : std_logic;
    signal reset : std_logic;
    signal intr        : std_logic_vector(INTR_COUNT-1 downto 0);
    signal int_intr        : std_logic_vector(INTR_COUNT-1 downto 0) := NO_INTERRUPTS;
    signal enable_intr_test : std_logic := '0';
    signal int_finish : std_logic := '0';

    signal int_stop_clk : std_logic := '0';

    signal mem_out : mem_out_type;
    signal mem_in  : mem_in_type;

    --signal tx_data : std_logic_vector(7 downto 0);

    --signal ocram_rd : std_logic;
    signal ocram_wr : std_logic;
    signal ocram_rddata : std_logic_vector(DATA_WIDTH-1 downto 0);

    signal uart_rd : std_logic;
    signal uart_wr : std_logic;
    signal uart_rddata : std_logic_vector(DATA_WIDTH-1 downto 0);

    type mux_type is (MUX_OCRAM, MUX_UART);
    signal mux : mux_type;
    
    alias tx_free : std_logic is mem_in.rddata(0);

begin  -- rtl
    pipeline_inst : entity work.pipeline port map (
        clk        => clk,
        reset   => reset,
        mem_in  => mem_in,
        mem_out => mem_out,
        intr    => intr);

    ocram : entity work.ocram_altera port map (
        address => mem_out.address(11 downto 2),
        byteena => mem_out.byteena,
        clock    => clk,
        data    => mem_out.wrdata,
        wren    => ocram_wr,
        q        => ocram_rddata);

    clk_proc : process
    begin
        if int_stop_clk = '0' then
            clk <= '0';
            wait for CLK_PERIOD/2;
            clk <= '1';
            wait for CLK_PERIOD/2;
        else
            wait;
        end if;
    end process clk_proc;

    reset_proc : process
    begin
        reset <= '0';
        wait for CLK_PERIOD;
        reset <= '1';
        wait;
    end process reset_proc;

    uart : entity work.serial_port_wrapper generic map (
        clk_freq  => clk_freq,
        baud_rate => baud_rate,
        sync_stages => 2,
        tx_fifo_depth => 4,
        rx_fifo_depth => 4)
    port map (
        clk     => clk,
        res_n     => reset,

        address => mem_out.address(2 downto 2),
        wr        => uart_wr,
        wr_data    => mem_out.wrdata,
        rd         => uart_rd,
        rd_data => uart_rddata,

        tx      => tx,
        rx      => rx);

    serial_port_receiver_fsm : serial_port_receiver
      generic map (
        CLK_DIVISOR => CLK_FREQ / BAUD_RATE
      )
      port map (
        clk => clk,
        res_n => reset,
        rx => tx,
        data => rx_data,
        data_new => rx_data_new
      );

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

--        uart_rd <= '0';
--        uart_wr <= '0';
--        if mux = MUX_UART then
--            mem_in.rddata <= (others => '0');
--            if mem_out.address(2) = '0' then
--                mem_in.rddata <= (others => '0');
--                mem_in.rddata(24) <= '1';
--            end if;
--        end if;

    end process iomux;

--  intr_proc : process
--  begin
--      wait until reset = '1';
--      if enable_intr_test = '1' then
--          wait until int_intr'EVENT;
--          wait for CLK_PERIOD;
--              intr <= int_intr;
--              wait for CLK_PERIOD;
--              intr <= NO_INTERRUPTS;
--      else
--          intr <= NO_INTERRUPTS;
--          wait;
--      end if;
--  end process intr_proc;
--
    intr_test_proc: process
    begin
        intr <= NO_INTERRUPTS;
        if enable_intr_test = '1' and int_finish = '0' then
            wait until reset = '1';
            wait for 100 us;
            wait for CLK_PERIOD/2;
    
            -- normal INTR0
            intr <= INTR0;
                wait for CLK_PERIOD;
                intr <= NO_INTERRUPTS;
                wait for 20 us;
    
            -- normal INTR1
            intr <= INTR1;
                wait for CLK_PERIOD;
                intr <= NO_INTERRUPTS;
                wait for 20 us;
    
            -- simultaneos INTR0 and INTR2
            intr <= INTR0 or INTR2;
                wait for CLK_PERIOD;
                intr <= NO_INTERRUPTS;
                wait for 20 us;
                wait for 20 us;
    
            -- simultaneos INTR0 and INTR1 and INTR2
            -- after processing INTR0 trigger another INTR0
            intr <= INTR0 or INTR1 or INTR2;
                wait for CLK_PERIOD;
                intr <= NO_INTERRUPTS;
                wait for 5 us;
            intr <= INTR0;
                wait for CLK_PERIOD;
                intr <= NO_INTERRUPTS;
                wait for 20 us;
                wait for 20 us;
            
            -- normal INTR1
            intr <= INTR1;
                wait for CLK_PERIOD;
                intr <= NO_INTERRUPTS;
                wait for 20 us;
        
            -- normal INTR2
            intr <= INTR2;
                wait for CLK_PERIOD;
                intr <= NO_INTERRUPTS;
                wait for 20 us;
    
            -- normal INTR0
            intr <= INTR0;
                wait for CLK_PERIOD;
                intr <= NO_INTERRUPTS;
                wait for 20 us;
    
            -- normal INTR1
            intr <= INTR1;
                wait for CLK_PERIOD;
                intr <= NO_INTERRUPTS;
                wait for 20 us;
    
            -- normal INTR2
            intr <= INTR2;
                wait for CLK_PERIOD;
                intr <= NO_INTERRUPTS;
                wait for 20 us;
    
            -- normal INTR0
            intr <= INTR0;
                wait for CLK_PERIOD;
                intr <= NO_INTERRUPTS;
                wait for 20 us;
    
            -- normal INTR1
            intr <= INTR1;
                wait for CLK_PERIOD;
                intr <= NO_INTERRUPTS;
                wait for 20 us;
    
            -- normal INTR2
            intr <= INTR2;
                wait for CLK_PERIOD;
                intr <= NO_INTERRUPTS;
                wait for 20 us;
    
            -- normal INTR0
            intr <= INTR0;
                wait for CLK_PERIOD;
                intr <= NO_INTERRUPTS;
                wait for 20 us;
    
            -- normal INTR1
            intr <= INTR1;
                wait for CLK_PERIOD;
                intr <= NO_INTERRUPTS;
                wait for 20 us;
    
            -- normal INTR2
            intr <= INTR2;
                wait for CLK_PERIOD;
                intr <= NO_INTERRUPTS;
                wait for 20 us;
    
            -- normal INTR0
            intr <= INTR0;
                wait for CLK_PERIOD;
                intr <= NO_INTERRUPTS;
                wait for 20 us;
    
            -- normal INTR1
            intr <= INTR1;
                wait for CLK_PERIOD;
                intr <= NO_INTERRUPTS;
                wait for 20 us;
    
            -- normal INTR2
            intr <= INTR2;
                wait for CLK_PERIOD;
                intr <= NO_INTERRUPTS;
                wait for 20 us;
    
            -- normal INTR0
            intr <= INTR0;
                wait for CLK_PERIOD;
                intr <= NO_INTERRUPTS;
                wait for 20 us;
    
            -- normal INTR1
            intr <= INTR1;
                wait for CLK_PERIOD;
                intr <= NO_INTERRUPTS;
                wait for 20 us;
    
            -- normal INTR2
            intr <= INTR2;
                wait for CLK_PERIOD;
                intr <= NO_INTERRUPTS;
                wait for 20 us;
    
            -- normal INTR0
            intr <= INTR0;
                wait for CLK_PERIOD;
                intr <= NO_INTERRUPTS;
                wait for 20 us;
    
            -- normal INTR1
            intr <= INTR1;
                wait for CLK_PERIOD;
                intr <= NO_INTERRUPTS;
                wait for 20 us;
    
            -- normal INTR2
            intr <= INTR2;
                wait for CLK_PERIOD;
                intr <= NO_INTERRUPTS;
                wait for 20 us;
    
                wait for 20 us;
            
            wait for 20 us;
            int_finish <= '1'; 
        end if;
        wait;
    end process intr_test_proc;

    write_proc: process (reset, clk, int_finish)
        --variable tx_data : std_logic_vector(7 downto 0);
        variable char: character;
        variable wrline : line;
        file fd : text open write_mode is "../sim/uart_output.log";
        variable bin_line : string(31 downto 1);
    begin
        if reset = '0' then
        elsif int_finish = '1' then
            flush(fd);
            file_close(fd);
            int_stop_clk <= '1';
        elsif rising_edge(clk) then
            if rx_data_new = '1' then
                --tx_data := mem_out.wrdata(31 downto 24);
                char := character'val(to_integer(unsigned(rx_data)));
                if to_integer(unsigned(rx_data)) = 10 then
                    --read(wrline, bin_line);
                    --report bin_line;
                    --print(wrline);
                    writeline(fd, wrline);
                    --writeline(output, wrline);
                    flush(fd);
                    --flush(output);
                    deallocate(wrline);
                else
                    write(wrline, char);
                end if;
            end if;
        end if;
    end process write_proc;
end rtl;
