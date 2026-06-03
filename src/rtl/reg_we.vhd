LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY reg_we IS
    PORT (
        opcode : IN STD_LOGIC_VECTOR (6 DOWNTO 0);
        we     : OUT STD_LOGIC
    );
END reg_we;

ARCHITECTURE Behavioral OF reg_we IS
    CONSTANT R : STD_LOGIC_VECTOR(6 DOWNTO 0) := "0110011";
    CONSTANT I : STD_LOGIC_VECTOR(6 DOWNTO 0) := "0010011";
    CONSTANT S : STD_LOGIC_VECTOR(6 DOWNTO 0) := "0100011";
    CONSTANT U : STD_LOGIC_VECTOR(6 DOWNTO 0) := "0110111";
    CONSTANT B : STD_LOGIC_VECTOR(6 DOWNTO 0) := "1100011";
    CONSTANT J : STD_LOGIC_VECTOR(6 DOWNTO 0) := "1101111";

BEGIN
    PROCESS (opcode)
    BEGIN
        CASE opcode IS
            WHEN R =>
                we <= '1';
            WHEN I =>
                we <= '1';
            WHEN U =>
                we <= '1';
            WHEN J =>
                we <= '1';
            WHEN S =>
                we <= '0';
            WHEN B =>
                we <= '0';
            WHEN OTHERS =>
                we <= '0';
        END CASE;
    END PROCESS;
END Behavioral;