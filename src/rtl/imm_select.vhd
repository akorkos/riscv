LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

USE work.riscv_consts.ALL;

ENTITY imm_select IS
    PORT (
        instr  : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        imm    : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END imm_select;

ARCHITECTURE Behavioral OF imm_select IS
BEGIN
    PROCESS (instr)
    BEGIN
        CASE instr(6 DOWNTO 0) IS
            WHEN OP_IMM|LOAD|JALR =>
                imm <= (31 DOWNTO 12 => instr(31)) & instr(31 DOWNTO 20);
            WHEN STORE =>
                imm <= (31 downto 12 => instr(31)) & instr(31 downto 25) & instr(11 downto 7);
            WHEN LUI|AUIPC =>
                imm <= instr(31 downto 12) & (11 downto 0 => '0');
            WHEN BRANCH =>
                imm <= (31 downto 13 => instr(31)) & instr(31) & instr(7) & instr(30 DOWNTO 25) & instr(11 DOWNTO 8) & '0';
            WHEN JAL =>
                imm <= (31 downto 21 => instr(31)) & instr(31) & instr(19 downto 12) & instr(20) & instr(30 downto 21) & '0';
            WHEN OTHERS  =>
                imm <= (OTHERS => '0');
        END CASE;
    END PROCESS;
END Behavioral;