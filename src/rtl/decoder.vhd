LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY decoder IS -- entscheidet, wohin die daten geschickt werden in abhänägigkeit von der Adresse
    PORT (
        addr    : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        mem_we  : OUT STD_LOGIC;
        uart_we : OUT STD_LOGIC
    );
END ENTITY decoder;

ARCHITECTURE Rtl OF decoder IS
BEGIN
    mem_we  <= '1';
    uart_we <= '1';
    -- TODO: UART-Adresse
END ARCHITECTURE Rtl;