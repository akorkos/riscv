library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity decoder is
    port(
        instr   : in std_logic_vector(31 downto 0); 
        opcode  : out std_logic_vector(6 downto 0); 
        rd      : out std_logic_vector(4 downto 0); -- or imm[4:0]
        funct3  : out std_logic_vector(2 downto 0); 
        reg1    : out std_logic_vector(4 downto 0); 
        reg2    : out std_logic_vector(4 downto 0); 
        funct7  : out std_logic_vector(6 downto 0) 
    );
end entity decoder;

architecture Rtl of decoder is
begin
    opcode  <= instr( 6 downto 0);   -- opcode from instruction
    rd      <= instr(11 downto 7); 
    funct3  <= instr(14 downto 12);  -- funct3 from instruction
    reg1    <= instr(19 downto 15); 
    reg2    <= instr(24 downto 20); 
    funct7  <= instr(31 downto 25);  -- funct7 from instruction
end architecture Rtl;