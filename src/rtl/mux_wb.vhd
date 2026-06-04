LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY mux_wb IS
    PORT (
        wb_sel      : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        alu_in      : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        pc          : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        imm         : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        mem_data_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0); -- Memory data input
        wb_out      : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END ENTITY mux_wb;

ARCHITECTURE Rtl OF mux_wb IS
BEGIN
    PROCESS (wb_sel, alu_in, pc, imm, mem_data_in)
    BEGIN
        CASE wb_sel IS
            WHEN "00" =>
                wb_out <= alu_in;
            WHEN "01" =>
                wb_out <= STD_LOGIC_VECTOR(unsigned(pc) + 4);
            WHEN "10" =>
                wb_out <= imm;
            WHEN "11" =>
                wb_out <= mem_data_in;
            WHEN OTHERS =>
                wb_out <= (OTHERS => '0');
        END CASE;
    END PROCESS;
END ARCHITECTURE Rtl;