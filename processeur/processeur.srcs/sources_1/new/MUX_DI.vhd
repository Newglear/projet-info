----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.05.2023 14:27:32
-- Design Name: 
-- Module Name: MUX_DI - Behavioral
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

entity MUX_DI is
    Port ( 
    OP : in STD_LOGIC_VECTOR (7 downto 0);
    B: in STD_LOGIC_VECTOR (7 downto 0) ;
    QA : in STD_LOGIC_VECTOR (7 downto 0);
    OUTPUT : out  STD_LOGIC_VECTOR (7 downto 0));
end MUX_DI;

architecture Behavioral of MUX_DI is

begin
OUTPUT <= QA when OP = x"05" or OP = x"01" or OP = x"02" or OP = x"03" or OP = x"04" else B; -- x"05" => COP
end Behavioral;
