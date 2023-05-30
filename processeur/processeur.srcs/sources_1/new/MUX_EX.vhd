----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.05.2023 15:11:42
-- Design Name: 
-- Module Name: MUX_EX - Behavioral
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

entity MUX_EX is
    Port ( 
        OP: in STD_LOGIC_VECTOR(7 downto 0);
        B : in STD_LOGIC_VECTOR(7 downto 0);
        S : in STD_LOGIC_VECTOR(7 downto 0);
        OUTPUT: out STD_LOGIC_VECTOR(7 downto 0)
    );
end MUX_EX;

architecture Behavioral of MUX_EX is

begin
    OUTPUT <= S when OP = x"01" or OP = x"02" or OP = x"03" or OP = x"04"  or OP = x"0b" or OP = x"0c" or OP = x"0d" or OP = x"0e" else  B;

end Behavioral;
