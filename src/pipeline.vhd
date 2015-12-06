library ieee;
use ieee.std_logic_1164.all;
use work.core_pack.all;
use work.op_pack.all;

entity pipeline is
	
	port (
		clk, reset : in	 std_logic;
		mem_in     : in  mem_in_type;
		mem_out    : out mem_out_type;
		intr       : in  std_logic_vector(INTR_COUNT-1 downto 0));

end pipeline;

architecture rtl of pipeline is

--fetch signals
signal f_instr : std_logic_vector(INSTR_WIDTH-1 downto 0));


--memory singals
signal mem_wbop_out : mem_op_type;
signal mem_aluresult_out, mem_memresult : std_logic_vector(DATA_WIDTH-1 downto 0));
signal mem_rd_out : out std_logic_vector(REG_BITS-1 downto 0);
	
begin  -- rtl

	pipeline_proc : process
	begin
		clk, reset : in	 std_logic;
		stall      : in  std_logic;
		pcsrc	   : in	 std_logic;
		pc_in	   : in	 std_logic_vector(PC_WIDTH-1 downto 0);
		pc_out	   : out std_logic_vector(PC_WIDTH-1 downto 0);
		instr	   : out std_logic_vector(INSTR_WIDTH-1 downto 0));

		fetch_inst : entity work.fetch
		--NO CLUE HOW TO MAP fetch
			port map(
			-- in
				clk => clk,
				reset => reset,
				stall => null, --TODO
				pcsrc => null, --TODO
				pc_in => null, --TODO
			-- out
				pc_out => null, --TODO
				instr => f_instr			
			);


		decode_inst : entity work.decode
			port map(
			--in
				clk => clk,
				reset => reset,
				stall => null, --TODO
				flush => '0',
				pc_in => null, --TODO
				instr => f_instr,
				wraddr =>
				wrdata =>
				regwrite =>
				
			--out
				pc_out =>
				exec_op =>
				cop0_op =>
				jmp_op =>
				mem_op =>
				wb_op =>
				exc_dec =>		
			);
	
	
		exec_inst : entity work.exec
			port map(
			--in
				memop_in =>
				jmpop_in =>
				wbop_in =>
				forwardA =>
				forwardB =>
				cop0_rddata =>
				mem_aluresult =>
				wb_result =>
				
			--out
				pc_out =>
				rd, rs, rt =>
				aluresult =>
				wrdata =>
				zero =>
				neg =>
				new_pc =>		
				memop_out =>
				jmpop_out =>	
				wbop_out =>
				exc_ovf =>		
			);

		mem_inst : entity work.mem
			port map(
			--in
				clk => clk,
				reset => reset,
				stall => null, --TODO
				flush => null, --TODO
				mem_op => null, --TODO
				jmp_op => null, --TODO
				pc_in => null, --TODO
				rd_in => null, --TODO
				aluresult_in => null, --TODO
				wrdata => null, --TODO
				zero  => null, --TODO 
				neg => null, --TODO
				new_pc_in => null, --TODO
				wbop_in => null, --TODO
				mem_data => null, --TODO
				
			--out
				pc_out => null, --TODO
				pcsrc => null, --TODO
				rd_out => mem_rd_out, --TODO
				aluresult_out => mem_aluresult_out, 
				memresult => mem_memresult, 
				new_pc_out => null, --TODO
				wbop_out => mem_wbop_out,
				mem_out => null, --TODO
				exc_load => null, --TODO
				exc_store  => null, --TODO
			);				

		wb_inst : entity work.wb
		--TODO: Programmcounter implement
			port map(
			--in
				clk => clk,
				reset => reset,
				stall => null,
				flush => '0',
				op => mem_op_type,
				rd_in => mem_rd_out,
				aluresult => mem_aluresult_out,
				memresult => mem_memresult,
				
			--out
				rd_out =>
				result =>
				regwrite =>		
			);
			
	end process pipeline_proc;
end rtl;
