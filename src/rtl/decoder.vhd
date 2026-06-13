LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY decoder IS -- entscheidet, wohin die daten geschickt werden in abhänägigkeit von der Adresse
    PORT (
        addr    : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        mem_we  : OUT STD_LOGIC;
        uart_we : OUT STD_LOGIC;
        led_we  : OUT STD_LOGIC
    );
END ENTITY decoder;

ARCHITECTURE rtl OF decoder IS
    CONSTANT led_addr  : UNSIGNED(31 DOWNTO 0) := x"02000000";
    CONSTANT uart_addr : UNSIGNED(31 DOWNTO 0) := x"02000004";
BEGIN
    PROCESS (addr)
        VARIABLE a : UNSIGNED(31 DOWNTO 0);
    BEGIN
        a := UNSIGNED(addr);

        mem_we  <= '0';
        led_we  <= '0';
        uart_we <= '0';

        IF a < led_addr THEN
            mem_we <= '1';
        ELSIF a < uart_addr THEN
            led_we  <= '1';
        ELSIF a <= uart_addr + 4 THEN
            uart_we <= '1';
        END IF;
    END PROCESS;
END ARCHITECTURE;