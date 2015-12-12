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

signal int_mem_op        : mem_op_type;
signal int_jmp_op        : jmp_op_type;
signal int_pc_in         : std_logic_vector(PC_WIDTH-1 downto 0);
signal int_rd_in         : std_logic_vector(REG_BITS-1 downto 0);
signal int_aluresult_in  : std_logic_vector(DATA_WIDTH-1 downto 0);
signal int_wrdata        : std_logic_vector(DATA_WIDTH-1 downto 0);
signal int_new_pc_in     : std_logic_vector(PC_WIDTH-1 downto 0);
signal int_wbop_in       : wb_op_type;

signal int_jmp_zero, int_jmp_neg : std_logic;

begin  -- rtl

    jmpu_inst : entity jmpu
    port map (
        -- in
        op => int_jmp_op,
        N => int_jmp_neg,
        Z => int_jmp_zero,
        --out
        J => pcsrc
    );

    memu_inst : entity memu
    port map (
        -- in
        op => int_mem_op,
        A => int_aluresult_in(ADDR_WIDTH-1 downto 0),
        W => int_wrdata,
        D => mem_data,
        -- out
        M => mem_out,
        R => memresult,
        XL => exc_load,
        XS => exc_store
    );

    input : process(clk, reset, stall)
    begin
        if reset = '0' then
            int_mem_op <= MEM_NOP;
            int_jmp_op <= JMP_NOP;
            int_pc_in <= (others => '0');
            int_rd_in <= (others => '0');
            int_aluresult_in <= (others => '0');
            int_wrdata  <= (others => '0');
            int_jmp_zero <= '0';
            int_jmp_neg <= '0';
            int_new_pc_in <= (others => '0');
            int_wbop_in <= WB_NOP;
        elsif stall = '1' then
            int_mem_op.memread <= '0';
            int_mem_op.memwrite <= '0';
        elsif rising_edge(clk) then
            if flush = '1' then
                int_mem_op <= MEM_NOP;
                int_jmp_op <= JMP_NOP;
                int_pc_in <= (others => '0');
                int_rd_in <= (others => '0');
                int_aluresult_in <= (others => '0');
                int_wrdata  <= (others => '0');
                int_jmp_zero <= '0';
                int_jmp_neg <= '0';
                int_new_pc_in <= (others => '0');
                int_wbop_in <= WB_NOP;
            else
                int_mem_op <= mem_op;
                int_jmp_op <= jmp_op;
                int_pc_in <= pc_in;
                int_rd_in <= rd_in;
                int_aluresult_in <= aluresult_in;
                int_wrdata  <= wrdata;
                int_jmp_zero <= zero;
                int_jmp_neg <= neg;
                int_new_pc_in <= new_pc_in;
                int_wbop_in <= wbop_in;
            end if;
        end if;
    end process input;

    mem_proc : process(int_pc_in, int_rd_in, int_aluresult_in, int_new_pc_in, int_wbop_in)
    begin
        -- pass unchanged signals
        pc_out <= int_pc_in;
        rd_out <= int_rd_in;
        aluresult_out <= int_aluresult_in;
        new_pc_out <= int_new_pc_in;
        wbop_out <= int_wbop_in;
    end process mem_proc;
end rtl;
