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
        exec_pc : in std_logic_vector(PC_WIDTH-1 downto 0);
        mem_pc : in std_logic_vector(PC_WIDTH-1 downto 0);
        
        cop0_op : in cop0_op_type;
        exec_op : in exec_op_type;

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

        constant ADDR_STATUS : std_logic_vector(4 downto 0) := "01100";
        constant ADDR_CAUSE : std_logic_vector(4 downto 0) := "01101";
        constant ADDR_EPC : std_logic_vector(4 downto 0) := "01110";
        constant ADDR_NPC : std_logic_vector(4 downto 0) := "01111";

        constant EXC_CODE_INTERRUPT : std_logic_vector(3 downto 0) := "0000";
        constant EXC_CODE_LOAD : std_logic_vector(3 downto 0) := "0100";
        constant EXC_CODE_STORE : std_logic_vector(3 downto 0) := "0101";
        constant EXC_CODE_DECODE : std_logic_vector(3 downto 0) := "1010";
        constant EXC_CODE_OVERFLOW : std_logic_vector(3 downto 0) := "1100";

        alias exc_cause : std_logic_vector(3 downto 0) is cause(5 downto 2);
        alias intr_enable : std_logic is status(0);
        alias epc_pc : std_logic_vector(PC_WIDTH-1 downto 0) is epc(PC_WIDTH-1 downto 0);
        alias npc_pc : std_logic_vector(PC_WIDTH-1 downto 0) is npc(PC_WIDTH-1 downto 0);

        signal int_mem_pc : std_logic_vector(PC_WIDTH-1 downto 0);
        signal flush_mem_next : std_logic := '0';

begin  -- rtl


    sync_proc : process(reset, clk, pcsrc_in, mem_pc, stall, flush_mem_next)
    begin
        if reset = '0' then
            int_mem_pc <= (others => '0');
            flush_mem <= '0';
        elsif rising_edge(clk) and stall = '0' then
            if exc_load = '0' and exc_store = '0' then
                int_mem_pc <= mem_pc;
            end if;
            flush_mem <= flush_mem_next;
        end if;
    end process sync_proc;

    cop0_proc : process(all)
    begin
        case cop0_op.addr is
            when ADDR_STATUS =>
                cop0_rddata <= status;
                if cop0_op.wr = '1' then
                    status <= exec_op.readdata1;                        
                end if;
            when ADDR_CAUSE =>
                cop0_rddata <= cause;
                if cop0_op.wr = '1' then
                    cause <= exec_op.readdata1;
                end if;
            when ADDR_EPC =>
                cop0_rddata <= epc;
                if cop0_op.wr = '1' then
                    epc <= exec_op.readdata1;
                end if;
            when ADDR_NPC =>
                cop0_rddata <= npc;
                if cop0_op.wr = '1' then
                    npc <= exec_op.readdata1;
                end if;
            when others =>
                cop0_rddata <= (others => '0');
        end case;

        flush_decode <= '0';
        flush_exec <= '0';
        --flush_mem <= '0';
        flush_wb <= '0';
        flush_mem_next <= '0';
        
        if exc_dec = '1' then
            pcsrc_out <= '1';
            pc_out <= EXCEPTION_PC;
            exc_cause <= EXC_CODE_DECODE;
            epc_pc <= exec_pc;
            flush_exec <= '1';
            flush_mem_next <= '1';
            flush_wb <= '1';
        elsif exc_load = '1' then
            pcsrc_out <= '1';
            pc_out <= EXCEPTION_PC;
            exc_cause <= EXC_CODE_LOAD;
            epc_pc <= int_mem_pc;
            npc_pc <= mem_pc;
            flush_exec <= '1';
            flush_mem_next <= '1';
            --flush_mem <= '1';
            --flush_wb <= '1';
        elsif exc_store = '1' then
            pcsrc_out <= '1';
            pc_out <= EXCEPTION_PC;
            exc_cause <= EXC_CODE_STORE;
            epc_pc <= int_mem_pc;
            npc_pc <= mem_pc;
            flush_exec <= '1';
            --flush_mem <= '1';
            --flush_wb <= '1';
        else
            pcsrc_out <= pcsrc_in;
            pc_out <= pc_in;
            if pcsrc_in = '1' then
                flush_decode <= '1';
            end if;
        end if;
    end process cop0_proc;

--  exc_proc : process(all)
--  begin       
--  end process exc_proc;
end rtl;
