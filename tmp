----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 21.03.2023 15:55:39
-- Design Name: 
-- Module Name: compteur_8bits - Behavioral
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

entity compteur_8bits is
    Port ( Clock : in STD_LOGIC;
           RST : in STD_LOGIC;
           LOAD : in STD_LOGIC;
           SENS :  in STD_LOGIC;
           EN : in STD_LOGIC;
           DIN : in STD_LOGIC_VECTOR (7 downto 0);
           DOUT : out STD_LOGIC_VECTOR (7 downto 0));
end compteur_8bits;

architecture Behavioral of compteur_8bits is
    signal aux : STD_LOGIC_VECTOR (7 downto 0) := x"00";
begin
    process
    begin
        wait until Clock'Event and Clock='1';
        if RST='0' then
            aux <= x"00";
        elsif LOAD='1' then
            aux <= DIN;
        elsif EN='1' then
            if SENS='1' then
                aux <= aux + x"01";
            else
                aux <= aux - x"01";
            end if;
        end if;
    end process;
    DOUT <= aux;
end Behavioral;
