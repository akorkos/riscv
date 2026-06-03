LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY wb_ctrl IS
    PORT (
        opcode : IN STD_LOGIC_VECTOR (6 DOWNTO 0);
        sel    : OUT STD_LOGIC_VECTOR (1 DOWNTO 0)
    );
END wb_ctrl;

ARCHITECTURE Behavioral OF wb_ctrl IS
    CONSTANT R : STD_LOGIC_VECTOR(6 DOWNTO 0) := "0110011";
    CONSTANT I : STD_LOGIC_VECTOR(6 DOWNTO 0) := "0010011";
    CONSTANT U : STD_LOGIC_VECTOR(6 DOWNTO 0) := "0110111";
    CONSTANT J : STD_LOGIC_VECTOR(6 DOWNTO 0) := "1101111";
BEGIN
    PROCESS (opcode)
    BEGIN
        CASE opcode IS
            WHEN R =>
                sel <= "00"; -- alu
            when I =>
                sel <= "00"; -- alu
            -- TODO: sel ist nicht nur von opcode abhängig: lb etc -> mem, lui -> imm, jal -> PC
            WHEN OTHERS =>
                NULL;
        END CASE;
    END PROCESS;
END Behavioral;