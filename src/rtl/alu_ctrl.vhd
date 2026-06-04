LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

USE work.riscv_consts.ALL;

ENTITY alu_ctrl IS
    PORT (
        opcode : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
        f3     : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
        f7     : IN STD_LOGIC_VECTOR (6 DOWNTO 0);
        f      : OUT STD_LOGIC_VECTOR (3 DOWNTO 0)
    );
END alu_ctrl;

ARCHITECTURE Behavioral OF alu_ctrl IS
BEGIN
    PROCESS (opcode, f3, f7)
    BEGIN
        CASE opcode IS
            WHEN OP =>
                IF f3 = "000" AND f7 = "0000000" THEN
                    -- add
                    f <= "0110";
                ELSIF f3 = "000" AND f7 = "0100000" THEN
                    -- sub
                    f <= "0111";
                ELSIF f3 = "100" AND f7 = "0000000" THEN
                    -- sll
                    f <= "1000";
                ELSIF f3 = "010" AND f7 = "0000000" THEN
                    -- slt
                    f <= "1011";
                ELSIF f3 = "011" AND f7 = "0000000" THEN
                    -- sltu
                    f <= "1100";
                ELSIF f3 = "100" AND f7 = "0000000" THEN
                    -- xor
                    f <= "0101";
                ELSIF f3 = "101" AND f7 = "0000000" THEN
                    -- srl
                    f <= "1001";
                ELSIF f3 = "101" AND f7 = "0100000" THEN
                    -- sra
                    f <= "1010";
                ELSIF f3 = "110" AND f7 = "0000000" THEN
                    -- or
                    f <= "0100";
                ELSIF f3 = "111" AND f7 = "0000000" THEN
                    -- and
                    f <= "0011";
                END IF;
            WHEN OP_IMM =>
                IF f3 = "000" THEN
                    -- addi
                    f <= "0110";
                ELSIF f3 = "100" AND f7 = "0000000" THEN
                    -- slli
                    f <= "1000";
                ELSIF f3 = "010" THEN
                    -- slti
                    f <= "1011";
                ELSIF f3 = "011" THEN
                    -- sltiu
                    f <= "1100";
                ELSIF f3 = "100" THEN
                    -- xori
                    f <= "0101";
                ELSIF f3 = "101" AND f7 = "0000000" THEN
                    -- srli
                    f <= "1001";
                ELSIF f3 = "101" AND f7 = "0000000" THEN
                    -- srai
                    f <= "1010";
                ELSIF f3 = "110" THEN
                    -- ori
                    f <= "0100";
                ELSIF f3 = "111" THEN
                    -- andi
                    f <= "0011";
                END IF;
            WHEN LOAD =>
                IF f3 = "000" THEN
                    f <= "0110";
                ELSIF f3 = "001" THEN
                    f <= "0110";
                ELSIF f3 = "010" THEN
                    f <= "0110";
                ELSIF f3 = "100" THEN
                    f <= "0110";
                ELSIF f3 = "101" THEN
                    f <= "0110";
                END IF;
            WHEN OTHERS =>
                NULL;
        END CASE;
    END PROCESS;
END Behavioral;