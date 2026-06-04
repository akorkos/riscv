LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY instr_rom IS
    PORT (
        addr : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
        rd   : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
    );
END instr_rom;

ARCHITECTURE Behavioral OF instr_rom IS
    TYPE instr_rom_type IS ARRAY(0 TO 50) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
    CONSTANT rom : instr_rom_type := (
        0 => "00000010101000000000000010010011", --addi x1, x0, 42
        -- 1 => "00000000100000000000000100010011", --addi x2, x0, 8
        2 => "00000000000100010000000100010011", --addi x2, x2, 1
        3 => "00000000001100001010000000100011", --sw x3, 0(x1)
        4 => "00000000000000001010001000000011", --lw x4, 0(x1)
        5 => "11111110110111111111001001101111", --jal x4, -20
        OTHERS => (OTHERS => '0')
    );
BEGIN
    rd <= rom(to_integer(unsigned(addr(6 DOWNTO 2))));
END Behavioral;