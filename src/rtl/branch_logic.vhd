library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.br_sel.all;

entity branch_logic is
    port (
        reg1    : in std_logic_vector(31 downto 0);
        reg2    : in std_logic_vector(31 downto 0); 
        br_sel  : in std_logic_vector( 2 downto 0);
        br_out  : out std_logic -- branch taken -> 1, 0 for not taken
    );
end entity branch_logic;

architecture Rtl of branch_logic is
begin
    process(reg1, reg2, br_sel)
    begin
        case br_sel is
            when "000" => -- BEQ 
                if reg1 = reg2 then
                    br_out <= '1';
                else
                    br_out <= '0';
                end if;

            when "001" => -- BNE 
                if reg1 /= reg2 then
                    br_out <= '1';
                else
                    br_out <= '0';
                end if;
            
            when "010" => -- BLT 
                if reg1 < reg2 then
                    br_out <= '1';
                else
                    br_out <= '0';
                end if;
            
            when "011" => -- BGE 
                if reg1 >= reg2 then
                    br_out <= '1';
                else
                    br_out <= '0';
                end if;
            
            when "100" => -- BNEZ 
                if reg1 /= x"00000000" then
                    br_out <= '1';
                else
                    br_out <= '0';
                end if;

            when others =>
                br_out <= '0'; -- no branch taken
        end case;
    end process;
end architecture Rtl;
