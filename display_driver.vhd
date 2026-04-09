----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/12/2026 04:58:49 PM
-- Design Name: 
-- Module Name: display_driver - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity display_driver is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           data_in : in STD_LOGIC_VECTOR (15 downto 0);
           seg : out STD_LOGIC_VECTOR (6 downto 0);
           anode : out STD_LOGIC_VECTOR (3 downto 0);
           idx_pos : in std_logic_vector (1 downto 0);
           dp : out std_logic);
end display_driver;

architecture Behavioral of display_driver is

-- Component declaration for clock enable
    component clk_en is
        generic ( G_MAX : positive );
        port (
            clk : in  std_logic;
            rst : in  std_logic;
            ce  : out std_logic
        );
    end component clk_en;
       
-- Component declaration for binary counter
    component counter is
        generic ( G_BITS : positive );
        port (
            clk : in  std_logic;
            rst : in  std_logic;
            en  : in  std_logic;
            cnt : out std_logic_vector(G_BITS - 1 downto 0)
        );
    end component counter;
    
    component Bin_2_Seg is
        Port ( 
            bin : in STD_LOGIC_VECTOR (3 downto 0);
            seg : out STD_LOGIC_VECTOR (6 downto 0)
        );
    end component Bin_2_Seg;
    
-- Internal signals
    signal sig_en       : std_logic;
    signal sig_digit    : std_logic_vector(0 downto 0) := "0";
    signal sig_bin      : std_logic_vector(3 downto 0);
    -- TODO: Add other needed signals  
  
begin
    ------------------------------------------------------------------------
    -- Clock enable generator for refresh timing
    ------------------------------------------------------------------------
    clock_0 : clk_en
        generic map ( G_MAX => 1_000_000)  -- Adjust for flicker-free multiplexing
        port map (                   -- For simulation: 32
            clk => clk,              -- For implementation: 3_200_000
            rst => rst,
            ce  => sig_en
        );
        
   ------------------------------------------------------------------------
    -- N-bit counter for digit selection
   ------------------------------------------------------------------------
    counter_0 : counter
        generic map ( G_BITS => 1 )
        port map (
            clk => clk,
            rst => rst,
            en  => sig_en,
            cnt => sig_digit
        );

    ------------------------------------------------------------------------
    -- Digit select
    ------------------------------------------------------------------------
    sig_bin <= data(3 downto 0) when sig_digit = "0" else
               data(7 downto 4);

        
    -- Component instantiation of bin2seg
    bin2seg0 :  Bin_2_Seg
        port map (
            bin => sig_bin,  -- Connects internal counter to decoder input
            seg => seg       -- Connects decoder output to FPGA pins
        );

    ------------------------------------------------------------------------
    -- Anode select process
    ------------------------------------------------------------------------
    p_anode_select : process (sig_digit) is
    begin
        case sig_digit is
            when "0" =>
                anode <= "10";  -- Right digit active
                
            when "1" =>
                anode <= "01";    

            when others =>
                anode <= "11";  -- All off
        end case;
    end process;
end Behavioral;
