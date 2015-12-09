
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use work.txt_util.all;
use work.op_pack.all;
use work.core_pack.all;

use work.pipeline;


entity level1_tb is
end level1_tb;

architecture arch of level1_tb is
	constant CLK_PERIOD : time := 2 ps;
	signal clk		: std_logic;
	
	signal s_reset :	 std_logic;
	signal s_mem_in  : mem_in_type;
	signal s_intr : std_logic_vector(INTR_COUNT-1 downto 0);
	signal r_mem_out : mem_out_type;
	signal a_mem_out : mem_out_type;

	signal int_s_reset :	 std_logic;
	signal int_s_mem_in  : mem_in_type;
	signal int_s_intr : std_logic_vector(INTR_COUNT-1 downto 0);
	signal int_r_mem_out : mem_out_type;
	signal int_a_mem_out : mem_out_type;

	signal has_data : boolean;
	signal int_clk_cnt : integer;

  signal testfile : string(8 downto 1);

begin

	pipeline_inst : entity pipeline
	port map (
		clk => clk,
		reset => s_reset,
		mem_in => s_mem_in,
		mem_out => r_mem_out,
		intr => s_intr
	);

	sync_proc : process
	begin
		clk <= '0';
		wait for CLK_PERIOD/2;
		clk <= '1';
		wait for CLK_PERIOD/2;
	end process sync_proc;

	--init_proc : process(
	--begin
	--	reset <= '0';
	--	wait for 2.5 ps;
	--	reset <= '1';
	--	wait until true;
	--end process init_proc;

	assert_proc : process(clk)
		variable rdline : line;
		file vector_file : text open read_mode is "../sim/testbench/level1/test.tc";
		variable bin : bit_vector(92 downto 0);
		variable vec : std_logic_vector(92 downto 0);
	begin
		if falling_edge(clk) then
				if not endfile(vector_file) then
					has_data <= true;
					readline(vector_file, rdline);
					read(rdline, bin);
					vec := to_stdlogicvector(bin);
	
					print(output, "############ LINE: " & integer'IMAGE(int_clk_cnt +1) & " ##############");
	
	        int_s_reset <= vec(92);
	        int_s_mem_in.busy <= vec(91);
	        int_s_mem_in.rddata <= vec(90 downto 59);
	        a_mem_out.address <= vec(58 downto 38);
	        a_mem_out.rd <= vec(37);
	        a_mem_out.wr <= vec(36);
	        a_mem_out.byteena <= vec(35 downto 32);
	        a_mem_out.wrdata <= vec(31 downto 0);
				else
					has_data <= false;
					print(output, "############ EOF ##############");
					assert false report "EOF of testfile reached" severity FAILURE;
			end if;			
		end if;
	end process assert_proc;

	test : process(clk)
		variable clk_cnt : integer := 0;
	begin
		if rising_edge(clk) then
			if has_data = true then

				s_reset <= int_s_reset;
				s_mem_in <= int_s_mem_in;
				--a_mem_out <= int_a_mem_out;

				assert r_mem_out.address = a_mem_out.address report "clk "&str(int_clk_cnt+1)&": wrong mem.address (" & str(r_mem_out.address) & ") expected "& str(a_mem_out.address);
				assert r_mem_out.rd = a_mem_out.rd report "clk "&str(int_clk_cnt+1)&": wrong mem.rd (" & chr(r_mem_out.rd) & ") expected "&chr(a_mem_out.rd);
				assert r_mem_out.wr = a_mem_out.wr report "clk "&str(int_clk_cnt+1)&": wrong mem.wr (" & chr(r_mem_out.wr) & ") expected "&chr(a_mem_out.wr);

				assert r_mem_out.byteena = a_mem_out.byteena report "clk "&str(int_clk_cnt+1)&": wrong mem.byteena ("&str(r_mem_out.byteena)&") expected "&str(a_mem_out.byteena);
				assert r_mem_out.wrdata = a_mem_out.wrdata report "clk "&str(int_clk_cnt+1)&": wrong mem.wrdata (" & str(r_mem_out.wrdata) & ") expected "&str(a_mem_out.wrdata);
				clk_cnt := clk_cnt + 1;
				
			else
				assert false report "No data to test";
			end if;			
		end if;
		int_clk_cnt <= clk_cnt;
	end process test;
end arch;