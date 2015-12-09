library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.core_pack.all;
use work.op_pack.all;

use work.alu;

entity exec is
    port (
        clk, reset       : in  std_logic;
        stall            : in  std_logic;
        flush            : in  std_logic;
        pc_in            : in  std_logic_vector(PC_WIDTH-1 downto 0);
        op               : in  exec_op_type;
        pc_out           : out std_logic_vector(PC_WIDTH-1 downto 0);
        rd, rs, rt       : out std_logic_vector(REG_BITS-1 downto 0);
        aluresult        : out std_logic_vector(DATA_WIDTH-1 downto 0);
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

signal int_alu_op : alu_op_type := ALU_NOP;
signal int_alu_A : std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
signal int_alu_B : std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
signal int_alu_R : std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
signal int_alu_Z : std_logic := '0';
signal int_alu_V : std_logic := '0';

signal int_pc_in            : std_logic_vector(PC_WIDTH-1 downto 0);
signal int_op                : exec_op_type;
signal int_memop_in         : mem_op_type;
signal int_jmpop_in         : jmp_op_type;
signal int_jmpop_out        : jmp_op_type;
signal int_wbop_in          : wb_op_type;
signal int_wbop_out         : wb_op_type;
signal int_forwardA         : fwd_type;
signal int_forwardB         : fwd_type;
signal int_cop0_rddata      : std_logic_vector(DATA_WIDTH-1 downto 0);
signal int_mem_aluresult    : std_logic_vector(DATA_WIDTH-1 downto 0);
signal int_wb_result        : std_logic_vector(DATA_WIDTH-1 downto 0);
signal int_exc_ovf          : std_logic := '0';

begin  -- rtl
    alu_inst : entity alu
    port map (
        op => int_alu_op,
        A => int_alu_A,
        B => int_alu_B,
        R => int_alu_R,
        Z => int_alu_Z,
        V => int_alu_V
    );

      -- ##################### --
    -- process: input --
    -- ##################### --
    input : process (clk, reset)
    begin
        if reset = '0' then
            -- reset intern signals
            int_pc_in      <= (others => '0');
            int_op   <= EXEC_NOP;
            int_memop_in <= MEM_NOP;
            int_jmpop_in <= JMP_NOP;
                        int_wbop_in <= WB_NOP;
                        int_forwardA <= FWD_NONE;
                        int_forwardB <= FWD_NONE;
                        int_cop0_rddata <= (others => '0');
                        int_mem_aluresult <= (others => '0');
                        int_wb_result <= (others => '0');
        elsif rising_edge(clk) then
            if flush = '1' then
                -- flush intern signals
                int_pc_in      <= (others => '0');
                    int_op   <= EXEC_NOP;
                    int_memop_in <= MEM_NOP;
                    int_jmpop_in <= JMP_NOP;
                                int_wbop_in <= WB_NOP;
                                int_forwardA <= FWD_NONE;
                                int_forwardB <= FWD_NONE;
                                int_cop0_rddata <= (others => '0');
                                int_mem_aluresult <= (others => '0');
                                int_wb_result <= (others => '0');
            elsif stall = '0' then
                -- latch intern signals
                int_pc_in      <= pc_in;
                    int_op   <= op;
                    int_memop_in <= memop_in;
                    int_jmpop_in <= jmpop_in;
                                int_wbop_in <= wbop_in;
                                int_forwardA <= forwardA;
                                int_forwardB <= forwardB;
                                int_cop0_rddata <= cop0_rddata;
                                int_mem_aluresult <= mem_aluresult;
                                int_wb_result <= wb_result;
            end if;
        end if;
    end process input;


    multiplex : process(int_op, int_pc_in, int_memop_in, int_jmpop_in, int_wbop_in,
            int_forwardA, int_forwardB, int_cop0_rddata, int_mem_aluresult, int_wb_result,
            int_alu_R, int_alu_Z, int_alu_V)
    begin

        -- default values
        rs <= int_op.rs;
        rt <= int_op.rt;
        pc_out <= int_pc_in;
        memop_out <= int_memop_in;
        jmpop_out <= int_jmpop_in;
        wbop_out <= int_wbop_in;
        exc_ovf <= '0';
        wrdata <= (others => '0');
        zero <= '0';
        neg <= '0';
        new_pc <= (others => '0');

        -- depends on instruction format
        if int_op.regdst = '0' then
            -- R format
            rd <= int_op.rd;
        else
            -- others
            rd <= int_op.rt;
        end if;

            -- ALU
        int_alu_op <= int_op.aluop;
        int_alu_A <= int_op.readdata1;
        aluresult <= int_alu_R;

        -- TODO added due to inferred latch
        int_alu_B <= (others => 'U');

        if int_op.useimm = '0' and int_op.useamt = '0' then
            -- R-Format instructions
            int_alu_B <= int_op.readdata2;
        elsif int_op.useimm = '1' and int_op.useamt = '0' then
            -- all I-Format instructions
            int_alu_B <= int_op.imm;
        elsif int_op.useimm = '0' and int_op.useamt = '1' then
            --- shifts, SLL, SRL, SRA
            int_alu_A <= int_op.readdata2;
                -- shamt will stay at op.imm[5:0]
            int_alu_B <= int_op.imm;
        elsif int_op.cop0 = '1' then
            aluresult <= int_cop0_rddata;
        end if;
        zero <= int_alu_Z;
            -- aluresult
        -- * aluresult <= pc_in (adjusted!? with ALU, see op.link) for jal, jalr instr
        -- * aluresult <= pc_in (adjusted!? with own adder, see op.link) for bltzal, bgtzal instr
            -- assert overflow only when required by instruction

        if int_op.ovf = '1' then
            exc_ovf <= int_op.ovf;
        end if;

            --TODO: how to compute negative flag?
        --neg <= ?? (only with signed data)

        if int_op.branch = '1' then
            assert false report "NOT IMPLEMENTED";
            --new_pc <= std_logic_vector(unsigned(int_pc_in) + unsigned(int_op.imm(new_pc'LENGTH downto 0)));
        end if;
            -- TODO: ignore these signals for lab3
        -- forwardA
        -- forwardB
        -- mem_aluresult
        -- wb_result

end process multiplex;
end rtl;
