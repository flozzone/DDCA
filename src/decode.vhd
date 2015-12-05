library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.core_pack.all;
use work.op_pack.all;
use work.regfile;

entity decode is
	
	port (
		clk, reset : in  std_logic;
		stall      : in  std_logic;
		flush      : in  std_logic;
		pc_in      : in  std_logic_vector(PC_WIDTH-1 downto 0);
		instr	   : in  std_logic_vector(INSTR_WIDTH-1 downto 0);
		wraddr     : in  std_logic_vector(REG_BITS-1 downto 0);
		wrdata     : in  std_logic_vector(DATA_WIDTH-1 downto 0);
		regwrite   : in  std_logic;
		pc_out     : out std_logic_vector(PC_WIDTH-1 downto 0);
		exec_op    : out exec_op_type;
		cop0_op    : out cop0_op_type;
		jmp_op     : out jmp_op_type;
		mem_op     : out mem_op_type;
		wb_op      : out wb_op_type;
		exc_dec    : out std_logic);

end decode;

architecture rtl of decode is
    
    -- state machine states
    type DECODER_STATE_TYPE is (RESET_ST, DECODE_ST, READREGISTER, OUTPUT_ST);

    -- signal deklarations
    signal decode_state     : DECODER_STATE_TYPE := RESET_ST;
    signal decode_state_next: DECODER_STATE_TYPE := RESET_ST;
    
    -- intern decoder signals
    signal int_pc_in        : std_logic_vector(PC_WIDTH-1 downto 0);
	signal int_instr	    : std_logic_vector(INSTR_WIDTH-1 downto 0);
    signal int_wraddr       : std_logic_vector(REG_BITS-1 downto 0);
    signal int_wrdata       : std_logic_vector(DATA_WIDTH-1 downto 0);
    
    -- intern regfile signals
    signal int_stall_reg    : std_logic;
    signal int_rdaddr1      : std_logic_vector(REG_BITS-1 downto 0);
    signal int_rdaddr2      : std_logic_vector(REG_BITS-1 downto 0);
    signal int_rddata1      : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal int_rddata2      : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal int_wraddr_reg   : std_logic_vector(REG_BITS-1 downto 0);
    signal int_wrdata_reg   : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal int_regwrite     : std_logic;
    
    signal opcode           : std_logic_vector(5 downto 0);
    signal rs               : std_logic_vector(4 downto 0);
    signal rt               : std_logic_vector(4 downto 0);
    signal rd               : std_logic_vector(4 downto 0);
    signal shamt            : std_logic_vector(4 downto 0);
    signal func             : std_logic_vector(5 downto 0);
    signal adrim            : std_logic_vector(15 downto 0);
    signal taradr           : std_logic_vector(25 downto 0);

