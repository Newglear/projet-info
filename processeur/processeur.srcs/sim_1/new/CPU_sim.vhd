----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.05.2023 17:57:25
-- Design Name: 
-- Module Name: CPU_sim - Behavioral
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

entity CPU_sim is
end CPU_sim;

architecture Behavioral of CPU_sim is
component CPU is      
Port (
Clock: in STD_LOGIC
);
end component;

    signal Clock: STD_LOGIC := '0';

begin
    proco: CPU port map (Clock);

    clock <= not clock after 10ns;
  
end Behavioral;

