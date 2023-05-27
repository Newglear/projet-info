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
    OUTPUT: out STD_LOGIC_VECTOR (31 downto 0)
    );
end code_bench;
-- ADD = x"01"
-- MUL = x"02"
-- SOU = x"03"
-- DIV = x"04"
-- COP = x"05"
-- AFC = x"06" 

architecture Behavioral of code_bench is
type memory_struct is array(0 to 255) of STD_LOGIC_VECTOR(31 downto 0);
signal memory: memory_struct := (
    0 => x"06_03_02_00", 
    1 => x"06_04_09_00", 
    2 => x"06_05_01_00", 
    3 => x"06_06_0B_00",
    4 => x"00_00_00_00",
    5 => x"00_00_00_00",
    6 => x"00_00_00_00",
    7 => x"00_00_00_00",
    --8 => x"05_03_05_00",
    --9 => x"00_00_00_00",
    --10=> x"00_00_00_00",
    --11=> x"00_00_00_00",
    --12=> x"00_00_00_00",
    8 => x"01_03_03_05", 
    9 => x"03_03_03_05",
    10=> x"02_03_03_05", 
    others => x"00_00_00_00"
    );
begin
process
begin 
    wait until Clock'event and Clock = '1'; 
    OUTPUT <= memory(conv_integer(adr));
end process; 

end Behavioral;
