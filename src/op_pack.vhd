library ieee;
use ieee.std_logic_1164.all;

use work.core_pack.all;

package op_pack is

	type alu_op_type is (
		ALU_NOP,
		ALU_SLT,
		ALU_SLTU,
		ALU_SLL,
		ALU_SRL,
		ALU_SRA,
		ALU_ADD,
		ALU_SUB,
		ALU_AND,
		ALU_OR,
		ALU_XOR,
		ALU_NOR,
		ALU_LUI
		);

	type exec_op_type is
	record
		aluop	   : alu_op_type;
		readdata1  : std_logic_vector(DATA_WIDTH-1 downto 0);
		readdata2  : std_logic_vector(DATA_WIDTH-1 downto 0);
		imm        : std_logic_vector(DATA_WIDTH-1 downto 0);
		rs, rt, rd : std_logic_vector(REG_BITS-1 downto 0);
		useimm     : std_logic;
		useamt     : std_logic;
		link       : std_logic;
		branch     : std_logic;
		regdst     : std_logic;
		cop0       : std_logic;
		ovf        : std_logic;
	end record;

	constant EXEC_NOP : exec_op_type :=
		(ALU_NOP,
		 (others => '0'), (others => '0'), (others => '0'),
		 (others => '0'), (others => '0'), (others => '0'),
		 '0', '0', '0', '0', '0', '0', '0');

	type cop0_op_type is
	record
		wr   : std_logic;
		addr : std_logic_vector(REG_BITS-1 downto 0);
	end record;

	constant COP0_NOP : cop0_op_type :=
		('0', (others => '0'));
	
	type memtype_type is (
		MEM_W,
		MEM_H,
		MEM_HU,
		MEM_B,
		MEM_BU);

	type jmp_op_type is (
		JMP_NOP,
		JMP_JMP,
		JMP_BEQ,
		JMP_BNE,
		JMP_BLEZ,
		JMP_BGTZ,
		JMP_BLTZ,
		JMP_BGEZ);
	
	type mem_op_type is
	record
		memread  : std_logic;
		memwrite : std_logic;
		memtype  : memtype_type;
	end record;

	constant MEM_NOP : mem_op_type := ('0', '0', MEM_W);

	type mem_out_type is
	record
		address  : std_logic_vector(ADDR_WIDTH-1 downto 0);
		rd, wr	 : std_logic;
		byteena  : std_logic_vector(DATA_WIDTH/BYTE_WIDTH-1 downto 0);
		wrdata	 : std_logic_vector(DATA_WIDTH-1 downto 0);
	end record;

	type mem_in_type is
	record
		busy   : std_logic;
		rddata : std_logic_vector(DATA_WIDTH-1 downto 0);
	end record;
	
	type wb_op_type is
	record
		memtoreg : std_logic;
		regwrite : std_logic;
	end record;

	constant WB_NOP : wb_op_type := ('0', '0');

	type fwd_type is (FWD_NONE, FWD_ALU, FWD_WB);	

end op_pack;
