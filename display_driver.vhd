library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity display_driver is
    Port ( 
        clk     : in  STD_LOGIC;
        rst     : in  STD_LOGIC;
        data_in : in  STD_LOGIC_VECTOR (15 downto 0);
        seg     : out STD_LOGIC_VECTOR (6 downto 0);
        anode   : out STD_LOGIC_VECTOR (3 downto 0);
        idx_pos : in  STD_LOGIC_VECTOR (1 downto 0); -- From Counter
        dp      : out STD_LOGIC                      -- Decimal Point
    );
end display_driver;

architecture Behavioral of display_driver is

    -- Clock enable for refresh timing (approx 1kHz)
    component clk_en is
        generic ( G_MAX : positive );
        port (
            clk : in  std_logic;
            rst : in  std_logic;
            ce  : out std_logic
        );
    end component clk_en;
        
    -- 2-bit counter to cycle through 4 displays
    component counter is
        generic ( G_BITS : positive );
        port (
            clk : in  std_logic;
            rst : in  std_logic;
            en  : in  std_logic;
            cnt : out std_logic_vector(G_BITS - 1 downto 0)
        );
    end component counter;
    
    -- BCD to 7-Segment Decoder
    component Bin_2_Seg is
        Port ( 
            bin : in  STD_LOGIC_VECTOR (3 downto 0);
            seg : out STD_LOGIC_VECTOR (6 downto 0)
        );
    end component Bin_2_Seg;
    
    -- Internal signals
    signal sig_en    : std_logic;
    signal sig_digit : std_logic_vector(1 downto 0); -- Now 2 bits for 4 digits
    signal sig_bin   : std_logic_vector(3 downto 0);
  
begin

    -- Refresh rate generator
    clock_0 : clk_en
        generic map ( G_MAX => 100_000) -- Adjust for ~1ms refresh on 100MHz clock
        port map (
            clk => clk,
            rst => rst,
            ce  => sig_en
        );
        
    -- Digit selector counter (00 -> 01 -> 10 -> 11)
    counter_0 : counter
        generic map ( G_BITS => 2 )
        port map (
            clk => clk,
            rst => rst,
            en  => sig_en,
            cnt => sig_digit
        );

    ------------------------------------------------------------------------
    -- 16-bit to 4-bit Multiplexer
    ------------------------------------------------------------------------
    with sig_digit select
        sig_bin <= data_in(3 downto 0)   when "00", -- Far Right
                   data_in(7 downto 4)   when "01", -- Mid Right
                   data_in(11 downto 8)  when "10", -- Mid Left
                   data_in(15 downto 12) when others; -- Far Left

    -- Hex to 7-segment decoder
    bin2seg0 : Bin_2_Seg
        port map (
            bin => sig_bin,
            seg => seg
        );

    ------------------------------------------------------------------------
    -- Anode Selection & Decimal Point Cursor
    ------------------------------------------------------------------------
    p_display_control : process (sig_digit, idx_pos) is
    begin
        -- Default: All displays off (Active High '1' = OFF for Nexys)
        anode <= "1111";
        dp    <= '1'; -- '1' is OFF on most Nexys boards
        
        -- Activate current anode based on refresh counter
        case sig_digit is
            when "00" => anode <= "1110"; -- Rightmost
            when "01" => anode <= "1101";
            when "10" => anode <= "1011";
            when "11" => anode <= "0111"; -- Leftmost
            when others => anode <= "1111";
        end case;

        -- Cursor Logic: If the refreshing digit is the one being edited, light the DP
        if (sig_digit = idx_pos) then
            dp <= '0'; -- '0' is ON
        else
            dp <= '1'; -- '1' is OFF
        end if;
        
    end process p_display_control;

end Behavioral;
