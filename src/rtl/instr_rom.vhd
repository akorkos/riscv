LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY instr_rom IS
    PORT (
        addr : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
        rd   : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
    );
END instr_rom;

ARCHITECTURE Behavioral OF instr_rom IS
    -- TODO
BEGIN
END Behavioral;