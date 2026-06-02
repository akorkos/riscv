LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY wb_ctrl IS
    PORT (
        opcode : IN STD_LOGIC_VECTOR (6 DOWNTO 0);
        sel    : OUT STD_LOGIC_VECTOR (1 DOWNTO 0)
    );
END wb_ctrl;

ARCHITECTURE Behavioral OF wb_ctrl IS
-- todo sel signal aus opcode generieren
BEGIN
END Behavioral;