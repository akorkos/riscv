library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux_pc is
    port (
        clk     : in std_logic;
        reset   : in std_logic;
        pc_sel  : in std_logic_vector(2 downto 0);
        br      : in std_logic;                     -- branch condition 
        imm     : in std_logic_vector(31 downto 0); -- immediate value from instruction
        reg1    : in std_logic_vector(31 downto 0); -- jalr
        pc_out  : out std_logic_vector(31 downto 0) -- next PC value
    );
end entity mux_pc;

-- 00 PC+4, 
-- 01 PC+imm(br / jal), 
-- 10 rs1+imm (rind/jalr), 
-- 11 absoulte jump (jabs)
architecture Rtl of mux_pc is
    signal reg_pc   : std_logic_vector(31 downto 0) := (others => '0'); -- PC register
    signal pc_next  : std_logic_vector(31 downto 0); -- next PC value
begin
    process (pc_sel, reg_pc, imm, reg1, br)
    begin
        case pc_sel is
            when "000" => -- PC + 4
                pc_next <= std_logic_vector(unsigned(reg_pc) + 4);
            when "001" =>
                pc_next <= (others => '0'); -- placeholder 
            when "010" => -- jalr
                pc_next <= std_logic_vector((unsigned(reg1) + unsigned(imm))) and x"FFFFFFFE";
            when "011" => -- jal 
                pc_next <= std_logic_vector(unsigned(reg_pc) + unsigned(imm));
            when "100" => -- branch instruction
                if br = '1' then
                    pc_next <= std_logic_vector(unsigned(reg_pc) + unsigned(imm));
                else
                    pc_next <= std_logic_vector(unsigned(reg_pc) + 4); -- if branch not taken
                end if;
            when others =>
                pc_next <= std_logic_vector(unsigned(reg_pc) + 4); -- keep current PC
        end case;
    end process;

    process (clk, reset)
    begin
        if reset = '1' then
            reg_pc <= (others => '0');
        elsif rising_edge(clk) then
            reg_pc <= pc_next;
        end if;
    end process;

    pc_out <= reg_pc;
end architecture Rtl;