LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

USE work.riscv_consts.ALL;

ENTITY pc_ctrl IS
    PORT (
        opcode   : IN STD_LOGIC_VECTOR (6 DOWNTO 0);
        f3       : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        br_taken : IN STD_LOGIC;
        sel      : OUT STD_LOGIC_VECTOR (1 DOWNTO 0));
END pc_ctrl;

ARCHITECTURE Behavioral OF pc_ctrl IS
BEGIN
    PROCESS (opcode, br_taken)
    BEGIN
        IF opcode = BRANCH AND br_taken = '1' THEN
            sel <= "01";
        ELSIF opcode = JAL THEN
            sel <= "10";
        ELSIF opcode = JALR AND f3 = "000" THEN
            sel <= "11";
        ELSE
            sel <= "00";
        END IF;
    END PROCESS;
END Behavioral;