LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY core IS
    PORT (
        clk   : IN STD_LOGIC;
        instr : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        res   : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
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
    COMPONENT imm_select IS
        PORT (
            instr  : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            imm    : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            opcode : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
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
    COMPONENT alur_ctrl IS
        PORT (
            f3 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            f7 : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
            f  : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
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

    SIGNAL rs1 : STD_LOGIC_VECTOR(4 DOWNTO 0);
    SIGNAL rs2 : STD_LOGIC_VECTOR(4 DOWNTO 0);
    SIGNAL rd2 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL we  : STD_LOGIC;
    SIGNAL wa  : STD_LOGIC_VECTOR(4 DOWNTO 0);
    SIGNAL wd  : STD_LOGIC_VECTOR(31 DOWNTO 0);

    SIGNAL opcode : STD_LOGIC_VECTOR(6 DOWNTO 0);
    SIGNAL imm    : STD_LOGIC_VECTOR(31 DOWNTO 0);

    SIGNAL o1      : STD_LOGIC_VECTOR(31 DOWNTO 0); -- alu operand 1
    SIGNAL o2      : STD_LOGIC_VECTOR(31 DOWNTO 0); -- alu operand 2
    SIGNAL f       : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL alu_res : STD_LOGIC_VECTOR(31 DOWNTO 0);

    SIGNAL wb_sel : STD_LOGIC_VECTOR(1 DOWNTO 0);

    SIGNAL pc4     : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL mem_data_in : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL wb_val  : STD_LOGIC_VECTOR(31 DOWNTO 0);

BEGIN
    register_file_comp : ENTITY work.register_file
        PORT MAP(
            clk => clk,
            rs1 => instr(19 DOWNTO 15),
            rs2 => instr(24 DOWNTO 20),
            rd1 => o1,
            rd2 => rd2,
            we  => we,
            wa  => instr(11 DOWNTO 7),
            wd  => wb_val
        );
    imm_select_comp : ENTITY work.imm_select
        PORT MAP(
            instr => instr,
            imm   => imm
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
            f3 => instr(14 DOWNTO 12),
            f7 => instr(31 DOWNTO 25),
            f  => f
        );
    alu_comp : ENTITY work.alu
        PORT MAP(
            A => o1,
            B => o2,
            F => f,
            R => alu_res
        );
    wb_ctrl_inst : ENTITY work.wb_ctrl
        PORT MAP(
            opcode => instr(6 DOWNTO 0),
            sel    => wb_sel
        );
    mux_wb_inst: entity work.mux_wb
     port map(
        alu_in => alu_res,
        pc4 => pc4,
        imm => imm,
        wb_sel => wb_sel,
        mem_data_in => mem_data_in,
        wb_out => wb_val
    );

    res <= alu_res;
END Behavioral;