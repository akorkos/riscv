LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY tx_top IS
    PORT (
        clk      : IN STD_LOGIC;
        clk_div  : IN UNSIGNED(31 DOWNTO 0);
        data_in  : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        new_data : IN STD_LOGIC;
        tx       : OUT STD_LOGIC
    );
END tx_top;

ARCHITECTURE Behavioral OF tx_top IS
    COMPONENT fifo_generator_0 IS
        PORT (
            clk   : IN STD_LOGIC;
            wr_en : IN STD_LOGIC;
            din   : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            rd_en : IN STD_LOGIC;
            dout  : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
            empty : OUT STD_LOGIC
        );
    END COMPONENT;

    SIGNAL wr_en      : STD_LOGIC := '0';
    SIGNAL rd_en      : STD_LOGIC := '0';
    SIGNAL fifo_empty : STD_LOGIC;

    SIGNAL counter    : unsigned(15 DOWNTO 0)          := (OTHERS => '0');
    SIGNAL msg_buffer : STD_LOGIC_VECTOR(255 DOWNTO 0) := (OTHERS => '0');
    SIGNAL message    : STD_LOGIC_VECTOR(7 DOWNTO 0)   := (OTHERS => '0');

    SIGNAL parity : STD_LOGIC;
    SIGNAL d_bit  : INTEGER := 0;

    TYPE state_type IS (IDLE, START, DATA, P, STOP);
    SIGNAL state : state_type := IDLE;
BEGIN
    fifo_generator_0_inst : fifo_generator_0
    PORT MAP(
        clk   => clk,
        wr_en => wr_en,
        din   => data_in,
        rd_en => rd_en,
        dout  => message,
        empty => fifo_empty
    );

    PROCESS (clk)
    BEGIN
        wr_en <= '0';
        IF new_data = '1' THEN
            wr_en <= '1';
        END IF;

        IF rising_edge(clk) THEN
            IF clk_div > 0 THEN

                IF rd_en = '1' AND state = IDLE THEN
                    state <= START;
                    rd_en <= '0';
                END IF;
                IF counter < clk_div THEN
                    counter <= counter + 1;
                ELSE
                    counter <= (OTHERS => '0');
                    CASE state IS
                        WHEN IDLE =>
                            tx <= '1';
                            IF fifo_empty = '0' THEN
                                rd_en <= '1';
                            END IF;
                        WHEN START =>
                            tx     <= '0';
                            parity <= '0';
                            d_bit  <= 0;
                            state  <= DATA;
                        WHEN DATA =>
                            IF d_bit = 7 THEN
                                state <= P;
                            END IF;
                            tx     <= message(d_bit);
                            parity <= parity XOR message(d_bit);
                            d_bit  <= d_bit + 1;
                        WHEN P =>
                            tx    <= parity;
                            state <= STOP;
                        WHEN STOP =>
                            tx    <= '1';
                            state <= IDLE;
                        WHEN OTHERS =>
                            state <= IDLE;
                    END CASE;
                END IF;
            END IF;
        END IF;
    END PROCESS;
END Behavioral;