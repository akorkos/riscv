LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY ram IS
    PORT (
        clk         : IN STD_LOGIC;
        addr        : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        din         : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        dout        : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        we          : IN STD_LOGIC;
        byte_enable : IN STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE rtl OF ram IS
    TYPE ram_type IS ARRAY (0 TO (2 ** 10) - 1) OF STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL RAM : ram_type := (OTHERS => (OTHERS => '0'));
BEGIN

    PROCESS (clk)
        VARIABLE a : INTEGER;
    BEGIN
        IF rising_edge(clk) THEN

            a := to_integer(unsigned(addr(8 DOWNTO 2)));

            IF we = '1' THEN
                IF byte_enable(0) = '1' THEN
                    RAM(a * 4 + 0) <= din(7 DOWNTO 0);
                END IF;

                IF byte_enable(1) = '1' THEN
                    RAM(a * 4 + 1) <= din(15 DOWNTO 8);
                END IF;

                IF byte_enable(2) = '1' THEN
                    RAM(a * 4 + 2) <= din(23 DOWNTO 16);
                END IF;

                IF byte_enable(3) = '1' THEN
                    RAM(a * 4 + 3) <= din(31 DOWNTO 24);
                END IF;
            END IF;
        END IF;
    END PROCESS;

    PROCESS (RAM, addr)
        VARIABLE a : INTEGER;
    BEGIN
        a := to_integer(unsigned(addr(8 DOWNTO 2)));

        dout(7 DOWNTO 0)   <= RAM(a * 4 + 0);
        dout(15 DOWNTO 8)  <= RAM(a * 4 + 1);
        dout(23 DOWNTO 16) <= RAM(a * 4 + 2);
        dout(31 DOWNTO 24) <= RAM(a * 4 + 3);
    END PROCESS;

END ARCHITECTURE;