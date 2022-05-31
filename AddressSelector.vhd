

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.all;

entity AddressSelector is
    port (
        clk: in std_logic;
        sp_or_pc_control: in std_logic;
        struct_hazard_control: in std_logic;
        int_control: in std_logic;

        from_alu_out: in std_logic_vector(31 downto 0);
        from_adder_out: in std_logic_vector(31 downto 0);
        from_pc_out: in std_logic_vector(31 downto 0);
        from_sp_out: in std_logic_vector(31 downto 0);

        mem_address: out std_logic_vector(31 downto 0)
    );
end entity AddressSelector;

architecture AddressSelectorArch of AddressSelector is
    
begin


    mem_address <=  from_alu_out when sp_or_pc_control = '0' and struct_hazard_control = '0' and int_control = '0'
            else    from_pc_out when sp_or_pc_control = '0' and struct_hazard_control = '1' and int_control = '0'
            else    from_adder_out when int_control = '1' and sp_or_pc_control = '0'
            else    from_sp_out when sp_or_pc_control = '1' 
            else    (others => '0');  
        
    
end architecture AddressSelectorArch;