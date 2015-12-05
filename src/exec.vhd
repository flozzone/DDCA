library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.core_pack.all;
use work.op_pack.all;

use work.alu;

entity exec is
	
	port (
		clk, reset       : in  std_logic;
		stall      		 : in  std_logic;
		flush            : in  std_logic;
		pc_in            : in  std_logic_vector(PC_WIDTH-1 downto 0);
		op	   	         : in  exec_op_type;
		pc_out           : out std_logic_vector(PC_WIDTH-1 downto 0);
		rd, rs, rt       : out std_logic_vector(REG_BITS-1 downto 0);
		aluresult	     : out std_logic_vector(DATA_WIDTH-1 downto 0);
		wrdata           : out std_logic_vector(DATA_WIDTH-1 downto 0);
		zero, neg         : out std_logic;
		new_pc           : out std_logic_vector(PC_WIDTH-1 downto 0);		
		memop_in         : in  mem_op_type;
		memop_out        : out mem_op_type;
		jmpop_in         : in  jmp_op_type;
		jmpop_out        : out jmp_op_type;
		wbop_in          : in  wb_op_type;
		wbop_out         : out wb_op_type;
		forwardA         : in  fwd_type;
		forwardB         : in  fwd_type;
		cop0_rddata      : in  std_logic_vector(DATA_WIDTH-1 downto 0);
		mem_aluresult    : in  std_logic_vector(DATA_WIDTH-1 downto 0);
		wb_result        : in  std_logic_vector(DATA_WIDTH-1 downto 0);
		exc_ovf          : out std_logic);

end exec;
architecture rtl of exec is

signal alu_op : alu_op_type;
signal alu_A : std_logic_vector(DATA_WIDTH-1 downto 0);
signal alu_B : std_logic_vector(DATA_WIDTH-1 downto 0);
signal alu_R : std_logic_vector(DATA_WIDTH-1 downto 0);
signal alu_Z : std_logic;
signal alu_V : std_logic;

begin  -- rtl
	alu_inst : entity alu
	port map (
		op => alu_op,
		A => alu_A,
		B => alu_B,
		R => alu_R,
		Z => alu_Z,
		V => alu_V
	);

	multiplex : process(clk, reset, stall, flush, op, pc_in, memop_in, jmpop_in, wbop_in, forwardA, forwardB, cop0_rddata, mem_aluresult, wb_result)
	begin
		if reset = '0' then
			null;
		elsif rising_edge(clk) and stall = '0' then
			exc_ovf <= op.ovf;
			rs <= op.rs;
			rt <= op.rt;

			pc_out <= pc_in;
			memop_out <= memop_in;
			jmpop_out <= jmpop_in;
			wbop_out <= wbop_in;

			-- TODO: ignore these signals for this assignment
			-- forwardA
			-- forwardB
			-- mem_aluresult
			-- wb_result

			-- depends on instruction format
			if op.regdst = '1' then
				-- R format
				rd <= op.rd;
			else
				-- others
				rd <= op.rt;
			end if;

			-- aluresult
			-- * aluresult <= mem_aluresult
			-- * aluresult <= cop0_rddata for mfc0 instr
			-- * aluresult <= pc_in (adjusted!? with ALU) for jal, jalr instr
			-- * aluresult <= pc
			
		end if;
	end process multiplex;
end rtl;
