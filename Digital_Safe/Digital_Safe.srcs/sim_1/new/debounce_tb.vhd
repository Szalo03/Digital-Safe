library ieee;
use ieee.std_logic_1164.all;

entity tb_debounce is
end tb_debounce;

architecture test of tb_debounce is
    -- Signals
    signal s_clk          : std_logic := '0';
    signal s_rst          : std_logic;
    signal s_btnl_in      : std_logic := '0';
    signal s_btnr_in      : std_logic := '0';
    signal s_btnd_in      : std_logic := '0';
    signal s_btnl_pressed : std_logic;
    signal s_btnr_pressed : std_logic;
    signal s_btnd_pressed : std_logic;

    constant CLK_PERIOD : time := 10 ns;

begin
    uut: entity work.debounce
        port map (
            clk          => s_clk,
            rst          => s_rst,
            btnl_in      => s_btnl_in,
            btnr_in      => s_btnr_in,
            btnd_in      => s_btnd_in,
            btnl_pressed => s_btnl_pressed,
            btnr_pressed => s_btnr_pressed,
            btnd_pressed => s_btnd_pressed
        );

    s_clk <= not s_clk after CLK_PERIOD/2;

    stim_proc: process
    begin
        s_rst <= '1';
        s_btnl_in <= '0'; s_btnr_in <= '0'; s_btnd_in <= '0';
        wait for 100 ns;
        s_rst <= '0';
        wait for 100 ns;

        
        s_btnl_in <= '1'; wait for 500 ns; s_btnl_in <= '0';
        wait for 200 ns;

        s_btnr_in <= '1'; wait for 500 ns; s_btnr_in <= '0';
        wait for 200 ns;

        s_btnd_in <= '1'; wait for 500 ns; s_btnd_in <= '0';
        wait for 200 ns;

        s_btnl_in <= '1';
        wait for 200 ns;
        s_btnr_in <= '1';
        wait for 500 ns;
        s_btnl_in <= '0';
        s_btnr_in <= '0';

        for i in 1 to 5 loop
            s_btnr_in <= '1'; wait for 20 ns;
            s_btnr_in <= '0'; wait for 20 ns;
        end loop;
        s_btnr_in <= '1';
        wait for 1 ms;
        s_btnr_in <= '0';

        wait; 
    end process;
end test;