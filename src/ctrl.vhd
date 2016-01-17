library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.core_pack.all;
use work.op_pack.all;

entity ctrl is

    port (
        clk : in std_logic;
        reset : in std_logic;
        stall : in std_logic;
        pcsrc_in : in std_logic;
        pc_in : in std_logic_vector(PC_WIDTH-1 downto 0);
        fetch_pc : in std_logic_vector(PC_WIDTH-1 downto 0);
        exec_pc : in std_logic_vector(PC_WIDTH-1 downto 0);
        mem_pc : in std_logic_vector(PC_WIDTH-1 downto 0);
        
        cop0_op : in cop0_op_type;
        exec_op : in exec_op_type;

        exc_ovf : std_logic;
        exc_dec : std_logic;
        exc_load : std_logic;
        exc_store : std_logic;

        pcsrc_out : out std_logic;
        pc_out : out std_logic_vector(PC_WIDTH-1 downto 0);

        flush_decode : out std_logic;
        flush_exec : out std_logic;
        flush_mem : out std_logic;
        flush_wb : out std_logic;

        cop0_rddata : out std_logic_vector(DATA_WIDTH-1 downto 0));

end ctrl;

architecture rtl of ctrl is

        signal status : std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
        signal cause : std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
        signal epc : std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
        signal npc : std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');

        signal status_next : std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
        signal cause_next : std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
        signal epc_next : std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
        signal npc_next : std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');

        constant ADDR_STATUS : std_logic_vector(4 downto 0) := "01100";
        constant ADDR_CAUSE : std_logic_vector(4 downto 0) := "01101";
        constant ADDR_EPC : std_logic_vector(4 downto 0) := "01110";
        constant ADDR_NPC : std_logic_vector(4 downto 0) := "01111";

        constant EXC_CODE_INTERRUPT : std_logic_vector(3 downto 0) := "0000";
        constant EXC_CODE_LOAD : std_logic_vector(3 downto 0) := "0100";
        constant EXC_CODE_STORE : std_logic_vector(3 downto 0) := "0101";
        constant EXC_CODE_DECODE : std_logic_vector(3 downto 0) := "1010";
        constant EXC_CODE_OVERFLOW : std_logic_vector(3 downto 0) := "1100";

        alias exc_cause : std_logic_vector(3 downto 0) is cause_next(5 downto 2);
        alias intr_enable : std_logic is status(0);
        alias epc_pc : std_logic_vector(PC_WIDTH-1 downto 0) is epc_next(PC_WIDTH-1 downto 0);
        alias npc_pc : std_logic_vector(PC_WIDTH-1 downto 0) is npc_next(PC_WIDTH-1 downto 0);
        alias is_bds : std_logic is cause_next(31);

        signal flush_mem_next : std_logic := '0';
        signal is_exc : boolean := false;
        signal is_branch_last : std_logic := '0';
        signal is_branch_before_last : std_logic := '0';
        signal int_pc_in : std_logic_vector(PC_WIDTH-1 downto 0);
        signal int_pcsrc_in : std_logic;
        signal int_old_pcsrc_in : std_logic;

        signal int_exec_op : exec_op_type;
        signal int_exc_dec : std_logic;
        signal int_exc_load : std_logic;
        signal int_exc_store : std_logic;
        signal int_exc_ovf : std_logic;
        signal int_fetch_pc : std_logic_vector(PC_WIDTH-1 downto 0);
        signal int_mem_pc : std_logic_vector(PC_WIDTH-1 downto 0);
        signal int_old_mem_pc : std_logic_vector(PC_WIDTH-1 downto 0);
        signal int_exec_pc : std_logic_vector(PC_WIDTH-1 downto 0);

