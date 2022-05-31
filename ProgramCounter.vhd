
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.all;

entity ProgramCounter is
    port (
        clk, rst, en : IN std_logic;

        -- hazard_control: in std_logic;

        call_control: in std_logic;
        branch_control: in std_logic;
        --hlt_control: in std_logic;
        int_control: in std_logic;
        ret_operation: in std_logic;


        from_mem_out: in std_logic_vector(31 downto 0);
        offset_address: in std_logic_vector(31 downto 0);

        -- pc_in       : IN  std_logic_vector(31 downto 0);
        pc_out      : OUT std_logic_vector(31 downto 0);
        pc_inc: out std_logic_vector(31 downto 0)

    );
end entity ProgramCounter;

architecture ProgramCounterArch of ProgramCounter is

    signal internal2: std_logic_vector(31 downto 0);

begin
    
    prog_counter: process(clk, rst)
    variable internal : std_logic_vector(31 downto 0);
    begin
        if rst = '1' then
            internal := from_mem_out;
            pc_out <= from_mem_out;
            internal2 <= from_mem_out;
           
        elsif rising_edge(clk) and en = '1' then
            if call_control = '1' or branch_control = '1' then 
                --pc_out <= offset_address;
                internal := offset_address;

            -- [INT index] or [RET][RTI]
            elsif int_control = '1' or ret_operation = '1' then
                --pc_out <= from_mem_out;
                internal := from_mem_out;
            
            else    
                internal := std_logic_vector(to_unsigned(to_integer(unsigned(internal)) + 1, 32));
                
            end if;

            pc_out <= internal;
            internal2 <= internal;

        end if;   
    end process prog_counter;

    pc_inc <= std_logic_vector(to_unsigned(to_integer(unsigned(internal2)) + 1, 32));
    
end architecture ProgramCounterArch;   