LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY core IS
    PORT (
        reset : IN STD_LOGIC;
        clk   : IN STD_LOGIC;

        instr      : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        instr_addr : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);

        mem_data_in  : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        byte_enable  : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        mem_data_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        mem_addr     : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END core;

ARCHITECTURE Behavioral OF core IS
    COMPONENT register_file IS
        PORT (
            clk : IN STD_LOGIC;
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
            sel    : IN STD_LOGIC_VECTOR(1 DOWNTO 0)
        );
    END COMPONENT;
    COMPONENT mux_wb IS
        PORT (
            alu_in      : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            pc4         : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
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

    SIGNAL instr_reg : STD_LOGIC_VECTOR(31 DOWNTO 0);

    SIGNAL rd1 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL rd2 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL we  : STD_LOGIC;

    SIGNAL imm : STD_LOGIC_VECTOR(31 DOWNTO 0);

    SIGNAL br_taken : STD_LOGIC;

    SIGNAL o2      : STD_LOGIC_VECTOR(31 DOWNTO 0); -- alu operand 2
    SIGNAL f       : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL alu_res : STD_LOGIC_VECTOR(31 DOWNTO 0);

    SIGNAL wb_sel : STD_LOGIC_VECTOR(1 DOWNTO 0);

    SIGNAL pc4 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL wd  : STD_LOGIC_VECTOR(31 DOWNTO 0);

    SIGNAL mem_wb_data : STD_LOGIC_VECTOR(31 DOWNTO 0);

BEGIN
    register_file_comp : ENTITY work.register_file
        PORT MAP(
            clk => clk,
            rs1 => instr_reg(19 DOWNTO 15),
            rs2 => instr_reg(24 DOWNTO 20),
            rd1 => rd1,
            rd2 => rd2,
            we  => we,
            wa  => instr_reg(11 DOWNTO 7),
            wd  => wd
        );
    reg_we_comp : ENTITY work.reg_we
        PORT MAP(
            opcode => instr_reg(6 DOWNTO 0),
            we     => we
        );
    imm_select_comp : ENTITY work.imm_select
        PORT MAP(
            instr => instr_reg,
            imm   => imm
        );
    branch_logic_inst : ENTITY work.branch_logic
        PORT MAP(
            reg1   => rd1,
            reg2   => rd2,
            br_sel => instr_reg(14 DOWNTO 12),
            br_out => br_taken
        );
    mux_rd2_comp : ENTITY work.mux_rd2
        PORT MAP(
            opcode => instr_reg(6 DOWNTO 0),
            reg    => rd2,
            imm    => imm,
            rd2    => o2
        );
    alu_ctrl_comp : ENTITY work.alu_ctrl
        PORT MAP(
            opcode => instr_reg(6 DOWNTO 0),
            f3     => instr_reg(14 DOWNTO 12),
            f7     => instr_reg(31 DOWNTO 25),
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
            opcode => instr_reg(6 DOWNTO 0),
            sel    => wb_sel
        );
    mux_wb_comp : ENTITY work.mux_wb
        PORT MAP(
            alu_in      => alu_res,
            pc4         => pc4,
            imm         => imm,
            wb_sel      => wb_sel,
            mem_data_in => mem_wb_data,
            wb_out      => wd
        );
    read_ctrl_inst : ENTITY work.read_ctrl
        PORT MAP(
            mem_data_in => mem_data_in,
            opcode      => instr_reg(6 DOWNTO 0),
            f3          => instr_reg(14 DOWNTO 12),
            mem_wb_data => mem_wb_data
        );
    write_ctrl_inst : ENTITY work.write_ctrl
        PORT MAP(
            opcode      => instr_reg(6 DOWNTO 0),
            f3          => instr_reg(14 DOWNTO 12),
            byte_enable => byte_enable
        );

    mem_addr     <= alu_res;
    mem_data_out <= rd2;
    PROCESS (clk)
    BEGIN
        IF rising_edge(clk) THEN
            instr_reg <= instr;
        END IF;
    END PROCESS;
END Behavioral;