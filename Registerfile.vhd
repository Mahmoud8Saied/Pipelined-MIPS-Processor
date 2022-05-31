library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.all;

entity RegisterFile is
    port (
        RegWrite     : In std_logic;
        clk, rst     : In std_logic;
        Rs1, Rs2     : In std_logic_vector(4 downto 0);
        RD           : In std_logic_vector(4 downto 0);
        WriteData    : In std_logic_vector(31 downto 0);

        ReadData1    : Out std_logic_vector(31 downto 0); 
        ReadData2    : Out std_logic_vector(31 downto 0)
    );
end entity RegisterFile;

architecture rtl of RegisterFile is

    TYPE reg_type IS ARRAY(0 TO 7) OF std_logic_vector(31 DOWNTO 0);
    signal Register_File : reg_type;
    
begin

  proc_name: process(clk, rst)
  begin
      if rst = '1' then

        Register_File (0) <= (Others => '0');
        Register_File (1) <= (Others => '0');
        Register_File (2) <= (Others => '0');
        Register_File (3) <= (Others => '0');
        Register_File (4) <= (Others => '0');
        Register_File (5) <= (Others => '0');
        Register_File (6) <= (Others => '0');
        Register_File (7) <= (Others => '0');
          
      elsif falling_edge(clk) and RegWrite = '1' then

        Register_File (to_integer(unsigned(RD))) <= WriteData;
          
      end if;
  end process proc_name;
    

  ReadData1 <= Register_File (to_integer(unsigned(Rs1)));
  ReadData2 <= Register_File (to_integer(unsigned(Rs2)));

end architecture rtl;