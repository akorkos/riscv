LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY branch_logic IS
    PORT (
        reg1   : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        reg2   : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        br_sel : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        br_out : OUT STD_LOGIC -- branch taken -> 1, 0 for not taken
    );
END ENTITY branch_logic;

ARCHITECTURE Rtl OF branch_logic IS
BEGIN
    PROCESS (reg1, reg2, br_sel)
    BEGIN
        CASE br_sel IS
            WHEN "000" => -- BEQ 
                IF reg1 = reg2 THEN
                    br_out <= '1';
                ELSE
                    br_out <= '0';
                END IF;
            WHEN "001" => -- BNE 
                IF reg1 /= reg2 THEN
                    br_out <= '1';
                ELSE
                    br_out <= '0';
                END IF;
            WHEN "100" => -- BLT 
                IF SIGNED(reg1) < SIGNED(reg2) THEN
                    br_out <= '1';
                ELSE
                    br_out <= '0';
                END IF;
            WHEN "101" => -- BGE 
                IF SIGNED(reg1) >= SIGNED(reg2) THEN
                    br_out <= '1';
                ELSE
                    br_out <= '0';
                END IF;
            WHEN "110" => -- bltu
                IF UNSIGNED(reg1) < UNSIGNED(reg2) THEN
                    br_out <= '1';
                ELSE
                    br_out <= '0';
                END IF;
            WHEN "111" => -- bgeu
                IF UNSIGNED(reg1) >= UNSIGNED(reg2) THEN
                    br_out <= '1';
                ELSE
                    br_out <= '0';
                END IF;
            WHEN OTHERS =>
                br_out <= '0'; -- no branch taken
        END CASE;
    END PROCESS;
END ARCHITECTURE Rtl;