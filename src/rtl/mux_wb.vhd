library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux_wb is
    port (
        alu_in      : in std_logic_vector(31 downto 0);
        pc4         : in std_logic_vector(31 downto 0);
        imm         : in std_logic_vector(31 downto 0);
        wb_sel      : in std_logic_vector( 1 downto 0);
        mem_data_in : in std_logic_vector(31 downto 0); -- Memory data input
        wb_out      : out std_logic_vector(31 downto 0)
    );
end entity mux_wb;

architecture Rtl of mux_wb is
begin
    process(wb_sel, alu_in, pc4, imm)
    begin
        case wb_sel is
            when "00" =>
                wb_out <= alu_in;
            when "01" =>
                wb_out <= pc4;
            when "10" =>
                wb_out <= imm;
            when "11" =>
                wb_out <= mem_data_in;
            when others =>
                wb_out <= (others => '0');
        end case;
    end process;
end architecture Rtl;