LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY alu IS
    PORT (
        A : IN STD_LOGIC_VECTOR(31 DOWNTO 0); -- Source register 1 data
        B : IN STD_LOGIC_VECTOR(31 DOWNTO 0); -- Source register 2 data or immediate
        F : IN STD_LOGIC_VECTOR(3 DOWNTO 0);  -- ALU operation code
        R : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) -- ALU result output
    );
END ENTITY alu;

ARCHITECTURE Rtl OF alu IS
BEGIN
    PROCESS (A, B, F)
    BEGIN
        R <= (OTHERS => '0');
        CASE F IS -- decode the opcode
            WHEN "0000" => R <= (OTHERS => '0');
            WHEN "0001" => R <= B;
            WHEN "0010" => R <= NOT A;
            WHEN "0011" => R <= A AND B; -- AND  
            WHEN "0100" => R <= A OR B;  -- OR
            WHEN "0101" => R <= A XOR B; -- XOR
            WHEN "0110" =>               -- ADD
                R <= STD_LOGIC_VECTOR(signed(A) + signed(B));
            WHEN "0111" => -- SUB
                R <= STD_LOGIC_VECTOR(signed(A) - signed(B));
            -- WHEN "1000" => -- SLL
            --     R <= STD_LOGIC_VECTOR(shift_left(unsigned(A), to_integer(unsigned(B(4 DOWNTO 0)))));
            -- WHEN "1001" => -- SRL
            --     R <= STD_LOGIC_VECTOR(shift_right(unsigned(A), to_integer(unsigned(B(4 DOWNTO 0)))));
            -- WHEN "1010" => -- SRA
                R <= STD_LOGIC_VECTOR(shift_left(unsigned(A), to_integer(unsigned(B(4 DOWNTO 0)))));
            WHEN "1011" => -- SLT
                IF signed(A) < signed(B) THEN
                    R <= x"00000001";
                ELSE
                    R <= x"00000000";
                END IF;
            WHEN "1100" => -- SLTU
                IF unsigned(A) < unsigned(B) THEN
                    R <= x"00000001";
                ELSE
                    R <= x"00000000";
                END IF;
            WHEN OTHERS =>
                NULL;
        END CASE;
    END PROCESS;
END ARCHITECTURE;