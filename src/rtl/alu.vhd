LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY alu IS
    PORT (
        A : IN STD_LOGIC_VECTOR(31 DOWNTO 0);  -- Source register 1 data
        B : IN STD_LOGIC_VECTOR(31 DOWNTO 0);  -- Source register 2 data or immediate
        F : IN STD_LOGIC_VECTOR(3 DOWNTO 0);   -- ALU operation code
        R : OUT STD_LOGIC_VECTOR(31 DOWNTO 0); -- ALU result output
        S : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)   -- ALU flags 
    );
END ENTITY alu;

ARCHITECTURE Rtl OF alu IS
    SIGNAL zero     : STD_LOGIC;
    SIGNAL sign     : STD_LOGIC;
    SIGNAL overflow : STD_LOGIC;
    SIGNAL carry    : STD_LOGIC;

    SIGNAL tmp     : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL add_tmp : STD_LOGIC_VECTOR(32 DOWNTO 0);
    SIGNAL sub_tmp : STD_LOGIC_VECTOR(32 DOWNTO 0);
BEGIN
    PROCESS (A, B, F)
    BEGIN
        add_tmp <= (OTHERS => '0');
        sub_tmp <= (OTHERS => '0');

        CASE F IS -- decode the opcode
            WHEN "0000" => tmp <= (OTHERS => '0');
            WHEN "0001" => tmp <= B;
            WHEN "0010" => tmp <= NOT A;
            WHEN "0011" => tmp <= A AND B; -- AND  
            WHEN "0100" => tmp <= A OR B;  -- OR
            WHEN "0101" => tmp <= A XOR B; -- XOR
            WHEN "0110" =>                 -- ADD
                tmp     <= STD_LOGIC_VECTOR(signed(A) + signed(B));
                add_tmp <= STD_LOGIC_VECTOR(('0' & unsigned(A)) + ('0' & unsigned(B)));
            WHEN "0111" => -- SUB
                tmp     <= STD_LOGIC_VECTOR(signed(A) - signed(B));
                sub_tmp <= STD_LOGIC_VECTOR(('0' & unsigned(A)) - ('0' & unsigned(B)));
            WHEN "1000" => -- SLL
                tmp <= STD_LOGIC_VECTOR(shift_left(unsigned(A), to_integer(unsigned(B(4 DOWNTO 0)))));
            WHEN "1001" => -- SRL
                tmp <= STD_LOGIC_VECTOR(shift_right(unsigned(A), to_integer(unsigned(B(4 DOWNTO 0)))));
            WHEN "1010" => -- SRA
                tmp <= STD_LOGIC_VECTOR(shift_left(unsigned(A), to_integer(unsigned(B(4 DOWNTO 0)))));
            WHEN "1011" => -- SLT
                IF signed(A) < signed(B) THEN
                    tmp <= x"00000001";
                ELSE
                    tmp <= x"00000000";
                END IF;
            WHEN "1100" => -- SLTU
                IF unsigned(A) < unsigned(B) THEN
                    tmp <= x"00000001";
                ELSE
                    tmp <= x"00000000";
                END IF;
            WHEN OTHERS =>
                NULL;
        END CASE;
    END PROCESS;

    zero <= '1' WHEN tmp = x"00000000" ELSE
        '0';
    sign     <= tmp(31);
    overflow <= '1' WHEN
        (F = "110" AND A(31) = B(31) AND A(31) /= tmp(31)) OR
        (F = "111" AND A(31) /= B(31) AND A(31) /= tmp(31))
        ELSE
        '0';
    carry <= add_tmp(32) WHEN F = "110" ELSE
        sub_tmp(32) WHEN F = "111" ELSE
        '0';

    R <= tmp;
    S <= zero & sign & overflow & carry;
END ARCHITECTURE;