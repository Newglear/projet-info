----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 30.05.2023 15:26:27
-- Design Name: 
-- Module Name: BLOCKER - Behavioral
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

entity BLOCKER is
  Port (
    ASM :in STD_LOGIC_VECTOR(31 downto 0);
    OUT_ASM: out STD_LOGIC_VECTOR(31 downto 0);
    A_RE, OP_RE:in STD_LOGIC_VECTOR(7 downto 0);
    EN_FLAG: out STD_LOGIC := '1'
  );
end BLOCKER;

architecture Behavioral of BLOCKER is
signal blocked: STD_LOGIC_VECTOR(15 downto 0) := x"0000"; 
signal TT : STD_LOGIC; 
begin
    process(ASM,A_RE)
    begin
        if(ASM /= x"00000000") then 
            if(blocked(conv_integer(ASM(23 downto 16))) = '1') then 
                OUT_ASM <= x"00000000";
            else
                blocked(conv_integer(ASM(23 downto 16))) <= '1';
                OUT_ASM <= ASM;
            end if;
        else
            OUT_ASM <= ASM; 
        end if;
       
        if(OP_RE /= x"00") then
            blocked(conv_integer(A_RE)) <= '0';  
        end if; 
        if(blocked(conv_integer(ASM(23 downto 16))) = '1'  ) then
            EN_FLAG <= '0';
        else 
            EN_FLAG <= '1'; 
        end if; 
    end process; 
   
    
    


end Behavioral;
