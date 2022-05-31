LIBRARY ieee;
USE IEEE.numeric_std.ALL;
USE ieee.std_logic_1164.ALL;

ENTITY ALU IS
	GENERIC (n : INTEGER := 32);
	PORT (
		inp1, inp2 : IN STD_LOGIC_VECTOR (n - 1 DOWNTO 0); --Inputs
		opr : IN STD_LOGIC_VECTOR (3 DOWNTO 0); --Operation to be done, take only 4 bits (2->5)
		result_output : OUT STD_LOGIC_VECTOR (n - 1 DOWNTO 0); --Result of operation
		zero_flag, negative_flag, carry_flag : OUT STD_LOGIC; --Flags
		flags_enable : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)); --Flags Enable, 0->Zero, 1->Neg, 2->Carry
END ENTITY ALU;

ARCHITECTURE arch1 OF ALU IS
	SIGNAL result : STD_LOGIC_VECTOR(n DOWNTO 0); --The output of the operation
	SIGNAL carry_add, carry_sub : STD_LOGIC; --Carry resulted from add/sub operation

	Signal Inp2_Mod_ADDI : std_logic_vector(31 downto 0);
	Signal Z : std_logic_vector(15 downto 0);
BEGIN

	Z <= (Others => '0');

	Inp2_Mod_ADDI <= Z & inp2 (15 downto 0);
	
	--Update results based on operation
	WITH opr SELECT
		result <= '0' & NOT inp1 WHEN "0010", --NOT
		STD_LOGIC_VECTOR( unsigned('0' & inp1) + to_unsigned(1, n + 1)) WHEN "0011", --INC

		STD_LOGIC_VECTOR((unsigned( '0'& (inp1))) + unsigned('0'& (inp2))) WHEN "0100" |"1000" | "1001", --ADD/LDD/STD
		
		STD_LOGIC_VECTOR((unsigned( '0'& (inp1))) + unsigned('0'& (Inp2_Mod_ADDI))) WHEN "0111", -- IADD/

		STD_LOGIC_VECTOR((unsigned( '0'& (inp1))) - unsigned('0'& (inp2)))WHEN "0101", --SUB
		
		'0' & (inp1 AND inp2) WHEN "0110", --AND	

		'0' & inp1 when "1010" | "1100", ----- Move | OUT 

		(Others=>'0') WHEN OTHERS;
        --Update carry value
	WITH opr SELECT
		carry_flag <= '1' WHEN "0001", --SETC
		result(n) WHEN OTHERS; --ADD/IADD/SUB
	--Update zero flag
	zero_flag <= '1' WHEN unsigned(result(n - 1 DOWNTO 0)) = to_unsigned(0, 32) ELSE
		'0';
	--Update negative flag
	negative_flag <= '1' WHEN result(n - 1) = '1' ELSE
		'0';

	--Update flags enable signals
	WITH opr SELECT
		flags_enable <= "100" WHEN "0001", --SETC
		"011" WHEN "0010" | "0110" , --NOT/AND	
		"111" WHEN "0011" | "0100" | "0111" | "0101", --INC/ADD/IADD/SUB	
		"000" WHEN OTHERS;
	result_output <= result(n - 1 DOWNTO 0);

END arch1;
