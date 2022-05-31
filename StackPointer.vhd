library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.all;

entity StackPointer is
    port (
        clk, rst: in std_logic;
        en : IN std_logic;

        mem_write_control: IN std_logic;
        sp_or_pc_control: in std_logic;

        -- sp_in       : IN  std_logic_vector(31 downto 0);
        sp_out      : OUT std_logic_vector(31 downto 0)

    );
end entity StackPointer;

architecture StackPointerArch of StackPointer is
    signal out_sig: std_logic_vector(31 downto 0);
begin
    
    stack_pointer: process(clk, rst)
        variable internal: std_logic_vector(31 downto 0);
        variable out_var: std_logic_vector(31 downto 0);
    begin
        -- SP starts from the last memory address (2^20)-1
        if rst = '1' then
            internal := x"0000001f";    -- ! is to be changed
            out_var := internal;
           
        elsif rising_edge(clk) and en = '1' then
            -- SP is selected, PUSH something in the stack
            if sp_or_pc_control = '1' and mem_write_control = '1' then
                out_var := internal;
                internal := std_logic_vector(to_unsigned(to_integer(unsigned(internal)) - 1, 32));
            -- POP something from the stack
            -- PC is selected or otherwise --
            end if;
    
        elsif falling_edge(clk) and en = '1' then
            if sp_or_pc_control = '1' and mem_write_control = '0' then
                internal := std_logic_vector(to_unsigned(to_integer(unsigned(internal)) + 1, 32));
                out_var := internal;
            end if;
        else
            out_var := internal;
        
        end if;

        out_sig <= out_var;
    end process stack_pointer;

    sp_out <= out_sig;
    
end architecture StackPointerArch;