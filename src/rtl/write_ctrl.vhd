LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

USE work.riscv_consts.ALL;

ENTITY write_ctrl IS
    PORT (
        opcode      : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
        f3          : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        byte_enable : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
END write_ctrl;

ARCHITECTURE Behavioral OF write_ctrl IS
BEGIN
    PROCESS (opcode, f3)
    BEGIN
        IF opcode = STORE THEN
            CASE f3 IS
                WHEN "000" =>
                    -- sb
                    byte_enable <= "0001";
                WHEN "001" =>
                    -- sh
                    byte_enable <= "0011";
                WHEN "010" =>
                    -- sw
                    byte_enable <= "1111";
                WHEN OTHERS =>
                    byte_enable <= "0000";
            END CASE;
        ELSE
            byte_enable <= "0000";
        END IF;
    END PROCESS;
END Behavioral;