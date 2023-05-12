----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.05.2023 10:53:14
-- Design Name: 
-- Module Name: ALU_Test - Behavioral
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

entity ALU_Test is
end ALU_Test;

architecture Behavioral of ALU_Test is
    component ALU is
    Port ( A : in STD_LOGIC_VECTOR (7 downto 0);   
           B : in STD_LOGIC_VECTOR (7 downto 0);
           S : out STD_LOGIC_VECTOR (7 downto 0);
           N : out STD_LOGIC;
           O : out STD_LOGIC;
           Z : out STD_LOGIC;
           C : out STD_LOGIC;
           CTR : in STD_LOGIC_VECTOR (2 downto 0)
     );
    end component;
    
    signal a, b, s : std_logic_vector(7 downto 0);
    signal ctr : std_logic_vector(2 downto 0);
    signal n, o, z, c : std_logic;
    
begin
    ula : ALU port map(a,b,s,n,o,z,c,ctr);
    
    a <= x"05", x"F" after 2ns;
    b <= x"02" ;
    ctr <= "000", "001" after 10ns, "010" after 20ns;
    
   
        
   
end Behavioral;
