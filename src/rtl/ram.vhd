-- https://docs.amd.com/r/en-US/ug901-vivado-synthesis/Dual-Port-RAM-with-Asynchronous-Read-Coding-Verilog-Example

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ram is
    port(
        clk     : in std_logic;
        we      : in std_logic;
        addr    : in std_logic_vector( 9 downto 0);
        din     : in std_logic_vector(31 downto 0);
        dout    : out std_logic_vector(31 downto 0)
    );
end ram;

architecture Rtl of ram is
    type ram_type is array ((2**10)-1 downto 0) of std_logic_vector(31 downto 0);
    signal RAM : ram_type;
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if (we = '1') then
                RAM(to_integer(unsigned(addr))) <= din;
            end if;
            
            dout <= RAM(to_integer(unsigned(addr)));
        end if;
end process;
end Rtl;