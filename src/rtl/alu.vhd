library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu is
    port (
        A   : in std_logic_vector(31 downto 0);  -- Source register 1 data
        B   : in std_logic_vector(31 downto 0);  -- Source register 2 data or immediate
        F   : in std_logic_vector( 3 downto 0);  -- ALU operation code
        R   : out std_logic_vector(31 downto 0); -- ALU result output
        S   : out std_logic_vector(3 downto 0)   -- ALU flags 
    );
end entity alu;

architecture Rtl of alu is
    signal zero     : std_logic;
    signal sign     : std_logic;
    signal overflow : std_logic;
    signal carry    : std_logic;

    signal tmp      : std_logic_vector(31 downto 0);
    signal add_tmp  : std_logic_vector(32 downto 0);
    signal sub_tmp  : std_logic_vector(32 downto 0);
begin
    process (A, B, F)
    begin
        add_tmp <= (others => '0');
        sub_tmp <= (others => '0');

        case F is  -- decode the opcode
            when "0000" =>  tmp <= (others => '0');  
            when "0001" =>  tmp <= B;   
            when "0010" =>  tmp <= not A;   
            when "0011" =>  tmp <= A and B; -- AND  
            when "0100" =>  tmp <= A or B; -- OR
            when "0101" =>  tmp <= A xor B; -- XOR
            when "0110" =>  -- ADD
                tmp <= std_logic_vector(signed(A) + signed(B));
                add_tmp <= std_logic_vector(('0' & unsigned(A)) + ('0' & unsigned(B)));
            when "0111" => -- SUB
                tmp <= std_logic_vector(signed(A) - signed(B));
                sub_tmp <= std_logic_vector(('0' & unsigned(A)) - ('0' & unsigned(B)));
            when "1000" => -- SLL
                tmp <= <= std_logic_vector(shift_left(unsigned(A), to_integer(unsigned(B(4 downto 0)))));
            when "1001" => -- SRL
                tmp <= <= std_logic_vector(shift_right(unsigned(A), to_integer(unsigned(B(4 downto 0)))));
            when "1010" => -- SRA
                tmp <= <= std_logic_vector(shift_left(unsigned(A), to_integer(unsigned(B(4 downto 0)))));
            when "1011" => -- SLT
                 if signed(A) < signed(B) then
                    tmp <= x"00000001";
                else
                    tmp <= x"00000000";
                end if;
            when "1100" => -- SLTU
                if unsigned(A) < unsigned(B) then
                    tmp <= x"00000001";
                else
                    tmp <= x"00000000";
                end if;
        end case;
    end process;

    zero <= '1' when tmp = x"00000000" else '0';
    sign <= tmp(31);
    overflow <= '1' when
        (F = "110" and A(31) = B(31) and A(31) /= tmp(31)) or
        (F = "111" and A(31) /= B(31) and A(31) /= tmp(31))
        else '0';
    carry <= add_tmp(32) when F = "110" else
        sub_tmp(32) when F = "111" else
        '0';
    
    R <= tmp;
    S <= zero & sign & overflow & carry;
end architecture;
