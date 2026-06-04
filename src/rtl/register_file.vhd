LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY register_file IS
    PORT (
        reset : IN STD_LOGIC;
        clk   : IN STD_LOGIC;
        rs1   : IN STD_LOGIC_VECTOR(4 DOWNTO 0);   -- operand read address 1
        rs2   : IN STD_LOGIC_VECTOR(4 DOWNTO 0);   -- operand read address 2
        rd1   : OUT STD_LOGIC_VECTOR(31 DOWNTO 0); -- register data 1
        rd2   : OUT STD_LOGIC_VECTOR(31 DOWNTO 0); -- register data 2

        we : IN STD_LOGIC;                    -- write enable
        wa : IN STD_LOGIC_VECTOR(4 DOWNTO 0); -- write address
        wd : IN STD_LOGIC_VECTOR(31 DOWNTO 0) -- write data
    );
END register_file;

ARCHITECTURE Behavioral OF register_file IS
    TYPE registerFile IS ARRAY(0 TO 31) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL registers : registerFile := (OTHERS => (OTHERS => '0'));
BEGIN

    rd1 <= (OTHERS => '0') WHEN rs1 = "00000"
        ELSE
        registers(to_integer(unsigned(rs1)));

    rd2 <= (OTHERS => '0') WHEN rs2 = "00000"
        ELSE
        registers(to_integer(unsigned(rs2)));

    PROCESS (clk)
    BEGIN
        IF rising_edge(clk) THEN
            IF we = '1' AND wa /= "00000" THEN
                registers(to_integer(unsigned(wa))) <= wd;
            END IF;
        END IF;
    END PROCESS;
END Behavioral;