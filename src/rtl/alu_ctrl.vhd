LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY alu_ctrl IS
    PORT (
        f3 : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
        f7 : IN STD_LOGIC_VECTOR (6 DOWNTO 0);
        f  : OUT STD_LOGIC_VECTOR (3 DOWNTO 0)
    );
END alu_ctrl;

ARCHITECTURE Behavioral OF alu_ctrl IS
-- TODO: ALU opcode aus funct3 und funct7 generieren
BEGIN
END Behavioral;