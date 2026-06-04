LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

USE work.riscv_consts.ALL;

ENTITY read_ctrl IS
    PORT (
        mem_data_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        opcode      : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
        f3          : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        mem_wb_data : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END read_ctrl;

ARCHITECTURE Behavioral OF read_ctrl IS
BEGIN
    PROCESS (mem_data_in, opcode, f3)
    BEGIN
        IF opcode = LOAD THEN
            CASE f3 IS
                WHEN "000" =>
                    --lb
                    mem_wb_data <= (31 DOWNTO 8 => mem_data_in(7)) & mem_data_in(7 DOWNTO 0);
                WHEN "001" =>
                    --lh
                    mem_wb_data <= (31 DOWNTO 16 => mem_data_in(15)) & mem_data_in(15 DOWNTO 0);
                WHEN "010" =>
                    --lw
                    mem_wb_data <= mem_data_in;
                WHEN "100" =>
                    --lbu
                    mem_wb_data <= (31 DOWNTO 8 => '0') & mem_data_in(7 DOWNTO 0);
                WHEN "101" =>
                    --lhu
                    mem_wb_data <= (31 DOWNTO 16 => '0') & mem_data_in(15 DOWNTO 0);
                WHEN OTHERS =>
                    mem_wb_data <= (OTHERS => '0');
            END CASE;
        ELSE
            mem_wb_data <= (OTHERS => '0');
        END IF;
    END PROCESS;
END Behavioral;