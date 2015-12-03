library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use ieee.numeric_bit.all;
--use ieee.std_logic_arith.all;
--use ieee.std_logic_signed.all;
--use ieee.std_logic_unsigned.all;


use work.core_pack.all;
use work.op_pack.all;

entity alu is
	port (
		op   : in  alu_op_type;
		A, B : in  std_logic_vector(DATA_WIDTH-1 downto 0);
		R    : out std_logic_vector(DATA_WIDTH-1 downto 0);
		Z    : out std_logic;
		V    : out std_logic);

end alu;

architecture rtl of alu is

begin --rtl
  
  cmd : process (op, A, B)
    begin
        R <= (others => '0');
                
		if (Signed(A) = 0) then
			Z <= '1';
		else
			Z <= '0';
		end if;
		
		V <= '0';
		
		
        case op is

        
        
		when ALU_NOP =>
			R <= A;
			
		when ALU_LUI =>
			R <= std_logic_vector(shift_left(Signed(B),16));
			
		when ALU_SLT =>
			if Signed(A) < Signed(B) then
				R(0) <= '1';
			else
				R(0) <= '0';
			end if;
			
		when ALU_SLTU =>
			if Unsigned(A) < Unsigned(B) then
				R(0) <= '1';
			else
				R(0) <= '0';
			end if;
			
		when ALU_SLL =>
			R <= std_logic_vector(shift_left(Unsigned(B),to_integer(signed(A(DATA_WIDTH_BITS-1 downto 0)))));
			
		when ALU_SRL =>
			R <= std_logic_vector(shift_right(Unsigned(B),to_integer(signed(A(DATA_WIDTH_BITS-1 downto 0)))));
			
		when ALU_SRA =>
		--TODO TO FIX
			--R <= std_logic_vector(shift_right(Unsigned(B),to_integer(signed(A(DATA_WIDTH_BITS-1 downto 0)))));
			--R(DATA_WIDTH_BITS-1) <= not std_logic(shift_right(signed(B),to_integer(signed(A(DATA_WIDTH_BITS-1 downto 0)))))(DATA_WIDTH_BITS-1);
			-- xxxxx  R(DATA_WIDTH_BITS-1) <= not (std_logic(std_logic_vector(shift_right(signed(B),to_integer(signed(A(DATA_WIDTH_BITS-1 downto 0)))))(DATA_WIDTH_BITS-1)));
			
		when ALU_ADD =>
			R <= std_logic_vector(Signed(A)+Signed(B));
			
			if to_integer(Signed(A)) >= 0 and to_integer(Signed(B)) >= 0 and to_integer((Signed(A)+Signed(B))) < 0 then
				V <= '1';
			elsif to_integer(Signed(A)) < 0 and to_integer(Signed(B)) < 0 and to_integer((Signed(A)+Signed(B))) >= 0 then
				V <= '1';
			end if;
			
		when ALU_SUB =>
			R <= std_logic_vector(Signed(A)-Signed(B));
			
			if A = B then
				Z <= '1';
			else
				Z <= '0';
			end if;
			
			if (Signed(A) >= 0 and Signed(B) < 0 and (Signed(A)-Signed(B)) < 0) then
				V <= '1';
			elsif (Signed(A) < 0 and Signed(B) >= 0 and (Signed(A)-Signed(B)) >= 0) then
				V <= '1';
			end if;
			
		when ALU_AND =>
			R <= std_logic_vector(Signed(A) and Signed(B));
			
		when ALU_OR =>
			R <= std_logic_vector(Signed(A) or Signed(B));
			
		when ALU_XOR =>
			R <= std_logic_vector(Signed(A) xor Signed(B));
			
		when ALU_NOR =>
			R <= not (std_logic_vector(Signed(A) or Signed(B)));
			
		when others =>
			null;
			
        end case;
        
    end process cmd;

end rtl;
