library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.all;

entity DataSelector is
    port (
        mem_write_control: in std_logic;
        sp_or_pc_control: in std_logic;
        call_control: in std_logic;
        int_control: in std_logic;

        from_reg1_out: in std_logic_vector(31 downto 0);
        from_reg2_out: in std_logic_vector(31 downto 0);
        from_pc_inc: in std_logic_vector(31 downto 0);
        from_ccr: in std_logic_vector(31 downto 0);

        mem_data: out std_logic_vector(31 downto 0)
    );
end entity DataSelector;

architecture DataSelectorArch of DataSelector is
    
begin
    address_selector : process(mem_write_control, sp_or_pc_control, call_control, int_control, from_reg1_out, from_reg2_out, from_pc_inc, from_ccr)
    begin
            if  (mem_write_control = '1' and sp_or_pc_control = '1' and int_control = '1' and call_control = '0') or 
                (mem_write_control = '1' and sp_or_pc_control = '1' and int_control = '0' and call_control = '1') then
                mem_data <= from_pc_inc;
            
            -- Like store instruction
            elsif (mem_write_control = '1' or sp_or_pc_control = '0') and int_control = '0' and call_control = '0' then
                mem_data <= from_reg2_out;
            end if; 
    end process ; -- address_selector

end architecture DataSelectorArch;