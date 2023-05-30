----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.05.2023 15:02:53
-- Design Name: 
-- Module Name: LC_ALU - Behavioral
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

entity LC_ALU is
     Port ( 
        OP: in STD_LOGIC_VECTOR (7 downto 0);
        CTRL: out STD_LOGIC_VECTOR (2 downto 0)
     );
end LC_ALU;

architecture Behavioral of LC_ALU is
begin
    CTRL <= "001" when OP = x"03" or OP = x"0d" else -- SOU or SOUM
            "010" when OP = x"02" or OP = x"0c" else -- MUL or MULM
            "000";
end Behavioral;
