----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.05.2023 15:45:54
-- Design Name: 
-- Module Name: regs_Test - Behavioral
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

entity regs_Test is
--  Port ( );
end regs_Test;

architecture Behavioral of regs_Test is
    component registers is 
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
    end component;
        
    signal atA, atB, atW : std_logic_vector(3 downto 0);
    signal DATA, QA, QB :  STD_LOGIC_VECTOR(7 downto 0);
    signal W, RST,Clock: STD_LOGIC := '0';
    
begin
    regs : registers port map (atA, atB, atW, W, DATA, RST, Clock, QA, QB);

    Clock <= not Clock after 1ns; 
    RST <= '1', '0' after 500ns, '1' after 510ns; 
    W <= '1'  after 150ns, '0' after 180ns, '1' after 220ns, '0' after 250ns; 
    atW <= "0010" after 100ns, "0100" after 200ns, "0011" after 300ns,"1000" after 600ns;
    DATA <= x"ff" after 100ns, x"0a" after 200ns; 
    atB <= "0010", "1000" after 600ns ;
    atA <= "0100","1000" after 600ns ;
    
end Behavioral;
