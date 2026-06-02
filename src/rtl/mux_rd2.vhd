LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY mux_rd2 IS
    PORT (
        opcode : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
        reg    : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
        imm    : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
        rd2    : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
    );
END mux_rd2;
ARCHITECTURE Behavioral OF mux_rd2 IS
    CONSTANT I : STD_LOGIC_VECTOR(6 DOWNTO 0) := "0010011";
BEGIN
    PROCESS (opcode)
    BEGIN
        IF opcode = I THEN
            rd2 <= imm;
        ELSE
            rd2 <= reg;
        END IF;

    END PROCESS;
END Behavioral;