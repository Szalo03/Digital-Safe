library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter is
    generic (
        G_BITS : positive := 2 
    );
    port (
        clk      : in  std_logic;
        rst      : in  std_logic;
        en_dec   : in  std_logic; 
        en_inc   : in  std_logic; 
        slot_idx : out std_logic_vector(G_BITS - 1 downto 0)
    );
end entity counter;

architecture behavioral of counter is

    constant C_MAX : integer := 2**G_BITS - 1;
    signal sig_cnt : integer range 0 to C_MAX;

begin

    p_counter : process (clk) is
    begin
        if rising_edge(clk) then
            if rst = '1' then
                sig_cnt <= 0; 

            elsif en_inc = '1' then
                if sig_cnt = C_MAX then
                    sig_cnt <= 0;
                else
                    sig_cnt <= sig_cnt + 1;
                end if;

            elsif en_dec = '1' then
                if sig_cnt = 0 then
                    sig_cnt <= C_MAX;
                else
                    sig_cnt <= sig_cnt - 1;
                end if;
            end if;
        end if;
    end process p_counter;

    slot_idx <= std_logic_vector(to_unsigned(sig_cnt, G_BITS));

end architecture behavioral;