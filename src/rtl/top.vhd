LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY top IS
    PORT (
        clk : IN STD_LOGIC

    );
END top;

ARCHITECTURE Behavioral OF top IS
    COMPONENT core IS
        PORT (
            reset : IN STD_LOGIC;
            clk   : IN STD_LOGIC;

            instr      : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            instr_addr : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);

            mem_data_in  : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            mem_data_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            mem_addr     : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    END COMPONENT;
    COMPONENT instr_rom IS
        PORT (
            addr : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
            rd   : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
        );
    END COMPONENT;
    COMPONENT decoder IS
        PORT (
            addr    : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            mem_we  : OUT STD_LOGIC;
            uart_we : OUT STD_LOGIC
        );
    END COMPONENT;
    COMPONENT ram IS
        PORT (
            clk  : IN STD_LOGIC;
            we   : IN STD_LOGIC;
            addr : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
            din  : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            dout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    END COMPONENT;

    SIGNAL reset : STD_LOGIC;

    SIGNAL instr      : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL instr_addr : STD_LOGIC_VECTOR(31 DOWNTO 0);

    SIGNAL mem_we  : STD_LOGIC;
    SIGNAL uart_we : STD_LOGIC;

    SIGNAL mem_data_in  : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL mem_data_out : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL mem_addr     : STD_LOGIC_VECTOR(31 DOWNTO 0);

BEGIN
    core_comp : ENTITY work.core
        PORT MAP(
            reset        => reset,
            clk          => clk,
            instr        => instr,
            instr_addr   => instr_addr,
            mem_data_in  => mem_data_in,
            mem_data_out => mem_data_out,
            mem_addr     => mem_addr
        );

    instr_rom_comp : ENTITY work.instr_rom
        PORT MAP(
            addr => instr_addr,
            rd   => instr
        );

    decoder_comp : ENTITY work.decoder
        PORT MAP(
            addr    => mem_addr,
            mem_we  => mem_we,
            uart_we => uart_we
        );
    ram_comp: entity work.ram
     port map(
        clk => clk,
        we => mem_we,
        addr => mem_addr,
        din => mem_data_out,
        dout => mem_data_in
    );
END Behavioral;