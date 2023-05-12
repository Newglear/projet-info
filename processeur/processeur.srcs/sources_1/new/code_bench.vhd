----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.05.2023 17:00:36
-- Design Name: 
-- Module Name: code_bench - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity code_bench is
  Port (
    adr : in STD_LOGIC_VECTOR (7 downto 0);
    Clock: in STD_LOGIC;  
    OUTPUT: out STD_LOGIC_VECTOR (7 downto 0)
    );
end code_bench;

architecture Behavioral of code_bench is
type memory_struct is array(0 to 255) of STD_LOGIC_VECTOR(31 downto 0);
signal memory: memory_struct;
begin
process
begin 
    wait until Clock'event and Clock = '1'; 
    OUTPUT <= memory(conv_integer(adr));
end process; 

end Behavioral;
