
-- CONDITION CODE REGISTER
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY CCReg IS
	PORT( 
		ZF,NF,CF : IN  std_logic;
		s 	     : IN  std_logic_vector (1 DOWNTO 0); --JmpCond
		out0 	 : OUT std_logic
	);
END ENTITY;

-- 00 ==> 1 (Jump)
-- 01 ==> 0 (Zero Flag)
-- 10 ==>   (Negative Flag)
-- 11 ==>   (Carry Flag)

ARCHITECTURE Mux_Arch OF CCReg is
BEGIN

	Out0 <= '1' when S = "00"
		else ZF when S = "01"
		else NF when S = "10"
		else CF when S = "11"
		else '1';
			
END ARCHITECTURE;

-- Out0 <= '1' when S = "00"
-- else ZF when S = "01"
-- else NF when S = "10"
-- else CF when S = "11"
-- else '1';


-- PROCESS(s,ZF,NF,CF)
-- BEGIN
-- 	CASE s IS
-- 	WHEN "00" => 
-- 			out0 <= '1';
-- 	WHEN "01" => 
-- 			out0 <= ZF;
-- 	WHEN "10" => 
-- 			out0 <= NF;
-- 	WHEN "11" => 
-- 			out0 <= CF;
-- 	WHEN OTHERS => --Bec there are 81 cases and we are only using 4 cases
-- 			out0 <= '1'; 
-- 	END CASE;
-- END PROCESS;