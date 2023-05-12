----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.05.2023 10:59:52
-- Design Name: 
-- Module Name: registers - Behavioral
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

entity registers is
    Port ( atA: in STD_LOGIC_VECTOR(3 downto 0);
           atB: in STD_LOGIC_VECTOR(3 downto 0);
           atW: in STD_LOGIC_VECTOR(3 downto 0);
           W: in STD_LOGIC;
           DATA: in STD_LOGIC_VECTOR(7 downto 0);
           RST: in STD_LOGIC;
           Clock: in STD_LOGIC;
           QA:  out STD_LOGIC_VECTOR(7 downto 0);
           QB: out STD_LOGIC_VECTOR(7 downto 0)
    );
end registers;

architecture Behavioral of registers is
    type reg_vector is array(0 to 15) of STD_LOGIC_VECTOR(7 downto 0);
    signal regs: reg_vector;
signal auxA,auxB : STD_LOGIC_VECTOR(7 downto 0) := x"00"; 
begin
    process begin
         wait until Clock'Event and Clock='1';
         if RST = '0' then
            regs <= (others => x"00");
         else
             if W = '1' then
                regs(conv_integer(atW)) <= DATA;
             end if;
        end if;
         
    end process;
    QA <= regs(conv_integer(atA)) when atW /= atA else DATA;
    QB <= regs(conv_integer(atB)) when atW /= atB else DATA;
end Behavioral;
