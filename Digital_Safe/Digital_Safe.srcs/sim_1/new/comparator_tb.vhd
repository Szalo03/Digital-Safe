library ieee;
use ieee.std_logic_1164.all;

entity tb_Comparator is
end tb_Comparator;

architecture test of tb_Comparator is
    signal s_clk        : std_logic := '0';
    signal s_rst        : std_logic;
    signal s_code_in    : std_logic_vector(15 downto 0) := (others => '0');
    signal s_lock_open  : std_logic;
    signal s_lock_close : std_logic;

    constant CLK_PERIOD : time := 10 ns;
begin
    uut: entity work.Comparator
        port map (
            clk        => s_clk,
            rst        => s_rst,
            code_in    => s_code_in,
            lock_open  => s_lock_open,
            lock_close => s_lock_close
        );

    s_clk <= not s_clk after CLK_PERIOD/2;

    stim_proc: process
    begin
        s_rst <= '1';
        wait for 20 ns;
        s_rst <= '0';
        wait for 20 ns;

        s_code_in <= x"9999";
        wait for 40 ns;

        s_code_in <= x"1230";
        wait for 40 ns;

        s_code_in <= x"1234";
        wait for 40 ns;

        s_code_in <= x"0000";
        wait for 40 ns;

        wait;
    end process;
end test;