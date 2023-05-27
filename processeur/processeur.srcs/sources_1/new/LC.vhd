----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.05.2023 14:04:05
-- Design Name: 
-- Module Name: LC - Behavioral
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

entity LC is
Port ( OP : in STD_LOGIC_VECTOR (7 downto 0); 
        W : out STD_LOGIC 
);
end LC;

architecture Behavioral of LC is

begin
W <= '1' when 
    OP = x"05" or --COP
    OP = x"06" or --AFC
    OP = x"01" or -- ADD
    OP = x"02" or -- MUL
    OP = x"03" or -- SOU
    OP = x"04"    -- DIV
    else '0';

end Behavioral;
