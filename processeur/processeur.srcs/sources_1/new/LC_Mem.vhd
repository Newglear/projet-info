----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 28.05.2023 15:10:46
-- Design Name: 
-- Module Name: LC_Mem - Behavioral
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

entity LC_Mem is
Port ( 
        OP: in STD_LOGIC_VECTOR (7 downto 0);
        OUTPUT: out STD_LOGIC
     );
end LC_Mem;

architecture Behavioral of LC_Mem is

begin
    OUTPUT <= '0' when OP = x"08" else '1'; 
end Behavioral;
