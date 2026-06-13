LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY top IS
    PORT (
        clk : IN STD_LOGIC;
        tx  : OUT STD_LOGIC
    );
END top;

ARCHITECTURE Behavioral OF top IS
    COMPONENT clk_wiz_0 IS
        PORT (
            clk_in1  : IN STD_LOGIC;
            clk_out1 : OUT STD_LOGIC;
            clk_out2 : OUT STD_LOGIC
        );
    END COMPONENT;
    COMPONENT core IS
        PORT (
            reset : IN STD_LOGIC;
            clk   : IN STD_LOGIC;
            clki  : IN STD_LOGIC;

            instr      : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            instr_addr : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);

            mem_data_in  : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            byte_enable  : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
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
            uart_we : OUT STD_LOGIC;
            led_we  : OUT STD_LOGIC
        );
    END COMPONENT;
    COMPONENT ram IS
        PORT (
            clk         : IN STD_LOGIC;
            addr        : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            din         : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            dout        : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            we          : IN STD_LOGIC;
            byte_enable : IN STD_LOGIC_VECTOR(3 DOWNTO 0)
        );
    END COMPONENT;
    COMPONENT uart IS
        PORT (
            we          : IN STD_LOGIC;
            byte_enable : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            clk         : IN STD_LOGIC;
            addr        : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            data_in     : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            tx          : OUT STD_LOGIC
        );
    END COMPONENT;

    SIGNAL core_clk  : STD_LOGIC;
    SIGNAL core_clki : STD_LOGIC;
    SIGNAL reset     : STD_LOGIC;

    SIGNAL instr      : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL instr_addr : STD_LOGIC_VECTOR(31 DOWNTO 0);

    SIGNAL mem_we      : STD_LOGIC;
    SIGNAL uart_we     : STD_LOGIC;
    SIGNAL led_we      : STD_LOGIC;
    SIGNAL byte_enable : STD_LOGIC_VECTOR(3 DOWNTO 0);

    SIGNAL mem_data_in  : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL mem_data_out : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL mem_addr     : STD_LOGIC_VECTOR(31 DOWNTO 0);

BEGIN
    clk_wiz_0_inst : clk_wiz_0
    PORT MAP(
        clk_in1  => clk,
        clk_out1 => core_clk,
        clk_out2 => core_clki
    );
    core_comp : ENTITY work.core
        PORT MAP(
            reset        => reset,
            clk          => core_clk,
            clki         => core_clki,
            instr        => instr,
            instr_addr   => instr_addr,
            mem_data_in  => mem_data_in,
            byte_enable  => byte_enable,
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
            uart_we => uart_we,
            led_we  => led_we
        );
    ram_comp : ENTITY work.ram
        PORT MAP(
            clk         => core_clk,
            we          => mem_we,
            byte_enable => byte_enable,
            addr        => mem_addr,
            din         => mem_data_out,
            dout        => mem_data_in
        );
    uart_comp : uart
    PORT MAP(
        we          => uart_we,
        byte_enable => byte_enable,
        clk         => core_clk,
        addr        => mem_addr,
        data_in     => mem_data_out,
        tx          => tx
    );
END Behavioral;