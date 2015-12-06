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

signal add_A : std_logic_vector(DATA_WIDTH-1 downto 0);
signal add_B : std_logic_vector(DATA_WIDTH-1 downto 0);
signal add_R : std_logic_vector(DATA_WIDTH-1 downto 0);

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

	multiplex : process(clk, reset, stall, flush, op, pc_in, memop_in, jmpop_in, wbop_in, 
			forwardA, forwardB, cop0_rddata, mem_aluresult, wb_result, alu_R, alu_Z, alu_V)
	begin

		if reset = '0' then
			null;
		elsif rising_edge(clk) and stall = '0' then

			-- pass register addresses
			rs <= op.rs;
			rt <= op.rt;
			-- depends on instruction format
			if op.regdst = '1' then
				-- R format
				rd <= op.rd;
			else
				-- others
				rd <= op.rt;
			end if;

			pc_out <= pc_in;
			memop_out <= memop_in;
			jmpop_out <= jmpop_in;
			wbop_out <= wbop_in;

			-- ALU
			alu_op <= op.aluop;
			alu_A <= op.readdata1;
			if op.useimm = '0' and op.useamt = '0' then
				-- R-Format instructions
				alu_B <= op.readdata2;
				aluresult <= alu_R;
			elsif op.useimm = '1' and op.useamt = '0' then
				-- all I-Format instructions
				alu_B <= op.imm;
				aluresult <= alu_R;
			elsif op.useimm = '0' and op.useamt = '1' then
				--- shifts, SLL, SRL, SRA
				alu_A <= op.readdata2;
				alu_B <= op.imm;
				aluresult <= alu_R;
			end if;
			zero <= alu_Z;

			-- aluresult
			-- * aluresult <= alu_R 
			-- * aluresult <= cop0_rddata for mfc0 instr
			-- * aluresult <= pc_in (adjusted!? with ALU, see op.link) for jal, jalr instr
			-- * aluresult <= pc_in (adjusted!? with own adder, see op.link) for bltzal, bgtzal instr

			-- assert overflow only when required by instruction
			exc_ovf <= '0';
			if op.ovf = '1' then
				exc_ovf <= op.ovf;
			end if;

			--TODO: how to compute negative flag?
			--neg <= ?? (only with signed data)

			-- jmp flag set when: JR



			-- Markus: ich denk mir bam JALR machn wir es so: ich setzt das link flag im op_type + JMP_JMP + ALU_NOP
			-- Markus: beim JR geb ich dir ein jmp_op_type = JMP_JMP und den pc_out setz ich auf die ziel adresse
			-- Markus: bei SLL kriegst von mir readdata2 (der wert von regfile(rt)) und die imm (shamt), also rt => A und imm => B

			-- TODO: ignore these signals for this assignment
			-- forwardA
			-- forwardB
			-- mem_aluresult
			-- wb_result
			
		end if;
	end process multiplex;


	adder : process(add_A, add_B)
	begin
		add_R <= std_logic_vector(unsigned(add_A) + unsigned(add_B));
	end process adder;
end rtl;
