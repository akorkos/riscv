LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY uart IS
    PORT (
        we          : IN STD_LOGIC;
        byte_enable : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        clk         : IN STD_LOGIC;
        addr        : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        data_in     : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        tx          : OUT STD_LOGIC
    );
END uart;

ARCHITECTURE Behavioral OF uart IS
    COMPONENT tx_top IS
        PORT (
            clk      : IN STD_LOGIC;
            clk_div  : IN UNSIGNED(31 DOWNTO 0);
            data_in  : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            new_data : IN STD_LOGIC;
            tx       : OUT STD_LOGIC
        );
    END COMPONENT;

    SIGNAL clk_div  : UNSIGNED(31 DOWNTO 0)        := (OTHERS => '0');
    SIGNAL data     : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
    SIGNAL new_data : STD_LOGIC                    := '0';
BEGIN
    tx_top_inst : ENTITY work.tx_top
        PORT MAP(
            clk      => clk,
            new_data => new_data,
            clk_div  => UNSIGNED(clk_div),
            data_in  => data,
            tx       => tx
        );

    PROCESS (clk, we, data_in)
    BEGIN
        IF rising_edge(clk) THEN
            new_data <= '0';
            IF we = '1' THEN
                CASE addr IS
                    WHEN x"02000004" => -- clk_div addr
                        clk_div <= UNSIGNED(data_in AND (31 DOWNTO 24 => byte_enable(2), 23 DOWNTO 16 => byte_enable(2), 15 DOWNTO 8 => byte_enable(1), 7 DOWNTO 0 => byte_enable(0)));
                    WHEN x"02000008" => -- data addr
                        IF byte_enable(0) = '1' THEN
                            new_data <= '1';
                            data     <= data_in(7 DOWNTO 0);
                        END IF;
                    WHEN OTHERS =>
                        NULL;
                END CASE;
            ELSE
            END IF;
        END IF;

    END PROCESS;
END Behavioral;