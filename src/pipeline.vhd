library ieee;
use ieee.std_logic_1164.all;
use work.core_pack.all;
use work.op_pack.all;

entity pipeline is

    port (
        clk, reset : in     std_logic;
        mem_in     : in  mem_in_type;
        mem_out    : out mem_out_type;
        intr       : in  std_logic_vector(INTR_COUNT-1 downto 0));

end pipeline;

architecture rtl of pipeline is

    signal stall            : std_logic;
    signal flush_decode            : std_logic;
    signal flush_exec            : std_logic;
    signal flush_mem            : std_logic;
    signal flush_wb            : std_logic;

    -- fetch - decode
    signal fd_pc                : std_logic_vector(PC_WIDTH-1 downto 0);
    signal fd_instr         : std_logic_vector(INSTR_WIDTH-1 downto 0);

    -- decode - execute
    signal de_pc        : std_logic_vector(PC_WIDTH-1 downto 0);
    signal de_exec_op   : exec_op_type;
    signal de_jmp_op    : jmp_op_type;
    signal de_mem_op    : mem_op_type;
    signal de_wb_op     : wb_op_type;
    signal de_exec_dec  : std_logic;

    -- execute - memory
    signal em_rd                : std_logic_vector(REG_BITS-1 downto 0);
    signal em_aluresult    : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal em_wrdata        : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal em_zero            : std_logic;
    signal em_neg                : std_logic;
    signal em_new_pc        : std_logic_vector(PC_WIDTH-1 downto 0);
    signal em_pc                : std_logic_vector(PC_WIDTH-1 downto 0);
    signal em_memop            : mem_op_type;
    signal em_jmpop            : jmp_op_type;
    signal em_wbop            : wb_op_type;

    -- memory - write back
    signal mw_memresult : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal mw_pc                : std_logic_vector(PC_WIDTH-1 downto 0);
    signal mw_rd                : std_logic_vector(REG_BITS-1 downto 0);
    signal mw_aluresult : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal mw_wbop            : wb_op_type;

    -- other
    signal fm_pcsrc            : std_logic;
    signal fm_new_pc        : std_logic_vector(PC_WIDTH-1 downto 0);

    signal dw_data        : std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
    signal dw_regwrite  : std_logic := '0';
    signal dw_rd        : std_logic_vector(REG_BITS-1 downto 0) := (others => '0');

    signal aluresult        : std_logic_vector(DATA_WIDTH-1 downto 0);

    signal cop0_op      : cop0_op_type;
    signal cop0_rddata  : std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');

    signal exc_dec            : std_logic;
    signal rs, rt             : std_logic_vector(REG_BITS-1 downto 0);
    signal forwardA            : fwd_type;
    signal forwardB            : fwd_type;

    signal ctrl_pcsrc : std_logic;
    signal ctrl_pc : std_logic_vector(PC_WIDTH-1 downto 0);

    signal exc_ovf : std_logic;
    signal exc_load, exc_store : std_logic;
begin  -- rtl

    piping : process (reset, mem_in.busy) 
    begin
        -- check reset
        if reset = '0' then
            stall <= '0';
        else
            --check if memory is busy
            if mem_in.busy = '1' then
                stall <= '1';
            else
                stall <= '0';
            end if;
        end if;
    end process piping;

    ctrl_inst : entity work.ctrl
        port map (
        --in
            clk => clk,
            reset => reset,
            stall => stall,
            pc_in => fm_new_pc,
            fetch_pc => fd_pc,
            exec_pc => em_pc,
            mem_pc => mw_pc,
            pcsrc_in => fm_pcsrc,
            cop0_op => cop0_op,
            exec_op => de_exec_op,
            exc_ovf => exc_ovf,
            exc_dec => exc_dec,
            exc_load => exc_load,
            exc_store => exc_store,
        --out
            pc_out => ctrl_pc,
            pcsrc_out => ctrl_pcsrc,
            flush_decode => flush_decode,
            flush_exec => flush_exec,
            flush_mem => flush_mem,
            flush_wb => flush_wb,
            cop0_rddata => cop0_rddata
        );

    fwd_inst : entity work.fwd
        port map (
        -- in
            decode_rs => rs,
            decode_rt => rt,
            alu_rd => em_rd,
            wb_rd => mw_rd,
        -- out
            forwardA => forwardA,
            forwardB => forwardB
        );
    
    fetch_inst : entity work.fetch
        port map(
        -- in
            clk => clk,
            reset => reset,
            stall => stall,
            pcsrc => ctrl_pcsrc,
            pc_in => ctrl_pc,
        -- out
            pc_out => fd_pc,
            instr => fd_instr
        );

    decode_inst : entity work.decode
    port map(
    --in
        clk => clk,
        reset => reset,
        stall => stall,
        flush => flush_decode,
        pc_in => fd_pc,
        instr => fd_instr,
        wraddr => dw_rd,
        wrdata => dw_data,
        regwrite => dw_regwrite,
     --out
        pc_out => de_pc,
        exec_op => de_exec_op,
        cop0_op => cop0_op,
        jmp_op => de_jmp_op,
        mem_op => de_mem_op,
        wb_op => de_wb_op,
        exc_dec => exc_dec
    );

    exec_inst : entity work.exec
        port map(
        --in
            clk => clk,
            reset => reset,
            stall => stall,
            flush => flush_exec,
            memop_in => de_mem_op,
            jmpop_in => de_jmp_op,
            op => de_exec_op,
            pc_in => de_pc,
            wbop_in => de_wb_op,
            forwardA => forwardA,
            forwardB => forwardB,
            cop0_rddata => cop0_rddata,
            mem_aluresult => aluresult,
            wb_result => dw_data,

        --out
            pc_out => em_pc,
            rd => em_rd,
            rs => rs,
            rt => rt,
            aluresult => em_aluresult,
            wrdata => em_wrdata,
            zero => em_zero,
            neg => em_neg,
            new_pc => em_new_pc,
            memop_out => em_memop,
            jmpop_out => em_jmpop,
            wbop_out => em_wbop,
            exc_ovf => exc_ovf
        );

        mem_inst : entity work.mem
        port map(
        --in
            clk => clk,
            reset => reset,
            stall => stall,
            flush => flush_mem,
            mem_op => em_memop,
            jmp_op => em_jmpop,
            pc_in => em_pc,
            rd_in => em_rd,
            aluresult_in => em_aluresult,
            wrdata => em_wrdata,
            zero  => em_zero,
            neg => em_neg,
            new_pc_in => em_new_pc,
            wbop_in => em_wbop,
            mem_data => mem_in.rddata,

        --out
            pc_out => mw_pc,
            pcsrc => fm_pcsrc,
            rd_out => mw_rd,
            aluresult_out => aluresult,
            memresult => mw_memresult,
            new_pc_out => fm_new_pc,
            wbop_out => mw_wbop,
            mem_out => mem_out,
            exc_load => exc_load,
            exc_store  => exc_store
        );
        wb_inst : entity work.wb
        port map(
        --in
            clk => clk,
            reset => reset,
            stall => stall,
            flush => flush_wb,
            op => mw_wbop,
            rd_in => mw_rd,
            aluresult => aluresult,
            memresult => mw_memresult,

        --out
            rd_out => dw_rd,
            result => dw_data,
            regwrite => dw_regwrite
        );
end rtl;
