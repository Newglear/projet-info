----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.05.2023 17:00:12
-- Design Name: 
-- Module Name: data_bench - Behavioral
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

entity data_bench is
      Port (
      adr : in STD_LOGIC_VECTOR (7 downto 0);
      INPUT:in STD_LOGIC_VECTOR (7 downto 0);
      RW: in STD_LOGIC; 
      RST: in STD_LOGIC;
      Clock: in STD_LOGIC;  
      OUTPUT: out STD_LOGIC_VECTOR (7 downto 0)
      );
end data_bench;

architecture Behavioral of data_bench is
type memory_struct is array(0 to 255) of STD_LOGIC_VECTOR(7 downto 0);
signal memory: memory_struct := (others => x"00");
signal aux: STD_LOGIC_VECTOR (7 downto 0); 
begin
process
begin 
    wait until Clock'event and Clock = '1'; 
    if RST = '1' then 
    -- Reset
        memory <= (others => x"00");
    else
        if RW = '1' then -- READ
            aux <= memory(conv_integer(adr)); 
        else -- WRITE
            memory(conv_integer(adr)) <= INPUT; 
        end if; 
    end if;     
end process; 
OUTPUT <= aux; 
end Behavioral;
