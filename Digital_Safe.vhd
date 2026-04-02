----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/02/2026 05:21:04 PM
-- Design Name: 
-- Module Name: Digital_Safe - Behavioral
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
use IEEE.NUMERIC_STD.ALL;


entity Digital_Safe is
    Port ( sw : in STD_LOGIC_VECTOR (3 downto 0);
           btnu: in STD_LOGIC;
           btnd: in STD_LOGIC;
           clk: in STD_LOGIC;
           seg : out STD_LOGIC_VECTOR (6 downto 0);
           dp : out STD_LOGIC;
           an : out STD_LOGIC_VECTOR (7 downto 0)
          );
          
end Digital_Safe;

architecture Behavioral of Digital_Safe is

component clk_en is
        generic ( G_MAX : positive );
        port (
            clk : in  std_logic;
            rst : in  std_logic;
            ce  : out std_logic
        );
end component clk_en;

component Bin_2_Seg is
        Port ( 
            bin : in STD_LOGIC_VECTOR (3 downto 0);
            seg : out STD_LOGIC_VECTOR (6 downto 0)
        );
end component Bin_2_Seg;



constant SECRET_1:
    STD_LOGIC_VECTOR (3 downto 0) := x"1";
constant SECRET_2:
    STD_LOGIC_VECTOR (3 downto 0) := x"2";
constant SECRET_3:
    STD_LOGIC_VECTOR (3 downto 0) := x"3";
constant SECRET_4:
    STD_LOGIC_VECTOR (3 downto 0) := x"4";
    
type t_state is (S_IDLE, S_DIG1, S_DIG2, S_DIG3, S_DIG4, S_EVAL, S_OPEN, S_ERR);

signal state                    : t_state := S_IDLE;
signal reg1, reg2, reg3, reg4   : STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
signal cnt_div                  : unsigned (19 downto 0) := (others => '0');
signal btnu_reg                 : STD_LOGIC_VECTOR (1 downto 0) := "00";  

begin


end Behavioral;
