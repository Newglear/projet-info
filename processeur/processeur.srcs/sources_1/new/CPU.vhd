----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.05.2023 18:11:32
-- Design Name: 
-- Module Name: CPU - Behavioral
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

entity CPU is
    Port (
    Clock: in STD_LOGIC
    );
end CPU;

architecture Behavioral of CPU is
component sync is  Port (
   A_IN, OP_IN, B_IN, C_IN : in STD_LOGIC_VECTOR( 7 downto 0);
   A_OUT, OP_OUT, B_OUT, C_OUT : out STD_LOGIC_VECTOR( 7 downto 0);
   Clock: in STD_LOGIC
 );
 end component;
 
 component compteur_8bits is 
 Port ( Clock : in STD_LOGIC;
        RST : in STD_LOGIC;
        LOAD : in STD_LOGIC;
        SENS :  in STD_LOGIC;
        EN : in STD_LOGIC;
        DIN : in STD_LOGIC_VECTOR (7 downto 0);
        DOUT : out STD_LOGIC_VECTOR (7 downto 0));
  end component;
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
 component LC is
 Port ( OP : in STD_LOGIC_VECTOR (7 downto 0); 
         W : out STD_LOGIC 
 );
 end component;
  component code_bench is 
  Port (
     adr : in STD_LOGIC_VECTOR (7 downto 0);
     Clock: in STD_LOGIC;  
     OUTPUT: out STD_LOGIC_VECTOR (31 downto 0)
     );
   end component;
   
   component MUX_DI is
       Port ( 
       OP : in STD_LOGIC_VECTOR (7 downto 0);
       B: in STD_LOGIC_VECTOR (7 downto 0) ;
       QA : in STD_LOGIC_VECTOR (7 downto 0);
       OUTPUT : out  STD_LOGIC_VECTOR (7 downto 0));
   end component;
   
   component ALU is
       Port ( A : in STD_LOGIC_VECTOR (7 downto 0);   
              B : in STD_LOGIC_VECTOR (7 downto 0);
              S : out STD_LOGIC_VECTOR (7 downto 0);
              N : out STD_LOGIC;
              O : out STD_LOGIC;
              Z : out STD_LOGIC;
              C : out STD_LOGIC;
              CTR : in STD_LOGIC_VECTOR (2 downto 0)
        );
   end component;
   component LC_ALU is
        Port ( 
           OP: in STD_LOGIC_VECTOR (7 downto 0);
           CTRL: out STD_LOGIC_VECTOR (2 downto 0)
        );
   end component;
   
    component MUX_EX is
        Port ( 
        OP: in STD_LOGIC_VECTOR(7 downto 0);
        B : in STD_LOGIC_VECTOR(7 downto 0);
        S : in STD_LOGIC_VECTOR(7 downto 0);
        OUTPUT: out STD_LOGIC_VECTOR(7 downto 0)
        );
   end component;
   
  
    signal IP: STD_LOGIC_VECTOR (7 downto 0);
    signal ASM_OUT: STD_LOGIC_VECTOR (31 downto 0);
    signal A_LI, OP_LI, B_LI, C_LI: STD_LOGIC_VECTOR (7 downto 0); 
    signal A_DI, OP_DI, B_DI, C_DI: STD_LOGIC_VECTOR (7 downto 0);
    signal A_EX, OP_EX, B_EX, C_EX: STD_LOGIC_VECTOR (7 downto 0); 
    signal A_MEM, OP_MEM, B_MEM, C_MEM: STD_LOGIC_VECTOR (7 downto 0); 
    signal A_RE, OP_RE, B_RE, C_RE: STD_LOGIC_VECTOR (7 downto 0); 
    signal WB : STD_LOGIC;
    signal QA,QB, OUT_DI,OUT_EX: STD_LOGIc_VECTOR (7 downto 0 );
    signal S_EX: STD_LOGIc_VECTOR (7 downto 0 );
    signal CTRL_ALU: sTD_LOGIC_VECTOR (2 downto 0);
    
    --signal Clock: STD_LOGIC := '0';
   
begin

    
    REGS: registers port map (atA => B_DI(3 downto 0),
                atB => C_DI(3 downto 0),
                atW => A_RE(3 downto 0),
                W => WB, 
                DATA => B_RE, 
                RST=>  '1',
                QA => QA, 
                QB => QB,
                Clock => clock);
    ASM: code_bench port map (
        adr => IP,
        Clock => Clock, 
        OUTPUT => ASM_OUT
    );
    OP_LI <= ASM_OUT(31 downto 24);
    A_LI <= ASM_OUT(23 downto 16);
    B_LI <= ASM_OUT(15 downto 8);
    C_LI <= ASM_OUT(7 downto 0);
        
        
    CONT: compteur_8bits port map ( 
        Clock => Clock,
        RST => '1',
        LOAD => '0',
        SENS => '1',
        EN => '1',
        DIN => x"00",
        DOUT => IP
    );

    LIDI: sync port map(
        A_IN => A_LI,
        OP_IN => OP_LI,
        B_IN => B_LI,
        C_IN => C_LI,
        A_OUT => A_DI,
        OP_OUT => OP_DI,
        B_OUT => B_DI,
        C_OUT => C_DI,
        Clock => Clock 
    );
    
    DI_MUX : MUX_DI port map (
        OP => OP_DI,
        B  => B_DI ,
        QA => QA,
        OUTPUT => OUT_DI
    );
    ALU_LC : LC_ALU port map(
        OP => OP_EX,
        CTRL => CTRL_ALU
        );
    UAL : ALU Port Map ( A => B_EX,   
                  B => C_EX,
                  S => S_EX,
                  N => open,
                  O => open,
                  Z => open,
                  C => open,
                  CTR => CTRL_ALU
            );
   EX_MUX: MUX_EX port map(
                OP => OP_EX,
                B  => B_EX,
                S => S_EX,
                OUTPUT => OUT_EX
            );
    
    DIEX: sync port map(
        A_IN => A_DI,
        OP_IN => OP_DI,
        B_IN => OUT_DI,
        C_IN => QB,
        A_OUT => A_EX,
        OP_OUT => OP_EX,
        B_OUT => B_EX,
        C_OUT => C_EX,
        Clock => Clock 
    );
    EXMEM: sync port map(
        A_IN => A_EX,
        OP_IN => OP_EX,
        B_IN => OUT_EX,
        C_IN => C_EX,
        A_OUT => A_MEM,
        OP_OUT => OP_MEM,
        B_OUT => B_MEM,
        C_OUT => C_MEM,
        Clock => Clock 
    );
    MEMRE: sync port map(
        A_IN => A_MEM,
        OP_IN => OP_MEM,
        B_IN => B_MEM,
        C_IN => C_MEM,
        A_OUT => A_RE,
        OP_OUT => OP_RE,
        B_OUT => B_RE,
        C_OUT => C_RE,
        Clock => Clock 
    );
    writeback: LC port map (
        OP => OP_RE, 
        W => WB
    );
    

end Behavioral;
