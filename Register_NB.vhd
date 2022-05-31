library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.all;

entity Register_NB is
    Generic (N: integer:= 16);
    port (
        clk, rst, en, flush : IN std_logic;

        InPort       : IN  std_logic_vector (N-1 downto 0);
        OutPort      : OUT std_logic_vector (N-1 downto 0)

    );
end entity Register_NB;

architecture rtl of Register_NB is
    
begin
    
   proc_name: process(clk, rst)
   begin
       if rst = '1' then

        OutPort <= (Others => '0');
           
       elsif rising_edge(clk) and en = '1' then

        if flush = '1' then
            OutPort <= (Others => '0');
        else 
            OutPort <= InPort;
        end if ;
               
       end if;
   end process proc_name;
    
end architecture rtl;