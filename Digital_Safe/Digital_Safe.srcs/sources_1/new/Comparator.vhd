library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Comparator is
    Port ( 
        clk        : in  STD_LOGIC;
        rst        : in  STD_LOGIC;
        code_in    : in  STD_LOGIC_VECTOR (15 downto 0);
        lock_open  : out STD_LOGIC;
        lock_close : out STD_LOGIC  
    );
end Comparator;

architecture Behavioral of Comparator is

    constant C_SECRET_PIN : std_logic_vector(15 downto 0) := x"AbCd";

begin

    p_compare : process (clk) is
    begin
        if rising_edge(clk) then
            if rst = '1' then
                lock_open  <= '0';
                lock_close <= '1';
            else
                if (code_in = C_SECRET_PIN) then
                    lock_open  <= '1'; 
                    lock_close <= '0'; 
                else
                    lock_open  <= '0';
                    lock_close <= '1'; 
                end if;
            end if;
        end if;
    end process p_compare;

end Behavioral;