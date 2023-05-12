----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.05.2023 17:44:14
-- Design Name: 
-- Module Name: sync - Behavioral
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

entity sync is
 Port (
    A_IN, OP_IN, B_IN, C_IN : in STD_LOGIC_VECTOR( 7 downto 0);
    A_OUT, OP_OUT, B_OUT, C_OUT : out STD_LOGIC_VECTOR( 7 downto 0);
    Clock: STD_LOGIC
  );
end sync;

architecture Behavioral of sync is

begin
process begin
    wait until Clock'Event and Clock = '1';
    A_OUT <= A_IN;
    OP_OUT <= OP_IN;
    B_OUT <= B_IN;
    C_OUT <= C_IN;
end process;

end Behavioral;