begin  -- rtl
    
    -- component deklarations
    regfile_inst : entity regfile
    port map (
        clk         => clk,
        reset       => reset,
        stall       => int_stall_reg,   -- in
        rdaddr1     => int_rdaddr1,     -- in
        rdaddr2     => int_rdaddr2,     -- in
        rddata1     => int_rddata1,     -- out
        rddata2     => int_rddata2,     -- out
        wraddr      => int_wraddr_reg,  -- in
        wrdata      => int_wrdata_reg,  -- in
        regwrite    => int_regwrite     -- in
    );
    
    -- ############# --
    -- process: sync --
    -- ############# --
    sync : process (clk, reset)
    begin
        if reset = '0' then
            --TODO: reset
            decode_state <= RESET_ST;
            
            int_pc_in   <= (others => '0');
            int_instr   <= (others => '0');
            int_wraddr  <= (others => '0');
            int_wrdata  <= (others => '0');
            
            int_stall_reg <= '0'; --TODO stall = 1 ?
            int_rdaddr1 <= (others => '0');
            int_rdaddr2 <= (others => '0');
            int_rddata1 <= (others => '0');
            int_rdaddr2 <= (others => '0');
            int_wraddr_reg  <= (others => '0');
            int_wrdata_reg  <= (others => '0');
            int_regwrite<= '0';
            
        elsif rising_edge(clk) then
            --TODO: rising edge stuff
            decode_state <= decode_state_next;
            
            if stall = '0' then
                --TODO: latch inputs into intern registers
                int_pc_in   <= pc_in;
                int_instr   <= instr;
                int_wraddr  <= wraddr;
                int_wrdata  <= wrdata;
            end if;
            
            if flush = '1' then
                --TODO: flush registers
                int_pc_in   <= (others => '0');
                int_instr   <= (others => '0');
                int_wraddr  <= (others => '0');
                int_wrdata  <= (others => '0');
                int_stall_reg <= '0'; --TODO stall = 1 ?
                int_rdaddr1 <= (others => '0');
                int_rdaddr2 <= (others => '0');
                int_rddata1 <= (others => '0');
                int_rdaddr2 <= (others => '0');
                int_wraddr_reg  <= (others => '0');
                int_wrdata_reg  <= (others => '0');
                int_regwrite<= '0';
            end if;
            
        end if;
    end process sync;

    -- ################### --
    -- process: next_state --
    -- ################### --
    next_state : process (decode_state)
    begin
        decode_state_next <= decode_state;

        opcode <= (others => '0');
        case decode_state is
            ---------------------------------------------------
            when RESET_ST =>
                decode_state_next <= DECODE_ST;
            ---------------------------------------------------
            when DECODE_ST =>
                --TODO: condition?
                decode_state_next <= READREGISTER;
            ---------------------------------------------------
            when READREGISTER =>
                decode_state_next <= OUTPUT_ST;
            ---------------------------------------------------
            when OUTPUT_ST =>
                decode_state_next <= DECODE_ST;
            ---------------------------------------------------
            when others =>
                null;
        end case;
    end process next_state;
    
    -- ############### --
    -- process: output --
    -- ############### --
    output : process (decode_state, int_instr, opcode, rs, rd, func)
    begin
        case decode_state is
            ---------------------------------------------------
            when RESET_ST =>
                --TODO: stuff
                null;
            ---------------------------------------------------
            when DECODE_ST =>
                --TODO: stuff
                opcode <= int_instr(31 downto 26);
                rs     <= int_instr(25 downto 21);
                rt     <= int_instr(20 downto 16);
                rd     <= int_instr(15 downto 11);
                shamt  <= int_instr(10 downto 6);
                func   <= int_instr(5 downto 0);
                adrim  <= int_instr(15 downto 0);
                taradr <= int_instr(25 downto 0);
    
                -- ############## start case opcode ############## --
                case opcode is
                    when "000000" =>
                        -- Format: R    Syntax: --  Semantics:  Table 21
                        -- ############## start case func ############## --
                        case func is 
                            when "000000" =>
                                -- Syntax: SLL rd, rt, shamt    Semantics: rd = rt << shamt
                                --TODO
                                null;
                            when "000010" =>
                                -- Syntax: SRL rd, rt, shamt    Semantics: rd = rt0/ >> shamt
                                --TODO
                                null;
                            when "000011" =>
                                -- Syntax: SRA rd, rt, shamt    Semantics: rd = rt± >> shamt
                                --TODO
                                null;
                            when "000100" =>
                                -- Syntax: SLLV rd, rt, rs  Semantics: rd = rt << rs4:0
                                --TODO
                                null;
                            when "000110" =>
                                -- Syntax: SRLV rd, rt, rs  Semantics: rd = rt0/ >> rs4:0
                                --TODO
                                null;
                            when "000111" =>
                                -- Syntax: SRAV rd, rt, rs  Semantics: rd = rt±>> rs4:0
                                --TODO
                                null;
                            when "001000" =>
                                -- Syntax: JR rs            Semantics: pc = rs
                                --TODO
                                null;
                            when "001001" =>
                                -- Syntax: JALR rd, rs      Semantics: rd = pc+4; pc = rs
                                --TODO
                                null;
                            when "100000" =>
                                -- Syntax: ADD rd, rs, rt   Semantics: rd = rs + rt, overflow trap
                                --TODO
                                null;
                            when "100001" =>
                                -- Syntax: ADDU rd, rs, rt  Semantics: rd = rs + rt
                                --TODO
                                null;
                            when "100010" =>
                                -- Syntax: SUB rd, rs, rt   Semantics: rd = rs - rt, overflow trap
                                --TODO
                                null;
                            when "100011" =>
                                -- Syntax: SUBU rd, rs, rt  Semantics: rd = rs - rt
                                --TODO
                                null;
                            when "100100" =>
                                -- Syntax: AND rd, rs, rt   Semantics: rd = rs & rt
                                --TODO
                                null;
                            when "100101" =>
                                -- Syntax: OR rd, rs, rt    Semantics: rd = rs | rt
                                --TODO
                                null;
                            when "100110" =>
                                -- Syntax: XOR rd, rs, rt   Semantics: rd = rs ^ rt
                                --TODO
                                null;
                            when "100111" =>
                                -- Syntax: NOR rd, rs, rt   Semantics: rd = ~(rs | rt)
                                --TODO
                                null;
                            when "101010" =>
                                -- Syntax: SLT rd, rs, rt   Semantics: rd = (rs± < rt±) ? 1 : 0
                                --TODO
                                null;
                            when "101011" =>
                                -- Syntax: SLTU rd, rs, rt  Semantics: rd = (rs0/ < rt0/ ) ? 1 : 0
                                --TODO
                                null;
                            when others =>
                                --TODO
                                null;
                        end case;
                        -- ############## end case func ############## --
                    when "000001" =>
                        -- Format: I    Syntax: --  Semantics: Table 22
                        -- ############## start case rd ############## --
                        case rd is 
                            when "00000" =>
                                -- Syntax: BLTZ rs, imm18   Semantics: if (rs±< 0) pc += imm±<< 2
                                --TODO
                                null;
                            when "00001" =>
                                -- Syntax: BGEZ rs, imm18   Semantics: if (rs±>= 0) pc += imm±<< 2
                                --TODO
                                null;
                            when "10000" =>
                                -- Syntax: BLTZAL rs, imm18 Semantics: r31 = pc+4; if (rs±< 0) pc += imm±<< 2
                                --TODO
                                null;
                            when "10001" =>
                                -- Syntax: BGEZAL rs, imm18 Semantics: r31 = pc+4; if (rs±>= 0) pc += imm±<< 2
                                --TODO
                                null;
                            when others =>
                                --TODO
                                null;
                        end case;
                        -- ############## end case rd ############## --
                    when "000010" =>
                        -- Format: J    Syntax: J address   Semantics: pc = address0/ << 2    
                        --TODO
                        null;
                    when "000011" =>
                        -- Format: J    Syntax: JAL address   Semantics: r31 = pc+4; pc = address0/ << 2
                        --TODO
                        null;
                    when "000100" =>
                        -- Format: I    Syntax: BEQ rd, rs, imm18   Semantics: if (rs == rd) pc += imm± << 2
                        --TODO
                        null;
                    when "000101" =>
                        -- Format: I    Syntax: BNE rd, rs, imm18   Semantics: if (rs != rd) pc += imm± << 2
                        --TODO
                        null;
                    when "000110" =>
                        -- Format: I    Syntax:  BLEZ rs, imm18   Semantics: if (rs±<= 0) pc += imm± << 2
                        --TODO
                        null;
                    when "000111" =>
                        -- Format: I    Syntax:  BGTZ rs, imm18   Semantics: if (rs±> 0) pc += imm± << 2
                        --TODO
                        null;
                    when "001000" =>
                        -- Format: I    Syntax:  ADDI rd, rs, imm16   Semantics: rd = rs + imm±, overflow trap
                        --TODO
                        null;
                    when "001001" =>
                        -- Format: I    Syntax: ADDIU rd, rs, imm16    Semantics: rd = rs + imm±
                        --TODO
                        null;
                    when "001010" =>
                        -- Format: I    Syntax: SLTI rd, rs, imm16   Semantics: rd = (rs± < imm±) ? 1 : 0
                        --TODO
                        null;
                    when "001011" =>
                        -- Format: I    Syntax: SLTIU rd, rs, imm16    Semantics: rd = (rs0/ < imm0/) ? 1 : 0
                        --TODO
                        null;
                    when "001100" =>
                        -- Format: I    Syntax: ANDI rd, rs, imm16   Semantics: rd = rs & imm0
                        --TODO
                        null;
                    when "001101" =>
                        -- Format: I    Syntax:  ORI rd, rs, imm16   Semantics: rd = rs | imm0
                        --TODO
                        null;
                    when "001110" =>
                        -- Format: I    Syntax:  XORI rd, rs, imm16   Semantics: rd = rs ^ imm0
                        --TODO
                        null;
                    when "001111" =>
                        -- Format: I    Syntax:  LUI rd, imm16   Semantics: rd = imm0/ << 16
                        --TODO
                        null;
                    when "010000" =>
                        -- Format: R    Syntax: --   Semantics: Table 23
                        -- ############## start case rs ############## --
                        case rs is
                            when "00000" =>
                                -- Syntax: MFC0 rt, rd Semantics: rt = rd, rd register in coprocessor 0
                                --TODO
                                null;
                            when "00100" =>
                                -- Syntax: MTC0 rt, rd Semantics: rd = rt, rd register in coprocessor 0
                                --TODO
                                null;
                            when others =>
                                --TODO
                                null;
                        end case;
                        -- ############## end case rs ############## --
                    when "100000" =>
                        -- Format: I    Syntax:  LB rd, imm16(rs)    Semantics: rd = (int8_t)[rs+imm±]
                        --TODO
                        null;
                    when "100001" =>
                        -- Format: I    Syntax: LH rd, imm16(rs)   Semantics: rd = (int16_t)[rs+imm±]
                        --TODO
                        null;
                    when "100011" =>
                        -- Format: I    Syntax: LW rd, imm16(rs)   Semantics: rd = (int32_t)[rs+imm±]
                        --TODO
                        null;
                    when "100100" =>
                        -- Format: I    Syntax: LBU rd, imm16(rs)   Semantics: rd = (uint8_t)[rs+imm±]
                        --TODO
                        null;
                    when "100101" =>
                        -- Format: I    Syntax:  LHU rd, imm16(rs)   Semantics: rd = (uint16_t)[rs+imm±]
                        --TODO
                        null;
                    when "101000" =>
                        -- Format: I    Syntax:  SB rd, imm16(rs)   Semantics: (int8_t)[rs+imm±] = rd7:0
                        --TODO
                        null;
                    when "101001" =>
                        -- Format: I    Syntax: SH rd, imm16(rs)   Semantics: (int16_t)[rs+imm±] = rd15:0
                        --TODO
                        null;
                    when "101011" =>
                        -- Format: I    Syntax:  SW rd, imm16(rs)   Semantics: (int32_t)[rs+imm±] = rd
                        --TODO
                        null;
                    when others =>
                        --TODO
                        null;
                end case;
                -- ############## end case opcode ############## --
            ---------------------------------------------------
            when READREGISTER =>
                --TODO: stuff
                null;
            ---------------------------------------------------
            when OUTPUT_ST =>
                --TODO: stuff
                null;
            ---------------------------------------------------
            when others =>
                null;
        end case;
    end process output;
end rtl;