begin  -- rtl


    sync_proc : process(reset, clk, stall)
        variable is_branch :std_logic  := '0';
    begin
        if reset = '0' then
            status <= (others => '0');
            cause <= (others => '0');
            npc <= (others => '0');
            epc <= (others => '0');
            is_branch := '0';
            is_branch_last <= '0';
            is_branch_before_last <= '0';
            int_pc_in <= (others => '0');
            int_pcsrc_in <= '0';
            int_old_pcsrc_in <= '0';
            int_exc_dec <= '0';
            int_exc_load <= '0';
            int_exc_store <= '0';
            int_exc_ovf <= '0';
            int_fetch_pc <= (others => '0');
            int_mem_pc <= (others => '0');
            int_old_mem_pc <= (others => '0');
            int_exec_pc <= (others => '0');
            int_exec_op <= EXEC_NOP;
        elsif rising_edge(clk) and stall = '0' then
            is_branch_before_last <= is_branch_last;
            is_branch_last <= is_branch;
            -- remember Branch delay slot (BDS) in local variable
            is_branch := int_exec_op.branch;
            status <= status_next;
            cause <= cause_next;
            npc <= npc_next;
            epc <= epc_next;
            int_exec_op <= exec_op;
            int_pcsrc_in <= pcsrc_in;
            int_old_pcsrc_in <= int_pcsrc_in;
            int_pc_in <= pc_in;
            int_exc_dec <= exc_dec;
            int_exc_load <= exc_load;
            int_exc_store <= exc_store;
            int_exc_ovf <= exc_ovf;
            int_fetch_pc <= fetch_pc;
            int_mem_pc <= mem_pc;
            int_old_mem_pc <= int_mem_pc;
            int_exec_pc <= exec_pc;
        end if;
    end process sync_proc;

    cop0_proc : process(all)
    begin
        case cop0_op.addr is
            when ADDR_STATUS =>
                cop0_rddata <= status;
                if cop0_op.wr = '1' then
                    status_next <= exec_op.readdata1;                        
                end if;
            when ADDR_CAUSE =>
                cop0_rddata <= cause;
                if cop0_op.wr = '1' then
                    cause_next <= exec_op.readdata1;
                end if;
            when ADDR_EPC =>
                cop0_rddata <= epc;
                if cop0_op.wr = '1' then
                    epc_next <= exec_op.readdata1;
                end if;
            when ADDR_NPC =>
                cop0_rddata <= npc;
                if cop0_op.wr = '1' then
                    npc_next <= exec_op.readdata1;
                end if;
            when others =>
                cop0_rddata <= (others => '0');
        end case;

        flush_decode <= '0';
        flush_exec <= '0';
        flush_mem <= '0';
        flush_wb <= '0';
        flush_mem_next <= '0';

        if int_exc_dec = '1' or int_exc_load = '1' or 
                int_exc_store = '1' or int_exc_ovf = '1' then

            pcsrc_out <= '1';
            pc_out <= EXCEPTION_PC;
        end if;
        
        if int_exc_dec = '1' then
            exc_cause <= EXC_CODE_DECODE;
            epc_pc <= int_exec_pc;
            flush_exec <= '1';
            flush_mem <= '1';
            flush_wb <= '1';
        elsif int_exc_load = '1' then
            exc_cause <= EXC_CODE_LOAD;

            epc_pc <= int_old_mem_pc;
            npc_pc <= int_mem_pc;
            if is_branch_before_last = '1' then
                is_bds <= '1';
                if int_old_pcsrc_in = '1' then
                    npc_pc <= int_exec_pc;
                end if;
            end if;

            flush_exec <= '1';
            flush_mem <= '1';
        elsif int_exc_store = '1' then
            exc_cause <= EXC_CODE_STORE;

            epc_pc <= int_old_mem_pc;
            npc_pc <= int_mem_pc;
            if is_branch_before_last = '1' then
                is_bds <= '1';
                if int_old_pcsrc_in = '1' then
                    npc_pc <= int_exec_pc;
                end if;
            end if;

            flush_exec <= '1';
            flush_mem <= '1';
        elsif int_exc_ovf = '1' then
            exc_cause <= EXC_CODE_OVERFLOW;

            epc_pc <= int_mem_pc;

            npc_pc <= int_exec_pc;
            if is_branch_last = '1' then
                -- BDS instruction
                is_bds <= '1';
                
                -- branch taken
                if int_pcsrc_in = '1' then
                    npc_pc <= int_pc_in;
                end if;
            end if;

            -- flush exec and decode so that
            -- calculated value that caused the exception
            -- doesn't get written back to registers.
            flush_exec <= '1';
            flush_mem <= '1';
        else
            pcsrc_out <= pcsrc_in;
            pc_out <= pc_in;
            if pcsrc_in = '1' then
                flush_decode <= '1';
            end if;
        end if;
    end process cop0_proc;
end rtl;
