LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY mux_pc IS
    PORT (
        sel     : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        pc      : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        rd1     : IN STD_LOGIC_VECTOR(31 DOWNTO 0); -- rd1 for register indirect addressing
        imm     : IN STD_LOGIC_VECTOR(31 DOWNTO 0); -- imm for branch/jump target (pc + imm)
        pc_next : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) -- next PC value
    );
END ENTITY mux_pc;

-- 00 PC+4,
-- 01 branch target
-- 10 jump target
-- 11 register indirect (jalr)
ARCHITECTURE Rtl OF mux_pc IS
BEGIN
    PROCESS (sel, pc, rd1, imm)
    BEGIN
        CASE sel IS
            WHEN "00" => -- PC + 4
                pc_next <= STD_LOGIC_VECTOR(unsigned(pc) + 4);
            WHEN "01" => -- branch target
                pc_next <= STD_LOGIC_VECTOR(unsigned(pc) + unsigned(imm));
            WHEN "10" => -- jump target
                pc_next <= STD_LOGIC_VECTOR(unsigned(pc) + unsigned(imm));
            WHEN "11" => -- jalr
                pc_next <= STD_LOGIC_VECTOR(unsigned(rd1) + unsigned(imm));
            WHEN OTHERS =>
                pc_next <= pc; -- keep current PC
        END CASE;
    END PROCESS;
END ARCHITECTURE Rtl;