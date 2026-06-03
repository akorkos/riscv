LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY imm_select IS
    PORT (
        instr  : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        imm    : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END imm_select;

ARCHITECTURE Behavioral OF imm_select IS
    CONSTANT I : STD_LOGIC_VECTOR(6 DOWNTO 0) := "0010011";
    CONSTANT S : STD_LOGIC_VECTOR(6 DOWNTO 0) := "0100011";
    CONSTANT U : STD_LOGIC_VECTOR(6 DOWNTO 0) := "0110111";
    CONSTANT B : STD_LOGIC_VECTOR(6 DOWNTO 0) := "1100011";
    CONSTANT J : STD_LOGIC_VECTOR(6 DOWNTO 0) := "1101111";
BEGIN
    PROCESS (instr)
    BEGIN
        CASE instr(6 DOWNTO 0) IS
            WHEN I =>
                imm <= (31 DOWNTO 12 => instr(31)) & instr(31 DOWNTO 20);
            WHEN S =>
                imm <= (31 downto 12 => instr(31)) & instr(31 downto 25) & instr(11 downto 7);
            WHEN U =>
                imm <= instr(31 downto 12) & (11 downto 0 => '0');
            WHEN B =>
                imm <= (31 downto 13 => instr(31)) & instr(31) & instr(7) & instr(30 DOWNTO 25) & instr(11 DOWNTO 8) & '0';
            WHEN J =>
                imm <= (31 downto 21 => instr(31)) & instr(31) & instr(19 downto 12) & instr(20) & instr(30 downto 21) & '0';
            WHEN OTHERS    =>
                imm <= (OTHERS => '0');
        END CASE;
    END PROCESS;
END Behavioral;