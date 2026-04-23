library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;

entity clk_en is
    generic (
        G_MAX : positive := 5
    );
    port (
        clk : in  std_logic;
        rst : in  std_logic;
        ce  : out std_logic
    );
end entity clk_en;

architecture Behavioral of clk_en is

    signal sig_cnt : integer range 0 to G_MAX-1;

begin

synchronous_process: process (clk) is
begin
    if rising_edge(clk) then
        if rst = '1' then
            ce      <= '0';
            sig_cnt <= 0;
            
        elsif sig_cnt = G_MAX - 1 then
            sig_cnt <= 0;
            ce      <= '1';
            
        else
            ce      <= '0';
            sig_cnt <= sig_cnt +1;
        
        end if;
    end if; 

end process;

end Behavioral;