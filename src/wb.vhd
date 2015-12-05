library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.core_pack.all;
use work.op_pack.all;

entity wb is
	
	port (
		clk, reset : in  std_logic;
		stall      : in  std_logic;
		flush      : in  std_logic;
		op	   	   : in  wb_op_type;
		rd_in      : in  std_logic_vector(REG_BITS-1 downto 0);
		aluresult  : in  std_logic_vector(DATA_WIDTH-1 downto 0);
		memresult  : in  std_logic_vector(DATA_WIDTH-1 downto 0);
		rd_out     : out std_logic_vector(REG_BITS-1 downto 0);
		result     : out std_logic_vector(DATA_WIDTH-1 downto 0);
		regwrite   : out std_logic);

end wb;

architecture rtl of wb is

begin  -- rtl

	wb : process(clk, reset, stall, flush, op, aluresult, memresult, rd_in)
	begin
		regwrite <= '0';
		
		if reset = '0' then
			rd_out <= (others => '0');
			result <= (others => '0');
			regwrite <= '0';
			
		elsif rising_edge(clk) and stall = '0' then			
			
			if flush = '1' then
				regwrite <= '1';
				rd_out <= rd_in;
				result <= (others => '0');
			end if;
			
			if flush = '0' then --only do if flush not set
				if op.regwrite = '1' then
					regwrite <= '1';				
					rd_out <= rd_in;
					
					if op.memtoreg = '0' then
						result <= aluresult;
							
					elsif op.memtoreg = '1' then
						result <= memresult;
						
					end if;
				end if;
			end if;
			
		end if;
	end process wb;


end rtl;
