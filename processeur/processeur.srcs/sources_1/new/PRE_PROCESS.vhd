----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.05.2023 14:31:08
-- Design Name: 
-- Module Name: PRE_PROCESS - Behavioral
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

entity PRE_PROCESS is
  Port ( 
  OP: in STD_LOGIC_VECTOR( 7 downto 0);
  ZERO_FLAG: in STD_LOGIC;
  FLUSH: out STD_LOGIC := '0';
  Clock: in STD_LOGIC
  );
end PRE_PROCESS;

architecture Behavioral of PRE_PROCESS is
signal ZERO_FLAG_T1: STD_LOGIC;
begin
    process
    begin
        wait until Clock'event and Clock = '1';
        ZERO_FLAG_T1 <= ZERO_FLAG;
    end process;
    FLUSH <= '1' when OP= x"09" or (OP= x"0A" and ZERO_FLAG_T1 = '0') else '0'; -- Jump or JNE
end Behavioral;
