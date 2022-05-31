library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.all;

entity Hazard_Unit_Fetch is
    port (
        MemWrite, MEM_to_Reg, hlt_control_H, SP_or_PC : In std_logic;

        Buffer_En, PC_En, Mem_Add_Sel, SP_En          : Out std_logic
    );
end entity Hazard_Unit_Fetch;

architecture rtl of Hazard_Unit_Fetch is

    signal PC_En_temp : std_logic;
    
begin
   proc_name: process(MemWrite, MEM_to_Reg, SP_or_PC)
   begin

    if MemWrite = '1' or MEM_to_Reg = '1' then

        Buffer_En   <= '0';
        PC_En_temp  <= '0';
        Mem_Add_Sel <= '0';
    else
        Buffer_En   <= '1';
        PC_En_temp  <= '1';
        Mem_Add_Sel <= '1';
        
    end if ;

    if (SP_or_PC = '1') then 

        SP_En <= '1';
    else 
        
        SP_En <= '0';

    end if;
        
   end process proc_name;
    
    PC_En <= PC_En_temp and Not (hlt_control_H);
    
end architecture rtl;