LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

USE work.riscv_consts.ALL;

ENTITY reg_we IS
    PORT (
        opcode : IN STD_LOGIC_VECTOR (6 DOWNTO 0);
        we     : OUT STD_LOGIC
    );
END reg_we;

ARCHITECTURE Behavioral OF reg_we IS

BEGIN
    PROCESS (opcode)
    BEGIN
        CASE opcode IS
            WHEN Op | OP_IMM | LOAD | AUIPC | JAL | JALR =>
                we <= '1';
            WHEN OTHERS =>
                we <= '0';
        END CASE;
    END PROCESS;
END Behavioral;