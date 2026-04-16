library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity display_driver is
    Port ( 
        clk      : in  STD_LOGIC;
        rst      : in  STD_LOGIC;
        data_in  : in  STD_LOGIC_VECTOR (15 downto 0);
        sw_in    : in  STD_LOGIC_VECTOR (3 downto 0);
        seg      : out STD_LOGIC_VECTOR (6 downto 0);
        anode    : out STD_LOGIC_VECTOR (3 downto 0);
        idx_pos  : in  STD_LOGIC_VECTOR (1 downto 0); 
        dp       : out STD_LOGIC                      
    );
end display_driver;

architecture Behavioral of display_driver is

    component clk_en is
        generic ( G_MAX : positive );
        port ( clk, rst : in std_logic; ce : out std_logic );
    end component;
        
    component counter is
        generic ( G_BITS : positive );
        port ( clk, rst, en_dec, en_inc : in std_logic; slot_idx : out std_logic_vector(G_BITS - 1 downto 0) );
    end component;
    
    component Bin_2_Seg is
        Port ( bin : in STD_LOGIC_VECTOR (3 downto 0); seg : out STD_LOGIC_VECTOR (6 downto 0) );
    end component;
    
    signal sig_en    : std_logic;
    signal sig_digit : std_logic_vector(1 downto 0); 
    signal sig_bin   : std_logic_vector(3 downto 0);
  
begin

    clock_0 : clk_en
        generic map ( G_MAX => 100_000 ) 
        port map ( clk => clk, rst => rst, ce => sig_en );
        
    counter_0 : counter
        generic map ( G_BITS => 2 )
        port map ( clk => clk, rst => rst, en_dec => '0', en_inc => sig_en, slot_idx => sig_digit );

    p_mux_preview : process(sig_digit, idx_pos, data_in, sw_in)
    begin
        if (sig_digit = idx_pos) then
            sig_bin <= sw_in;
        else
            case sig_digit is
                when "00" => sig_bin <= data_in(3 downto 0);
                when "01" => sig_bin <= data_in(7 downto 4);
                when "10" => sig_bin <= data_in(11 downto 8);
                when others => sig_bin <= data_in(15 downto 12);
            end case;
        end if;
    end process p_mux_preview;

    bin2seg0 : Bin_2_Seg
        port map ( bin => sig_bin, seg => seg );

    p_display_control : process (clk) is
    begin
        if rising_edge(clk) then
            if rst = '1' then
                anode <= "1111";
                dp    <= '1';
            else
                case sig_digit is
                    when "00" => anode <= "1110"; 
                    when "01" => anode <= "1101";
                    when "10" => anode <= "1011";
                    when "11" => anode <= "0111"; 
                    when others => anode <= "1111";
                end case;

                if (sig_digit = idx_pos) then
                    dp <= '0';
                else
                    dp <= '1'; 
                end if;
            end if;
        end if;
    end process p_display_control;

end Behavioral;