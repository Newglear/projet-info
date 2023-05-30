----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 30.05.2023 10:49:15
-- Design Name: 
-- Module Name: REGS_BLOCKER - Behavioral
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

entity REGS_BLOCKER is
  Port ( 
    A_IN,OP_IN: in STD_LOGIC_VECTOR(7 downto 0);  
    A_OUT,OP_OUT: in STD_LOGIC_VECTOR(7 downto 0);
    REGS_BLOCKED: out STD_LOGIC_VECTOR(15 downto 0):=x"0000" 
  );
end REGS_BLOCKER;

architecture Behavioral of REGS_BLOCKER is
signal a,b: positive;
signal c,d: std_logic; 
signal aux: STD_LOGIC_VECTOR(15 downto 0) := x"0000";

begin
process(A_IN,A_OUT)
begin
    
    if(A_IN /= A_OUT) then 
        if(OP_IN /= x"00") then 
            REGS_BLOCKED(conv_integer(A_IN)) <= '1';
        end if; 
        if(OP_OUT/= x"00") then
            REGS_BLOCKED(conv_integer(A_OUT)) <= '0'; 
        end if;
    else 
        if(OP_IN /= x"00") then
            REGS_BLOCKED(conv_integer(A_IN)) <= '0';    -- TODO A réfléchir sur la libération
        end if;  
    end if;
end process;
    a <= conv_integer(A_OUT); 
    b <= conv_integer(A_IN); 
    c <= '1' when A_IN /= A_OUT else '0'; -- Du Débug très sale
end Behavioral;
