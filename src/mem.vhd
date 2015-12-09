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
signal int_zero, int_neg : std_logic;
signal int_new_pc_in     : std_logic_vector(PC_WIDTH-1 downto 0);
signal int_wbop_in       : wb_op_type;
signal int_mem_data      : std_logic_vector(DATA_WIDTH-1 downto 0);

signal int_jmp_J, int_jmp_zero, int_jmp_neg : std_logic;

signal int_memu_A : std_logic_vector(ADDR_WIDTH-1 downto 0);
signal int_memu_W, int_memu_D, int_memu_R : std_logic_vector(DATA_WIDTH-1 downto 0);
signal int_memu_M : mem_out_type;
signal int_memu_XL, int_memu_XS : std_logic;

begin  -- rtl

    jmpu_inst : entity jmpu
    port map (
        -- in
        op => int_jmp_op,
        N => int_jmp_zero,
        Z => int_jmp_neg,
        --out
        J => int_jmp_J
    );

    memu_inst : entity memu
    port map (
        -- in
        op => int_mem_op,
        A => int_memu_A,
        W => int_memu_W,
        D => int_memu_D,
        -- out
        M => int_memu_M,
        R => int_memu_R,
        XL => int_memu_XL,
        XS => int_memu_XS
    );

    input : process(clk, reset)
    begin
        if reset = '0' then
            int_mem_op <= MEM_NOP;
            int_jmp_op <= JMP_NOP;
            int_pc_in <= (others => '0');
            int_rd_in <= (others => '0');
            int_aluresult_in <= (others => '0');
            int_wrdata  <= (others => '0');
            int_zero <= '0';
            int_neg <= '0';
            int_new_pc_in <= (others => '0');
            int_wbop_in <= WB_NOP;
            int_mem_data <= (others => '0');
        elsif rising_edge(clk) then
            if flush = '1' then
                int_mem_op <= MEM_NOP;
                int_jmp_op <= JMP_NOP;
                int_pc_in <= (others => '0');
                int_rd_in <= (others => '0');
                int_aluresult_in <= (others => '0');
                int_wrdata  <= (others => '0');
                int_zero <= '0';
                int_neg <= '0';
                int_new_pc_in <= (others => '0');
                int_wbop_in <= WB_NOP;
                int_mem_data <= (others => '0');
            elsif stall = '0' then
                int_mem_op <= mem_op;
                int_jmp_op <= jmp_op;
                int_pc_in <= pc_in;
                int_rd_in <= rd_in;
                int_aluresult_in <= aluresult_in;
                int_wrdata  <= wrdata;
                int_zero <= zero;
                int_neg <= neg;
                int_new_pc_in <= new_pc_in;
                int_wbop_in <= wbop_in;
                int_mem_data <= mem_data;
            end if;
        end if;
    end process input;

    mem_proc : process(int_pc_in, int_rd_in,
        int_aluresult_in, int_wrdata, int_zero, int_neg, int_new_pc_in, int_wbop_in, int_mem_data,
        int_memu_M, int_memu_R, int_memu_XL, int_memu_XS, int_jmp_J)
    begin
        -- pass unchanged signals
        pc_out <= int_pc_in;
        rd_out <= int_rd_in;
        aluresult_out <= int_aluresult_in;
        new_pc_out <= int_new_pc_in;
        wbop_out <= int_wbop_in;

            -- jump
        int_jmp_neg <= int_neg;
        int_jmp_zero <= int_zero;
        pcsrc <= int_jmp_J;

            -- memu
        int_memu_A <= int_aluresult_in(ADDR_WIDTH-1 downto 0);
        int_memu_W <= int_wrdata;
        int_memu_D <= int_mem_data;
        mem_out <= int_memu_M;
        memresult <= int_memu_R;
        exc_load <= int_memu_XL;
        exc_store <= int_memu_XS;
    end process mem_proc;
end rtl;
