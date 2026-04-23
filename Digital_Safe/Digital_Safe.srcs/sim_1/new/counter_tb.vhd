library ieee;
use ieee.std_logic_1164.all;

entity tb_counter is
end tb_counter;

architecture test of tb_counter is
    signal s_clk      : std_logic := '0';
    signal s_rst      : std_logic;
    signal s_en_dec   : std_logic := '0';
    signal s_en_inc   : std_logic := '0';
    signal s_slot_idx : std_logic_vector(1 downto 0);

    constant CLK_PERIOD : time := 10 ns;
begin
    uut: entity work.counter
        generic map ( G_BITS => 2 )
        port map (
            clk      => s_clk,
            rst      => s_rst,
            en_dec   => s_en_dec,
            en_inc   => s_en_inc,
            slot_idx => s_slot_idx
        );

    s_clk <= not s_clk after CLK_PERIOD/2;

    stim_proc: process
    begin
        s_rst <= '1';
        wait for 20 ns;
        s_rst <= '0';
        wait for 20 ns;

        s_en_inc <= '1'; wait for CLK_PERIOD; s_en_inc <= '0';
        wait for 20 ns;
        s_en_inc <= '1'; wait for CLK_PERIOD; s_en_inc <= '0';
        wait for 20 ns;

        s_en_dec <= '1'; wait for CLK_PERIOD; s_en_dec <= '0';
        wait for 20 ns;

        wait; 
    end process;
end test;