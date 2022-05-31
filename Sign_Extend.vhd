library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.all;

entity Sign_Extend is
    port (
        in1  :  IN std_logic_vector(15 downto 0);
        out1 : OUT std_logic_vector(31 downto 0)
    );
end entity Sign_Extend;

architecture rtl of Sign_Extend is
    
begin
    
   proc_name: process(in1)
   begin

        out1 <= (31 downto 16 => in1(15)) & in1;
       
   end process proc_name;
    
end architecture rtl;