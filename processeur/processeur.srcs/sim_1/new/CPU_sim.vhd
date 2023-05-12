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
component sync is  Port (
   A_IN, OP_IN, B_IN, C_IN : in STD_LOGIC_VECTOR( 7 downto 0);
   A_OUT, OP_OUT, B_OUT, C_OUT : out STD_LOGIC_VECTOR( 7 downto 0);
   Clock: STD_LOGIC
 );
 end component;
    signal A_LI, OP_LI, B_LI, C_LI: STD_LOGIC_VECTOR (7 downto 0); 
    signal A_DI, OP_DI, B_DI, C_DI: STD_LOGIC_VECTOR (7 downto 0);
    signal A_EX, OP_EX, B_EX, C_EX: STD_LOGIC_VECTOR (7 downto 0); 
    signal Clock: STD_LOGIC := '0';

begin
    LIDI: sync port map(A_LI, OP_LI, B_LI, C_LI, A_DI, OP_DI, B_DI, C_DI, Clock );
    DIEX: sync port map(A_DI, OP_DI, B_DI, C_DI, A_EX, OP_EX, B_EX, C_EX, Clock );
    
    clock <= not clock after 10ns;
    A_LI <= x"00", x"0f" after 20ns, x"aa" after 31ns;
    


end Behavioral;

