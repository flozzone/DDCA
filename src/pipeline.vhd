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

signal clk     			: std_logic;
signal reset   			: std_logic;
signal stall    		: std_logic;
signal flush  		  : std_logic;

-- fetch - decode
signal fd_pc
signal fd_instr : std_logic_vector(INSTR_WIDTH-1 downto 0)); 

-- decode - execute
signal de_pc        : std_logic_vector(PC_WIDTH-1 downto 0);
signal de_exec_op   : exec_op_type;
signal de_cop0_op   : cop0_op_type;
signal de_jmp_op    : jmp_op_type;
signal de_mem_op    : mem_op_type;
signal de_wb_op     : wb_op_type;
signal de_exec_dec  : std_logic;

-- execute - memory
signal em_rd				: std_logic_vector(REG_BITS-1 downto 0);
signal em_aluresult	: std_logic_vector(DATA_WIDTH-1 downto 0));
signal em_wrdata		: std_logic_vector(DATA_WIDTH-1 downto 0));
signal em_zero			: std_logic;
signal em_neg				: std_logic;
signal em_new_pc		: std_logic_vector(PC_WIDTH-1 downto 0);
signal em_pc				: std_logic_vector(PC_WIDTH-1 downto 0);
signal em_memop			: mem_op_type;
signal em_jmpop			: jmp_op_type;
signal em_wbop			: wb_op_type;

-- memory - write back
signal mw_memresult : std_logic_vector(DATA_WIDTH-1 downto 0));
signal mw_pc				: std_logic_vector(PC_WIDTH-1 downto 0);
signal mw_rd				: std_logic_vector(REG_BITS-1 downto 0);
signal mw_aluresult : std_logic_vector(DATA_WIDTH-1 downto 0));
signal mw_wbop			: wb_op_type;

-- other
signal fm_pcsrc			: std_logic;
signal fm_new_pc		: std_logic_vector(PC_WIDTH-1 downto 0);
signal dw_data		: std_logic_vector(DATA_WIDTH-1 downto 0));
signal dw_regwrite  : std_logic;
signal dw_rd				: std_logic_vector(REG_BITS-1 downto 0);

--memory signals
--signal mem_wbop_out  : mem_op_type;
--signal mem_aluresult_out, mem_memresult : std_logic_vector(DATA_WIDTH-1 downto 0));
--signal mem_rd_out : out std_logic_vector(REG_BITS-1 downto 0);

--wb signals
--signal wb_regwrite : std_logic;
--signal wb_result : std_logic_vector(DATA_WIDTH-1 downto 0));
--signal wb_rd_out : std_logic_vector(REG_BITS-1 downto 0);
	
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
				stall => stall,
				pcsrc => fm_pcsrc,
				pc_in => fm_new_pc,
			-- out
				pc_out => fd_pc,
				instr => fd_instr
			);


		decode_inst : entity work.decode
			port map(
			--in
				clk => clk,
				reset => reset,
				stall => stall,
				flush => flush,
				pc_in => fd_pc,
				instr => fd_instr,
				wraddr => dw_rd,
				wrdata => dw_data,
				regwrite => dw_regwrite,
				
			--out
				pc_out => de_pc,
				exec_op => de_exec_op,
				cop0_op => null, -- TODO
				jmp_op => de_jmp_op,
				mem_op => de_mem_op,
				wb_op => de_wb_op,
				exc_dec => null, -- TODO
			);
	
	
		exec_inst : entity work.exec
			port map(
			--in
				clk => clk,
				reset => reset,
				stall => stall,
				flush => flush,
				memop_in => de_mem_op,
				jmpop_in => de_jmp_op,
				wbop_in => de_wb_op,
				forwardA => null, -- TODO
				forwardB => null, -- TODO
				cop0_rddata => null, -- TODO
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
				stall => stall,
				flush => flush,
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
				stall => stall,
				flush => flush,
				op => mem_op_type,
				rd_in => mem_rd_out,
				aluresult => mem_aluresult_out,
				memresult => mem_memresult,
				
			--out
				rd_out => wb_rd_out,
				result => wb_result,
				regwrite =>	wb_regwrite
			);
			
	end process pipeline_proc;
end rtl;
