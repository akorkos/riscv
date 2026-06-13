LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

USE work.riscv_consts.ALL;

ENTITY wb_ctrl IS
    PORT (
        opcode : IN STD_LOGIC_VECTOR (6 DOWNTO 0);
        sel    : OUT STD_LOGIC_VECTOR (1 DOWNTO 0)
    );
END wb_ctrl;

ARCHITECTURE Behavioral OF wb_ctrl IS
BEGIN
    PROCESS (opcode)
    BEGIN
        CASE opcode IS
            WHEN OP =>
                sel <= "00"; -- alu
            WHEN OP_IMM =>
                sel <= "00"; -- alu
            WHEN LOAD =>
                sel <= "11"; -- mem
            WHEN LUI =>
                sel <= "10"; -- imm
            WHEN AUIPC =>
                sel <= "00";
            WHEN JAL =>
                sel <= "01"; -- pc+4
            WHEN JALR =>
                sel <= "01"; -- pc+4
            WHEN OTHERS =>
                sel <= "00";
        END CASE;
    END PROCESS;
END Behavioral;