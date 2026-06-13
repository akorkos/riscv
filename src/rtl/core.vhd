LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY core IS
    PORT (
        reset : IN STD_LOGIC;
        clk   : IN STD_LOGIC;
        clki  : IN STD_LOGIC;

        instr      : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        instr_addr : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);

        mem_data_in  : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        byte_enable  : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        mem_data_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        mem_addr     : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END core;

ARCHITECTURE Behavioral OF core IS
    COMPONENT pc_ctrl IS
        PORT (
            opcode   : IN STD_LOGIC_VECTOR (6 DOWNTO 0);
            f3       : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            br_taken : IN STD_LOGIC;
            sel      : OUT STD_LOGIC_VECTOR (1 DOWNTO 0)
        );
    END COMPONENT;
    COMPONENT mux_pc IS
        PORT (
            sel     : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            pc      : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            rd1     : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            imm     : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            pc_next : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    END COMPONENT;
    COMPONENT register_file IS
        PORT (
            reset : IN STD_LOGIC;
            clk   : IN STD_LOGIC;
            clki  : IN STD_LOGIC;

            rs1 : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
            rs2 : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
            rd1 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            rd2 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);

            we : IN STD_LOGIC;
            wa : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
            wd : IN STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    END COMPONENT;
    COMPONENT reg_we IS
        PORT (
            opcode : IN STD_LOGIC_VECTOR (6 DOWNTO 0);
            we     : OUT STD_LOGIC
        );
    END COMPONENT;
    COMPONENT imm_select IS
        PORT (
            instr  : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            imm    : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            opcode : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
        );
    END COMPONENT;
    COMPONENT branch_logic IS
        PORT (
            reg1   : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            reg2   : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            br_sel : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            br_out : OUT STD_LOGIC -- branch taken -> 1, 0 for not taken
        );
    END COMPONENT;
    COMPONENT mux_rd2 IS
        PORT (
            opcode : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
            reg    : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            imm    : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            rd2    : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    END COMPONENT;
    COMPONENT alu_ctrl IS
        PORT (
            opcode : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
            f3     : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            f7     : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
            f      : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
        );
    END COMPONENT;
    COMPONENT alu IS
        PORT (
            A : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            B : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            F : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            R : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    END COMPONENT;
    COMPONENT wb_ctrl IS
        PORT (
            opcode : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
            sel    : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
        );
    END COMPONENT;
    COMPONENT mux_wb IS
        PORT (
            alu_in      : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            pc          : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            imm         : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            wb_sel      : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            mem_data_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0); -- Memory data input
            wb_out      : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    END COMPONENT;
    COMPONENT read_ctrl IS
        PORT (
            mem_data_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            opcode      : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
            f3          : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            mem_wb_data : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    END COMPONENT;
    COMPONENT write_ctrl IS
        PORT (
            opcode      : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
            f3          : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            byte_enable : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
        );
    END COMPONENT;

    SIGNAL pc      : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL pc_next : STD_LOGIC_VECTOR(31 DOWNTO 0);

    SIGNAL pc_sel : STD_LOGIC_VECTOR(1 DOWNTO 0);

    SIGNAL rd1 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL rd2 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL we  : STD_LOGIC;

    SIGNAL imm : STD_LOGIC_VECTOR(31 DOWNTO 0);

    SIGNAL br_taken : STD_LOGIC;

    SIGNAL o2      : STD_LOGIC_VECTOR(31 DOWNTO 0); -- alu operand 2
    SIGNAL f       : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL alu_res : STD_LOGIC_VECTOR(31 DOWNTO 0);

    SIGNAL wb_sel : STD_LOGIC_VECTOR(1 DOWNTO 0);

    SIGNAL wd : STD_LOGIC_VECTOR(31 DOWNTO 0);

    SIGNAL mem_wb_data : STD_LOGIC_VECTOR(31 DOWNTO 0);

BEGIN
    pc_ctrl_comp : ENTITY work.pc_ctrl
        PORT MAP(
            opcode   => instr(6 DOWNTO 0),
            f3       => instr(14 DOWNTO 12),
            br_taken => br_taken,
            sel      => pc_sel
        );
    mux_pc_comp : ENTITY work.mux_pc
        PORT MAP(
            sel     => pc_sel,
            pc      => pc,
            rd1     => rd1,
            imm     => imm,
            pc_next => pc_next
        );
    register_file_comp : ENTITY work.register_file
        PORT MAP(
            reset => reset,
            clk   => clk,
            -- clki  => clki,
            rs1   => instr(19 DOWNTO 15),
            rs2   => instr(24 DOWNTO 20),
            rd1   => rd1,
            rd2   => rd2,
            we    => we,
            wa    => instr(11 DOWNTO 7),
            wd    => wd
        );
    reg_we_comp : ENTITY work.reg_we
        PORT MAP(
            opcode => instr(6 DOWNTO 0),
            we     => we
        );
    imm_select_comp : ENTITY work.imm_select
        PORT MAP(
            instr => instr,
            imm   => imm
        );
    branch_logic_comp : ENTITY work.branch_logic
        PORT MAP(
            reg1   => rd1,
            reg2   => rd2,
            br_sel => instr(14 DOWNTO 12),
            br_out => br_taken
        );
    mux_rd2_comp : ENTITY work.mux_rd2
        PORT MAP(
            opcode => instr(6 DOWNTO 0),
            reg    => rd2,
            imm    => imm,
            rd2    => o2
        );
    alu_ctrl_comp : ENTITY work.alu_ctrl
        PORT MAP(
            opcode => instr(6 DOWNTO 0),
            f3     => instr(14 DOWNTO 12),
            f7     => instr(31 DOWNTO 25),
            f      => f
        );
    alu_comp : ENTITY work.alu
        PORT MAP(
            A => rd1,
            B => o2,
            F => f,
            R => alu_res
        );
    wb_ctrl_comp : ENTITY work.wb_ctrl
        PORT MAP(
            opcode => instr(6 DOWNTO 0),
            sel    => wb_sel
        );
    mux_wb_comp : ENTITY work.mux_wb
        PORT MAP(
            alu_in      => alu_res,
            pc          => pc,
            imm         => imm,
            wb_sel      => wb_sel,
            mem_data_in => mem_wb_data,
            wb_out      => wd
        );
    read_ctrl_comp : ENTITY work.read_ctrl
        PORT MAP(
            mem_data_in => mem_data_in,
            opcode      => instr(6 DOWNTO 0),
            f3          => instr(14 DOWNTO 12),
            mem_wb_data => mem_wb_data
        );
    write_ctrl_comp : ENTITY work.write_ctrl
        PORT MAP(
            opcode      => instr(6 DOWNTO 0),
            f3          => instr(14 DOWNTO 12),
            byte_enable => byte_enable
        );

    instr_addr   <= pc;
    mem_addr     <= alu_res;
    mem_data_out <= rd2;

    PROCESS (clk)
    BEGIN
        IF rising_edge(clk) THEN
            IF reset = '1' THEN
                pc <= (OTHERS => '0');
            ELSE
                pc <= pc_next;
            END IF;

        END IF;
    END PROCESS;
END Behavioral;