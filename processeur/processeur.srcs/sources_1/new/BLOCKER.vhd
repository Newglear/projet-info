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
    FLUSH: in STD_LOGIC; 
    EN_FLAG: out STD_LOGIC := '1';
    Clock: in STD_Logic
  );
end BLOCKER;


-- ADD = x"01"
-- MUL = x"02"
-- SOU = x"03"
-- DIV = x"04"|| Not implemented
-- COP = x"05"
-- AFC = x"06" 
-- LOAD= x"07" 
-- STORE=x"08" 
-- JUMP= x"09" 
-- JNE= x"0a" 
-- ADDM = x"0b"
-- MULM = x"0c"
-- SOUM = x"0d"
-- DIVM = x"0e"  || Not implemented
architecture Behavioral of BLOCKER is
signal blocked: STD_LOGIC_VECTOR(15 downto 0) := x"0000"; 
signal OP,A,B,C: STD_LOGIC_VECTOR(7 downto 0) := x"00"; 
begin
    process(ASM,A_RE,Clock,FLUSH)
    begin
        if(FLUSH /= '1') then 
            OP <= ASM(31 downto 24);
            A  <= ASM(23 downto 16);
            B  <= ASM(15 downto 8);
            C  <= ASM(7 downto 0);
            if(ASM /= x"00000000" ) then
    
                if( OP = x"06" or OP = x"07") then -- Gestion de A : AFC LOAD
                    if(blocked(conv_integer(A)) = '1') then  
                        OUT_ASM <= x"00000000";                    
                    else
                        blocked(conv_integer(A)) <= '1';
                        OUT_ASM <= ASM;
                    end if;
                elsif(OP = x"08") then -- Gestion de B: Store 
                    if(blocked(conv_integer(B)) = '1') then  
                        OUT_ASM <= x"00000000";
                    else
                        OUT_ASM <= ASM;
                    end if;
                elsif(OP = x"05" or OP = x"0b" or OP = x"0c" or OP = x"0d" or OP = x"0e" ) then -- Gestion de A+B:COP,ADDN, MULN,SOUN,DIVN            
                    if(blocked(conv_integer(A)) = '1' or blocked(conv_integer(B)) = '1') then  
                        OUT_ASM <= x"00000000";
                    else
                        blocked(conv_integer(A)) <= '1';
                        OUT_ASM <= ASM;
                    end if;
                    
                elsif(OP = x"01" or OP = x"02" or OP = x"03" or OP = x"04" ) then -- Gestion de A+B+C: ADD, MUL, SOU, DIV
                    if(blocked(conv_integer(A)) = '1' or blocked(conv_integer(B)) = '1' or blocked(conv_integer(C)) = '1') then  
                        OUT_ASM <= x"00000000";
                    else
                        blocked(conv_integer(A)) <= '1';
                        OUT_ASM <= ASM;
                    end if;
                    
                else -- JMP, JNE
                    OUT_ASM <= ASM;
                end if;
                
            else
                OUT_ASM <= ASM; 
            end if;
           
            if(OP_RE /= x"00") then
                blocked(conv_integer(A_RE)) <= '0';  
            end if; 
            
            if( OP = x"06" or OP = x"07") then -- Gestion de A : AFC LOAD
                if(blocked(conv_integer(A)) = '1') then  
                    EN_FLAG <= '0';
                else
                    EN_FLAG <= '1'; 
                end if;
            elsif(OP = x"08") then -- Gestion de B: Store 
                if(blocked(conv_integer(B)) = '1') then  
                    EN_FLAG <= '0';
                else
                    EN_FLAG <= '1'; 
                end if;
            elsif(OP = x"05" or OP = x"0b" or OP = x"0c" or OP = x"0d" or OP = x"0e" ) then -- Gestion de A+B:COP,ADDN, MULN,SOUN,DIVN            
                if(blocked(conv_integer(A)) = '1' or blocked(conv_integer(B)) = '1') then  
                    EN_FLAG <= '0';
                else
                    EN_FLAG <= '1'; 
                end if;
                
            elsif(OP = x"01" or OP = x"02" or OP = x"03" or OP = x"04" ) then -- Gestion de A+B+C: ADD, MUL, SOU, DIV
                if(blocked(conv_integer(A)) = '1' or blocked(conv_integer(B)) = '1' or blocked(conv_integer(C)) = '1') then  
                    EN_FLAG <= '0';
                else
                    EN_FLAG <= '1'; 
                end if;
            else
                EN_FLAG <= '1';
            end if;
        else
            blocked <= x"0000";
        end if; 
    end process; 
   
    
    


end Behavioral;
