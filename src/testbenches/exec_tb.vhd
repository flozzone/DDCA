library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.op_pack.all;
use work.core_pack.all;
use work.exec;

entity exec_tb is
end exec_tb;

architecture arch of exec_tb is
    constant CLK_PERIOD : time := 2 ps;

    signal s_clk, s_reset     : std_logic;
    signal s_stall                 : std_logic;
    signal s_flush            : std_logic;
    signal s_pc_in            : std_logic_vector(PC_WIDTH-1 downto 0);
    signal s_op                    : exec_op_type;
    signal r_pc_out           : std_logic_vector(PC_WIDTH-1 downto 0);
    signal r_rd, r_rs, r_rt   : std_logic_vector(REG_BITS-1 downto 0);
    signal r_aluresult           : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal r_wrdata           : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal r_zero, r_neg      : std_logic;
    signal r_new_pc           : std_logic_vector(PC_WIDTH-1 downto 0);
    signal s_memop_in         : mem_op_type;
    signal r_memop_out        : mem_op_type;
    signal s_jmpop_in         : jmp_op_type;
    signal r_jmpop_out        : jmp_op_type;
    signal s_wbop_in          : wb_op_type;
    signal r_wbop_out         : wb_op_type;
    signal s_forwardA         : fwd_type;
    signal s_forwardB         : fwd_type;
    signal s_cop0_rddata      : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal s_mem_aluresult    : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal s_wb_result        : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal r_exc_ovf          : std_logic;



    signal a_pc_out           : std_logic_vector(PC_WIDTH-1 downto 0);
    signal a_rd, a_rs, a_rt   : std_logic_vector(REG_BITS-1 downto 0);
    signal a_aluresult           : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal a_wrdata           : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal a_zero, a_neg      : std_logic;
    signal a_new_pc           : std_logic_vector(PC_WIDTH-1 downto 0);
    signal a_memop_out        : mem_op_type;
    signal a_jmpop_out        : jmp_op_type;
    signal a_wbop_out         : wb_op_type;
    signal a_exc_ovf          : std_logic;

  signal testfile : string(8 downto 1);

begin
	s_reset <= '1';

    exec_inst : entity exec
    port map (
        clk => s_clk,
        reset => s_reset,
        stall => s_stall,
        flush => s_flush,
        pc_in => s_pc_in,
        op => s_op,
        pc_out => r_pc_out,
        rd => r_rd,
        rs => r_rs,
        rt => r_rt,
        aluresult => r_aluresult,
        wrdata => r_wrdata,
        zero => r_zero,
        neg => r_neg,
        new_pc => r_new_pc,
        memop_in => s_memop_in,
        memop_out => r_memop_out,
        jmpop_in => s_jmpop_in,
        jmpop_out => r_jmpop_out,
        wbop_in => s_wbop_in,
        wbop_out => r_wbop_out,
        forwardA => s_forwardA,
        forwardB => s_forwardB,
        cop0_rddata => s_cop0_rddata,
        mem_aluresult => s_mem_aluresult,
        wb_result => s_wb_result,
        exc_ovf => r_exc_ovf
    );

	clk_proc : process
	begin
	wait for CLK_PERIOD/2;
	s_clk <= '1';
	wait for CLK_PERIOD/2;
	s_clk <= '0';
	end process clk_proc;

    test : process
    begin
		s_flush <= '0';
		s_stall <= '0';
		s_pc_in <= std_logic_vector(to_unsigned(5, PC_WIDTH));
		s_op.imm <= std_logic_vector(to_signed(-2, DATA_WIDTH));
		s_op.branch <= '1';

        wait for 1 ns;

        assert r_new_pc = a_new_pc report testfile & ": r_new_pc is not equal";

        wait for 1 ps;

    end process test;
end arch;