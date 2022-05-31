LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY Mux2x1 IS
	PORT ( 
		in0,in1: IN  std_logic_vector(31 downto 0);
		sel    : IN  std_logic;
		out0   : OUT std_logic_vector(31 downto 0));
END ENTITY;

ARCHITECTURE Mux2x1_Arch OF Mux2x1 is
	BEGIN	
		out0 <= in0 when sel = '0'
		else	in1 when sel = '1'; 
		--else	(others => '0'); --uncomment and remove above ;
END ARCHITECTURE;