library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.core_pack.all;
use work.op_pack.all;

use work.jmpu;
use work.memu;

entity mem is
	
	port (
		clk, reset    : in  std_logic;
		stall         : in  std_logic;
		flush         : in  std_logic;
		mem_op        : in  mem_op_type;
		jmp_op        : in  jmp_op_type;
		pc_in         : in  std_logic_vector(PC_WIDTH-1 downto 0);
		rd_in         : in  std_logic_vector(REG_BITS-1 downto 0);
		aluresult_in  : in  std_logic_vector(DATA_WIDTH-1 downto 0);
		wrdata        : in  std_logic_vector(DATA_WIDTH-1 downto 0);
		zero, neg     : in  std_logic;
		new_pc_in     : in  std_logic_vector(PC_WIDTH-1 downto 0);
		pc_out        : out std_logic_vector(PC_WIDTH-1 downto 0);
		pcsrc         : out std_logic;
		rd_out        : out std_logic_vector(REG_BITS-1 downto 0);
		aluresult_out : out std_logic_vector(DATA_WIDTH-1 downto 0);
		memresult     : out std_logic_vector(DATA_WIDTH-1 downto 0);
		new_pc_out    : out std_logic_vector(PC_WIDTH-1 downto 0);
		wbop_in       : in  wb_op_type;
		wbop_out      : out wb_op_type;
		mem_out       : out mem_out_type;
		mem_data      : in  std_logic_vector(DATA_WIDTH-1 downto 0);
		exc_load      : out std_logic;
		exc_store     : out std_logic);

end mem;

architecture rtl of mem is

signal jmp_op_int : jmp_op_type;
signal jmp_N, jmp_Z, jmp_J : std_logic;

signal memu_op : mem_op_type;
signal memu_A : std_logic_vector(ADDR_WIDTH-1 downto 0);
signal memu_W, memu_D, memu_R : std_logic_vector(DATA_WIDTH-1 downto 0);
signal memu_M : mem_out_type;
signal memu_XL, memu_XS : std_logic;

begin  -- rtl

	jmpu_inst : entity jmpu
	port map (
		-- in
		op => jmp_op_int,
		N => jmp_N,
		Z => jmp_Z,
		--out
		J => jmp_J
	);

	memu_inst : entity memu
	port map (
		-- in
		op => memu_op,
		A => memu_A,
		W => memu_W,
		D => memu_D,
		-- out
		M => memu_M,
		R => memu_R,
		XL => memu_XL,
		XS => memu_XS
	);

	mem_proc : process(clk, reset, stall, flush, jmp_op, jmp_J, mem_op, pc_in, rd_in,
		aluresult_in, wrdata, zero, neg, new_pc_in, wbop_in, mem_data,
		memu_M, memu_R, memu_XL, memu_XS)
	begin
		if reset = '0' then
			null;
		elsif rising_edge(clk) and stall = '0' then
			-- pass unchanged signals
			pc_out <= pc_in;
			rd_out <= rd_in;
			aluresult_out <= aluresult_in;
			new_pc_out <= new_pc_in;
			wbop_out <= wbop_in;

			-- jump
			jmp_op_int <= jmp_op;
			jmp_N <= neg;
			jmp_Z <= zero;
			pcsrc <= jmp_J;

			-- memu
			memu_op <= mem_op;
			mem_out <= memu_M;
			exc_load <= memu_XL;
			exc_store <= memu_XS;
			memu_W <= wrdata;
			memu_D <= mem_data;
			memresult <= memu_R;
		end if;
	end process mem_proc;

end rtl;
