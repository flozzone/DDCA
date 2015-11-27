library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.core_pack.all;
use work.op_pack.all;

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

begin  -- rtl

end rtl;
